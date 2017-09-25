//
//  YBLGoodAllInfosViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodAllInfosViewController.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLGoodModel.h"
#import "YBLEditSaleDisplayAreaViewModel.h"
#import "YBLChangeDeliveryGoodViewModel.h"
#import "YBLGetProductShippPricesModel.h"
#import "YBLEditGoodViewModel.h"
#import "YBLCompanyTypesItemModel.h"

@interface YBLGoodAllInfosViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YBLGoodAllInfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.viewModel.titleString;
 
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.height -= kNavigationbarHeight;
    self.contentScrollView.backgroundColor = YBLColor(250, 250, 250, 1);
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    WEAK
    switch (self.viewModel.goodAllInfosType) {
        case GoodAllInfosTypeBaseVC:
        {
            //基本信息
            [self createBaseUI];
        }
            break;
        case GoodAllInfosTypePriceVC:
        {
            [[YBLEditGoodViewModel siganlForCompanyTypeID:nil] subscribeNext:^(id  _Nullable x) {
                STRONG
                self.viewModel.companyTypeDataArray = x;
                //价格
                [self createPriceUI];
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case GoodAllInfosTypeExpressVC:
        {
            [[YBLChangeDeliveryGoodViewModel getShippingPricesSiganlWithID:self.viewModel.productModel.id] subscribeNext:^(id  _Nullable x) {
                STRONG
                self.viewModel.expressDataArray = x;
                //物流
                [self createExpressUI];
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case GoodAllInfosTypePriceVCSaleAreaVC:
        {
            
            [[YBLEditSaleDisplayAreaViewModel siganlForGetAreaInfoWithID:self.viewModel.productModel.id] subscribeNext:^(YBLSalesDisplayPriceModel*  _Nullable x) {
                STRONG
                self.viewModel.saleDisPriceModel = x;
                //销售区域
                [self createSaleAreaUI];
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 基本信息
- (void)createBaseUI {

    NSInteger index = 0;
    CGFloat item_height = 0;
    for (YBLEditItemGoodParaModel *itemModel in self.viewModel.goodInfoDataArray) {
        
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space+item_height, YBLWindowWidth-2*space, item_height)];
        showLabel.textColor = YBLTextLightColor;
        NSString *valyu = @"";
        if (itemModel.value) {
            valyu = itemModel.value;
        }
        NSString *allValue = [NSString stringWithFormat:@"%@ %@",itemModel.title,valyu];
        showLabel.text = allValue;
        showLabel.font = YBLFont(13);
        showLabel.numberOfLines = 0;
        [self.contentScrollView addSubview:showLabel];

        CGSize texztSize = [allValue heightWithFont:YBLFont(13) MaxWidth:showLabel.width];
        showLabel.height = texztSize.height;
        item_height += texztSize.height+space;
        
        index++;
        if (index == self.viewModel.goodInfoDataArray.count) {
            self.contentScrollView.contentSize = CGSizeMake(YBLWindowWidth, showLabel.bottom+space);
        }
    }
}

#pragma mark - 价格
- (void)createPriceUI {
    
    CGFloat itemViewHi = 90;
    NSInteger index = 0;
    NSInteger orgin_index = 0;
    for (YBLCompanyTypePricesParaModel *priceModel in self.viewModel.productModel.company_type_prices) {
        if (priceModel.active.boolValue) {
            UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, itemViewHi*index, YBLWindowWidth, itemViewHi)];
            [self.contentScrollView addSubview:itemView];
            UILabel *storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, itemView.width-2*space, 20)];
            storeLabel.textColor = BlackTextColor;
            storeLabel.font = YBLFont(15);
            NSString *fin_com_name = [self getCurrentCompanyTypeStringWithID: priceModel.company_type_id];
            storeLabel.text = fin_com_name;
            [itemView addSubview:storeLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, storeLabel.bottom+space, 70, 15)];
            priceLabel.text = @"销售价格 : ";
            priceLabel.textColor = YBLTextLightColor;
            priceLabel.font = YBLFont(12);
            [itemView addSubview:priceLabel];
            
            UILabel *saleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, priceLabel.bottom+space, 70, 15)];
            saleCountLabel.text = @"起批数量 : ";
            saleCountLabel.textColor = YBLTextLightColor;
            saleCountLabel.font = YBLFont(12);
            [itemView addSubview:saleCountLabel];

            NSInteger index_2 = 0;
            CGFloat lessWi = (self.contentScrollView.width-priceLabel.right)/3;
            for (PricesItemModel *priceItemModel in priceModel.prices) {
                if (priceItemModel.active.boolValue) {
                    
                    UILabel *priceItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right+index_2*lessWi, priceLabel.top, lessWi, priceLabel.height)];
                    priceItemLabel.textColor = YBLTextLightColor;
                    priceItemLabel.font = YBLFont(12);
                    priceItemLabel.text = [NSString stringWithFormat:@"%.2f 元",priceItemModel.sale_price.doubleValue];
                    [itemView addSubview:priceItemLabel];
                    
                    UILabel *countItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(saleCountLabel.right+index_2*lessWi, saleCountLabel.top, lessWi, saleCountLabel.height)];
                    countItemLabel.textColor = YBLTextLightColor;
                    countItemLabel.font = YBLFont(12);
                    countItemLabel.text = [NSString stringWithFormat:@"%ld %@",(long)priceItemModel.min.integerValue,self.viewModel.productModel.unit];
                    [itemView addSubview:countItemLabel];
                    
                    index_2++;
                }
            }
            
            [itemView addSubview:[YBLMethodTools addLineView:CGRectMake(0, itemView.height-.5, itemView.width, .5)]];
            
            index++;
        }
        if (orgin_index == self.viewModel.productModel.company_type_prices.count-1) {
            self.contentScrollView.contentSize = CGSizeMake(YBLWindowWidth, (orgin_index+1)*itemViewHi+space);
        }
        orgin_index++;
    }
}

- (NSString *)getCurrentCompanyTypeStringWithID:(NSString *)_id{
    
    __block NSString *final_price = @"";
    [self.viewModel.companyTypeDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBLCompanyTypesItemModel *comTypeModel = (YBLCompanyTypesItemModel *)obj;
        if ([_id isEqualToString:comTypeModel._id]) {
            final_price = comTypeModel.title;
        }
    }];
    return final_price;
}

#pragma mark - 物流
- (void)createExpressUI {
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (YBLGetProductShippPricesModel *shipPriceModel in self.viewModel.expressDataArray) {
        [titleArray addObject:shipPriceModel.express_company.title];
        NSMutableArray *priceValueArray = [NSMutableArray array];
        for (area_prices *area_prices_model in shipPriceModel.area_prices) {
            NSString *final_price = [NSString stringWithFormat:@"%@(%.1f)",area_prices_model.area_text,area_prices_model.price.doubleValue];
            [priceValueArray addObject:final_price];
        }
        NSString *final_value = [YBLMethodTools getAppendingStringWithArray:priceValueArray appendingKey:@"、"];
        [valueArray addObject:final_value];
    }
    [self updateTitleArrat:titleArray textValueArray:valueArray];
}

#pragma mark - 销售区域
- (void)createSaleAreaUI {
    
    NSString *allSaleValueString = [YBLMethodTools getAppendingTitleStringWithArray:self.viewModel.saleDisPriceModel.sales_area appendingKey:@"、"];
    NSString *allDisplayValueString = [YBLMethodTools getAppendingTitleStringWithArray:self.viewModel.saleDisPriceModel.display_price_area appendingKey:@"、"];
    
    NSArray *titleArray = @[@"销售区域",@"不显示商品以及价格区域"];

    [self updateTitleArrat:titleArray textValueArray:@[allSaleValueString,allDisplayValueString]];
}

- (void)updateTitleArrat:(NSArray *)titleArray textValueArray:(NSArray *)textValueArray{
    
    NSInteger index = 0;
    
    CGFloat itemView_height = 0;
    
    for (NSString *allValue in textValueArray) {
        
        NSString *titleValue = titleArray[index];
        
        CGSize allValueSize = [allValue heightWithFont:YBLFont(13) MaxWidth:YBLWindowWidth-2*space];
        
        UIView *saleView = [[UIView alloc] initWithFrame:CGRectMake(0, itemView_height, YBLWindowWidth, 100)];
        saleView.backgroundColor = [UIColor whiteColor];
        [self.contentScrollView addSubview:saleView];
        
        UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, saleView.width, 40)];
        saleLabel.textColor = BlackTextColor;
        saleLabel.font = YBLFont(15);
        saleLabel.text = titleValue;
        saleLabel.textAlignment = NSTextAlignmentCenter;
        [saleView addSubview:saleLabel];
        
        UILabel *saleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, saleLabel.bottom, saleView.width-2*space, 20)];
        saleInfoLabel.textColor = YBLTextLightColor;
        saleInfoLabel.font = YBLFont(12);
        saleInfoLabel.numberOfLines = 0;
        saleInfoLabel.text = allValue;
        [saleView addSubview:saleInfoLabel];
        
        UIView *lineView = [YBLMethodTools addLineView:CGRectMake(0, saleView.height-.5, saleView.width, .5)];
        [saleView addSubview:lineView];
        
        saleInfoLabel.height = allValueSize.height;
        saleView.height = saleInfoLabel.bottom+space;
        lineView.bottom = saleView.height;
        itemView_height += saleView.height;
        
        if (index == textValueArray.count-1) {
            self.contentScrollView.contentSize = CGSizeMake(YBLWindowWidth, saleView.bottom+space);
        }
        
        index++;
    }
    
}


@end
