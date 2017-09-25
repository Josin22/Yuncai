//
//  YBLOrderGoodCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderGoodCell.h"
#import "lineitems.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOrderGoodCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, retain) UILabel     *goodNameLable;
//@property (nonatomic, retain) UILabel     *spcLabel;
@property (nonatomic, retain) UILabel     *priceLabel;
@property (nonatomic, retain) UILabel     *numLabel;
@property (nonatomic, retain) UILabel     *expressPriceLabel;
@property (nonatomic, strong) UIView      *noStockView;

@end

@implementation YBLOrderGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat hi = [YBLOrderGoodCell getOrderGoodCellHi];
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, hi-2*space, hi-2*space)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    goodImageView.layer.borderColor = YBLLineColor.CGColor;
    goodImageView.layer.masksToBounds = YES;
    goodImageView.layer.cornerRadius = 3;
    goodImageView.layer.borderWidth = 0.5;
    [self.contentView addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    self.noStockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, goodImageView.width, goodImageView.height)];
    self.noStockView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self.goodImageView addSubview:self.noStockView];
    self.noStockView.hidden = YES;
    
    UIImageView *noStockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_car_no_stock"]];
    [self.noStockView addSubview:noStockImageView];
    [noStockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.bottom.equalTo(@-10);
    }];
    
    CGFloat itemHi = goodImageView.height/3;
    
    UILabel *goodNameLable = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, itemHi)];
    goodNameLable.numberOfLines = 1;
    goodNameLable.text = loadString;
    goodNameLable.textColor = BlackTextColor;
    goodNameLable.font = YBLFont(14);
    [self.contentView addSubview:goodNameLable];
    self.goodNameLable = goodNameLable;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLable.left, goodNameLable.bottom, goodNameLable.width,goodNameLable.height)];
    priceLabel.font = YBLFont(17);
    priceLabel.textColor = YBLThemeColor;
    priceLabel.text = loadString;
    [self.contentView addSubview:priceLabel];
    self.priceLabel =priceLabel;
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, priceLabel.width/3, priceLabel.height)];
    numLabel.text = loadString;
    numLabel.font = YBLFont(11);
    numLabel.textColor = YBLTextColor;
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
    
    UILabel *expressPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.right, numLabel.top, priceLabel.width*2/3, numLabel.height)];
    [self.contentView addSubview:expressPriceLabel];
    expressPriceLabel.textAlignment = NSTextAlignmentRight;
    expressPriceLabel.font = YBLFont(11);
    expressPriceLabel.textColor = YBLTextColor;
    self.expressPriceLabel = expressPriceLabel;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(goodImageView.left, hi-0.5, YBLWindowWidth-goodImageView.left, 0.5)]];
}

- (void)updateItemsModel:(id)model{
 
    if ([model isKindOfClass:[lineitems class]]) {
        lineitems *lineItemModel = (lineitems *)model;
        //商品图
        [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:lineItemModel.product.avatar_url]
                                    placeholderImage:smallImagePlaceholder];
        //商品名
        self.goodNameLable.text = lineItemModel.product.title;
        // 物流价格
        NSString *expressName = @"";
        if ([lineItemModel.express_company isEqualToString:@"mine"]) {
            expressName = [NSString stringWithFormat:@"商家自配(%.2f)",lineItemModel.shipping_price.doubleValue];
        } else {
            NSString *expressCompany = @"";
            if (lineItemModel.express_company) {
                expressCompany = lineItemModel.express_company;
            }
            expressName = [NSString stringWithFormat:@"%@(%.2f)",expressCompany,lineItemModel.shipping_price.doubleValue];
        }
        self.expressPriceLabel.text = expressName;
        //价格
        NSString *price = [NSString stringWithFormat:@"%.2f",lineItemModel.price.doubleValue];
        self.priceLabel.attributedText = [NSString price:price color:YBLThemeColor font:17];
        //数量
        self.numLabel.text = [NSString stringWithFormat:@"%d%@",lineItemModel.quantity.intValue,lineItemModel.product.unit];
        
        self.goodNameLable.textColor = BlackTextColor;
        //判断库存
        if (lineItemModel.no_permit_check_result.no_permit.boolValue) {
            self.noStockView.hidden = NO;
        } else {
            self.noStockView.hidden = YES;
        }
        
    } else {
        YBLPurchaseOrderModel *purchaseModel = (YBLPurchaseOrderModel *)model;
        //商品图
        [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:purchaseModel.avatar] placeholderImage:smallImagePlaceholder];
        //商品名
        self.goodNameLable.text = purchaseModel.title;
        // 描述
//        self.spcLabel.text = purchaseModel.specification;
        //价格
        NSString *price = [NSString stringWithFormat:@"%.2f",purchaseModel.bidder_price.doubleValue];
        self.priceLabel.attributedText = [NSString price:price color:YBLThemeColor font:17];
        //数量
        self.numLabel.text = [NSString stringWithFormat:@"%d%@",purchaseModel.quantity.intValue,purchaseModel.unit];
        
    }
    
}

- (void)updateExpressCompanyPriceModel:(YBLTakeOrderParaLineItemsModel *)itemMode{
    
    
}

+ (CGFloat)getOrderGoodCellHi{
    
    return 80;
}

@end
