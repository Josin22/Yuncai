//
//  YBLAddAreaAndExpressCompanyView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddAreaAndExpressCompanyView.h"
#import "YBLFourLevelAddressHeaderView.h"
#import "YBLEditPurchaseCell.h"
#import "YBLChooseGoodLogisticsCompanyCollectionView.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLExpressPriceTableView.h"
#import "YBLGetProductShippPricesModel.h"
#import "YBLAddressAreaModel.h"
#import "YBLChooseDeliveryViewModel.h"

#define TOP  YBLWindowHeight/8

static YBLAddAreaAndExpressCompanyView *addAreaAndExpressCompanyView = nil;

@interface YBLAddAreaAndExpressCompanyView ()

@property (nonatomic, weak  ) UIViewController *Vc;

@property (nonatomic, strong) YBLFourLevelAddressHeaderView *fourAddressView;

@property (nonatomic, strong) YBLChooseGoodLogisticsCompanyCollectionView *collectionView;

@property (nonatomic, strong) YBLExpressPriceTableView *shippingPriceTableView;

@property (nonatomic, strong) NSMutableArray *allExpressCompanyDataArray;

@property (nonatomic, strong) NSMutableArray *addToAreaAddressArray;

@property (nonatomic, copy  ) AddAreaAndExpressCompanyViewSelectBlock addAreaAndExpressCompanyViewSelectBlock;

@end

@implementation YBLAddAreaAndExpressCompanyView

+ (void)showAddAreaAndExpressCompanyViewFromVC:(UIViewController *)Vc selectHandle:(AddAreaAndExpressCompanyViewSelectBlock)selectBlock{
    
    if (!addAreaAndExpressCompanyView) {
        addAreaAndExpressCompanyView = [[YBLAddAreaAndExpressCompanyView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        addAreaAndExpressCompanyView.Vc = Vc;
        addAreaAndExpressCompanyView.addAreaAndExpressCompanyViewSelectBlock = selectBlock;
    }
    [YBLMethodTools transformOpenView:addAreaAndExpressCompanyView.contentView SuperView:addAreaAndExpressCompanyView fromeVC:addAreaAndExpressCompanyView.Vc Top:TOP];
}

- (NSMutableArray *)allExpressCompanyDataArray{
    if (!_allExpressCompanyDataArray) {
        _allExpressCompanyDataArray = [NSMutableArray array];
    }
    return _allExpressCompanyDataArray;
}

- (NSMutableArray *)addToAreaAddressArray{
    if (!_addToAreaAddressArray) {
        _addToAreaAddressArray = [NSMutableArray array];
    }
    return _addToAreaAddressArray;
}

- (void)addSubvieToContentView{
    
    WEAK
    self.contentView.height = YBLWindowHeight-TOP;
    self.bgView.alpha = 0.1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    titleLabel.text = @"添加已开通快递物流区域";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, titleLabel.width, .5)]];
    
    CGFloat itemHi = 80;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemHi, itemHi);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[YBLChooseGoodLogisticsCompanyCollectionView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.contentView.width, itemHi) collectionViewLayout:layout];
    self.collectionView.backgroundColor = YBLColor(242, 242, 242, 1);
    self.collectionView.chooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock = ^(YBLExpressCompanyItemModel *model) {
        STRONG
        if (model.is_select) {
            [self.addToAreaAddressArray insertObject:model atIndex:0];
        } else {
            [self.addToAreaAddressArray removeObject:model];
        }
        self.shippingPriceTableView.dataArray = self.addToAreaAddressArray;
    };
    [self.contentView addSubview:self.collectionView];
    
    CGFloat fourAddressHeight = [YBLFourLevelAddressHeaderView getHeaderViewHeight];
    self.fourAddressView = [[YBLFourLevelAddressHeaderView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom+space, self.contentView.width, fourAddressHeight)];
    [self.contentView addSubview:self.fourAddressView];

    self.shippingPriceTableView = [[YBLExpressPriceTableView alloc] initWithFrame:CGRectMake(0, self.fourAddressView.bottom, self.contentView.width, self.contentView.height-self.fourAddressView.bottom-buttonHeight) style:UITableViewStylePlain];
    [self.contentView addSubview:self.shippingPriceTableView];
    
    UIButton *doneButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, self.contentView.height-buttonHeight, self.contentView.width, buttonHeight)];
    [doneButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.contentView addSubview:doneButton];
    
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (self.fourAddressView.viewModel.selectAreaDataDict.count==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选中地区~"];
            return ;
        }
        if (self.addToAreaAddressArray.count==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选中物流快递~"];
            return;
        }
        //handle data
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        for (YBLExpressCompanyItemModel *model in self.addToAreaAddressArray) {
            NSMutableArray *all_area_price_array = [NSMutableArray array];
            for (YBLAddressAreaModel *areaModel in [self.fourAddressView.viewModel.selectAreaDataDict allValues]) {
                area_prices *areaPriceModel = [area_prices new];
                areaPriceModel.area_id = [NSString stringWithFormat:@"%@",areaModel.id];
                areaPriceModel.area_text = areaModel.text;
                if (!model.price) {
                    model.price = @(0);
                }
                areaPriceModel.price = model.price;
                areaPriceModel.expressCompanyName = model.title;
                [all_area_price_array addObject:areaPriceModel];
            }
            [itemDict setObject:all_area_price_array forKey:model.id];
        }
        
        BLOCK_EXEC(addAreaAndExpressCompanyView.addAreaAndExpressCompanyViewSelectBlock,itemDict)
        
        [self dismiss];
    }];

    /**/
    [self requestAllExpressData];
}


- (void)requestAllExpressData{
    
    [[YBLChooseDeliveryViewModel validExpressCompaniesSiganl] subscribeNext:^(NSMutableArray*  _Nullable x) {
        self.allExpressCompanyDataArray = x;
        self.collectionView.dataArray = self.allExpressCompanyDataArray;
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:addAreaAndExpressCompanyView.contentView SuperView:addAreaAndExpressCompanyView fromeVC:addAreaAndExpressCompanyView.Vc Top:YBLWindowHeight completion:^(BOOL finished) {
        [addAreaAndExpressCompanyView removeFromSuperview];
        addAreaAndExpressCompanyView = nil;
    }];
    
}

@end
