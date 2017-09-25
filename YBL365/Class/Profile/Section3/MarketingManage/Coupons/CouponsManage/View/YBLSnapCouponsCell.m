//
//  YBLSnapCouponsCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSnapCouponsCell.h"
#import "YBLCouponsProgressView.h"

@interface YBLSnapCouponsCell ()

@property (nonatomic, strong) YBLCouponsProgressView *progressView;

@end

@implementation YBLSnapCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat cellHi = [YBLCouponsBaseCell getItemCellHeightWithModel:nil];
    
    self.bgImageView.image = [UIImage imageNamed:@"coupons_center_bg"];
    self.bgImageView.height = cellHi-space;
    self.bgImageView.top = space;

    UIImageView *goodbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, 0, self.bgImageView.height-space*2, self.bgImageView.height-space*2)];
    goodbgImageView.image = [UIImage imageNamed:@"coupons_good_bg"];
    goodbgImageView.centerY = self.bgImageView.height/2;
    [self.bgImageView addSubview:goodbgImageView];
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, goodbgImageView.width-4, goodbgImageView.height-4)];
    goodImageView.centerX = goodbgImageView.width/2;
    goodImageView.centerY = goodbgImageView.height/2;
    [goodbgImageView addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    CGFloat percentWi = self.bgImageView.width/4.2;
    
    UILabel *goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodbgImageView.right+space, 0, self.bgImageView.width-(goodbgImageView.right+space)-percentWi, self.bgImageView.height/2)];
    goodTitleLabel.numberOfLines = 2;
    goodTitleLabel.textColor = BlackTextColor;
    goodTitleLabel.font = YBLFont(13);
    [self.bgImageView addSubview:goodTitleLabel];
    self.goodTitleLabel = goodTitleLabel;
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodTitleLabel.left, goodTitleLabel.bottom, 50, goodTitleLabel.height-space)];
    valueLabel.font = YBLBFont(25);
    valueLabel.textColor = YBLThemeColor;
    [self.bgImageView addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.right, 0, 50, 20)];
    conditionLabel.textColor = YBLColor(212, 79, 78, 1);
    conditionLabel.backgroundColor = YBLColor(252, 244, 234, 1);
    conditionLabel.layer.cornerRadius = 2;
    conditionLabel.layer.masksToBounds = YES;
    conditionLabel.font = YBLFont(12);
    conditionLabel.textAlignment = NSTextAlignmentCenter;
    conditionLabel.centerY = self.valueLabel.centerY;
    [self.bgImageView addSubview:conditionLabel];
    self.conditionLabel = conditionLabel;
    
    self.progressView = [[YBLCouponsProgressView alloc] initWithFrame:CGRectMake(0, 0, percentWi, percentWi)];
    self.progressView.right = self.bgImageView.width;
    [self.bgImageView addSubview:self.progressView];
    
    self.stateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupons_got"]];
    self.stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.stateImageView.frame = CGRectMake(0, 0, percentWi*2/3, percentWi*2/3);
//    self.stateImageView.right = self.bgImageView.width;
    self.stateImageView.center = self.progressView.center;
    [self.bgImageView addSubview:self.stateImageView];
    self.stateImageView.hidden = YES;
    
    self.couponsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.couponsButton.frame = CGRectMake(0, 0, percentWi-2*space, 25);
    self.couponsButton.bottom = self.bgImageView.height-space;
    self.couponsButton.centerX = self.progressView.centerX;
    self.couponsButton.layer.cornerRadius = self.couponsButton.height/2;
    self.couponsButton.layer.masksToBounds = YES;
    self.couponsButton.titleLabel.font = YBLFont(12);
    self.couponsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.couponsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.couponsButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.couponsButton setBackgroundColor:YBLColor(240, 196, 70, 1) forState:UIControlStateSelected];
    [self.couponsButton setBackgroundColor:YBLColor(230, 230, 230, 1) forState:UIControlStateDisabled];
    [self.couponsButton setTitle:@"立即领取" forState:UIControlStateNormal];
    [self.couponsButton setTitle:@"去使用" forState:UIControlStateSelected];
    [self.couponsButton setTitle:@"已抢光" forState:UIControlStateDisabled];
    [self.bgImageView addSubview:self.couponsButton];

}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLCouponsModel *model = (YBLCouponsModel *)itemModel;
    self.valueLabel.text = model.js_value;
    self.valueLabel.width = model.js_value_width.floatValue;
    self.conditionLabel.text = model.js_condition;;
    self.conditionLabel.width = model.js_condition_width.floatValue+5;
    self.conditionLabel.left = self.valueLabel.right+5;
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.product.avatar_url] placeholderImage:smallImagePlaceholder];
    self.goodTitleLabel.text = model.product.title;
    self.progressView.progress = model.js_progress_percent.floatValue;
    self.couponsButton.enabled = YES;
    self.couponsButton.selected  = NO;
    switch (model.couponsState) {
        case CouponsCenterStateNormal:
        {
            self.couponsButton.selected  = NO;
//            self.couponsButton.enabled = YES;
            self.stateImageView.hidden = YES;
            self.progressView.hidden = NO;
        }
            break;
        case CouponsCenterStateOut:
        {
//            self.couponsButton.selected  = YES;
            self.couponsButton.enabled = NO;
            self.stateImageView.hidden = YES;
            self.progressView.hidden = NO;
        }
            break;
        case CouponsCenterStateUsed:
        {
//            self.couponsButton.enabled = YES;
            self.couponsButton.selected  = YES;
            self.stateImageView.hidden = NO;
            self.progressView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return [super getItemCellHeightWithModel:@"coupons_center_bg"];
}

@end
