//
//  YBLOrderMMGoodsDetailInfoCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailInfoCell.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOrderMMGoodsDetailInfoCell ()

@property (nonatomic, retain) YBLLabel *nameLabel;

@property (nonatomic, retain) YBLLabel *priceLabel;

@property (nonatomic, retain) UILabel *quantityLabel;

@property (nonatomic, strong) UIImageView *shouzhi;

@end

@implementation YBLOrderMMGoodsDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createInfoUI];
    }
    return self;
}

- (void)createInfoUI{

    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat hi = [YBLOrderMMGoodsDetailInfoCell getGoodsDetailInfoCellHeight];
    
    //title
    YBLLabel *nameLabel = [[YBLLabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-2*space, 48)];
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = BlackTextColor;
    nameLabel.font = YBLFont(16);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //xiang
    YBLLabel *priceLabel = [[YBLLabel alloc] initWithFrame:CGRectMake(space, nameLabel.bottom, YBLWindowWidth/2-space, 20)];
    priceLabel.textColor = YBLThemeColor;
    priceLabel.font = YBLFont(16);
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //手指
    UIImageView *shouzhi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purchase_shouzhi"]];
    shouzhi.frame = CGRectMake(YBLWindowWidth-space-15, 0, 15, 35);
    shouzhi.contentMode = UIViewContentModeScaleAspectFit;
    shouzhi.centerY = priceLabel.centerY-10;
    [self.contentView addSubview:shouzhi];
    self.shouzhi = shouzhi;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, priceLabel.bottom+space-.5, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
    
    //采购要求
    UIButton *askButton = [UIButton buttonWithType:UIButtonTypeCustom];
    askButton.frame = CGRectMake(0, priceLabel.bottom+space, YBLWindowWidth, 40);
    [self.contentView addSubview:askButton];
    self.askButton = askButton;
    
    UILabel *askLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, 20)];
    askLabel.text = @"采购要求";
    askLabel.textColor = BlackTextColor;
    askLabel.font = YBLFont(14);
    askLabel.centerY = self.askButton.height/2;
    [askButton addSubview:askLabel];
    
    self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(YBLWindowWidth/2, 0, 100, 20)];
    self.quantityLabel.font = YBLFont(14);
    self.quantityLabel.centerY = self.askButton.height/2;
    self.quantityLabel.textColor = YBLTextColor;
    [askButton addSubview:self.quantityLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(YBLWindowWidth-space-8, 0, 8, 16.5);
    arrowImageView.centerY = self.askButton.height/2;
    [askButton addSubview:arrowImageView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(space, hi-.5, YBLWindowWidth-space, 0.5)];
    lineView1.backgroundColor = YBLLineColor;
    [self addSubview:lineView1];
    
}

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
    self.nameLabel.text = model.title;
    
    NSString *priceValue = [NSString stringWithFormat:@"%.2f /%@",model.price.doubleValue,model.unit];;
    
    self.priceLabel.attributedText = [NSString price:priceValue color:YBLThemeColor font:20];
    
    self.quantityLabel.text = [NSString stringWithFormat:@"X %d %@",model.quantity.intValue,model.unit];
    
    /* 移动 */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = .8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = [NSValue valueWithCGPoint:self.shouzhi.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.shouzhi.centerX, self.shouzhi.centerY+10)];
    // 添加动画
    [self.shouzhi.layer addAnimation:animation forKey:@"move-layer"];
}

+ (CGFloat)getGoodsDetailInfoCellHeight{
    
    return 118;
}

@end
