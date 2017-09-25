//
//  YBLGoodsWholesalePriceCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsWholesalePriceCell.h"
#import "YBLCompanyTypePricesParaModel.h"
#import "YBLGoodModel.h"

static NSInteger Label_CountWholesale_Tag = 23;

static NSInteger Label_PriceWholesale_Tag = 60;

@interface YBLGoodsWholesalePriceCell ()

@property (nonatomic, retain) UILabel *goodsSpecLabel;

@property (nonatomic, retain) UILabel *goodsQcodeLabel;

@end

@implementation YBLGoodsWholesalePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createWholesaleUI];
    }
    return self;
}

- (void)createWholesaleUI{
    
    CGFloat wi = YBLWindowWidth/3-space;
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *priceWholesaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*wi+space, 0, wi, 30)];
        priceWholesaleLabel.tag = Label_PriceWholesale_Tag+i;
        priceWholesaleLabel.textAlignment = NSTextAlignmentLeft;
        priceWholesaleLabel.attributedText = [NSString stringPrice:@"¥ 0.00" color:YBLThemeColor font:22 isBoldFont:YES appendingString:nil];
        [self addSubview:priceWholesaleLabel];
        priceWholesaleLabel.hidden = YES;
        
        UILabel *countWholesaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(priceWholesaleLabel.frame), CGRectGetMaxY(priceWholesaleLabel.frame), priceWholesaleLabel.width, 15)];
        countWholesaleLabel.text = @"0-0";
        countWholesaleLabel.textAlignment = NSTextAlignmentLeft;
        countWholesaleLabel.font = YBLFont(12);
        countWholesaleLabel.textColor = YBLTextColor;
        countWholesaleLabel.tag = Label_CountWholesale_Tag+i;
        [self addSubview:countWholesaleLabel];
        countWholesaleLabel.hidden = YES;

    }
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    NSArray *pricesArray = goodModel.prices.filter_prices;
    if (pricesArray.count==0) {
        [self noPriceSetting];
        return;
    }
    NSInteger index = 0;
    for (PricesItemModel *priceModel in pricesArray) {
        UILabel *priceWholesaleLabel = (UILabel *)[self viewWithTag:Label_PriceWholesale_Tag+index];
        UILabel *countWholesaleLabel = (UILabel *)[self viewWithTag:Label_CountWholesale_Tag+index];
        priceWholesaleLabel.hidden = NO;
        countWholesaleLabel.hidden = NO;
        double value =  priceModel.sale_price.doubleValue;
        if (value>0) {
//            priceWholesaleLabel.text = [NSString stringWithFormat:@"%.2f",value];
            priceWholesaleLabel.attributedText = [NSString price:[NSString stringWithFormat:@"%.2f",value] color:YBLThemeColor font:22];
            NSString *nameText = [NSString stringWithFormat:@"%ld%@起批",(long)priceModel.min.integerValue,goodModel.unit];
            countWholesaleLabel.text = nameText;
            priceWholesaleLabel.hidden = NO;
            countWholesaleLabel.hidden = NO;
        } else {
            priceWholesaleLabel.hidden = YES;
            countWholesaleLabel.hidden = YES;
        }
        if (index == 0 && value == 0) {
            [self noPriceSetting];
        }
        index++;
    }
}

- (void)noPriceSetting{
    
    UILabel *priceWholesaleLabel = (UILabel *)[self viewWithTag:Label_PriceWholesale_Tag];
    UILabel *countWholesaleLabel = (UILabel *)[self viewWithTag:Label_CountWholesale_Tag];
    priceWholesaleLabel.text = @"¥0.00";
    priceWholesaleLabel.textColor = YBLThemeColor;
    priceWholesaleLabel.hidden = NO;
    countWholesaleLabel.hidden = YES;
}

+ (CGFloat)getWholesalePriceCellHeight{
    return 45;
}

@end
