//
//  YBLCouponsCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsCell.h"

@implementation YBLCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    //减
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.width/3, self.bgImageView.height*3/5)];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font  =YBLFont(14);
    [self.bgImageView addSubview:valueLabel];
    self.valueLabel = valueLabel;
    //满
    UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, valueLabel.bottom, valueLabel.width, 15)];
    conditionLabel.textAlignment = NSTextAlignmentCenter;
    conditionLabel.textColor = [UIColor whiteColor];
    conditionLabel.font  =YBLFont(12);
    [self.bgImageView addSubview:conditionLabel];
    self.conditionLabel = conditionLabel;
    
    UILabel *couponsTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.right+space/2, 0, self.bgImageView.width*2/3-space, (self.bgImageView.height*2/3))];
    couponsTextLabel.numberOfLines = 2;
    couponsTextLabel.font = YBLFont(13);
    couponsTextLabel.textColor = BlackTextColor;
    [self.bgImageView addSubview:couponsTextLabel];
    self.couponsTextLabel = couponsTextLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponsTextLabel.left, self.bgImageView.height-couponsTextLabel.height/2, couponsTextLabel.width, couponsTextLabel.height/2)];
    timeLabel.font = YBLFont(11);
    timeLabel.textColor = YBLTextColor;
    [self.bgImageView addSubview:timeLabel];
    self.timeLabel = timeLabel;
//    
//    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponsTextLabel.left, 0, couponsTextLabel.width, self.bgImageView.height/3)];
//    stateLabel.font = YBLFont(11);
//    stateLabel.textColor = YBLTextColor;
//    [self.bgImageView addSubview:stateLabel];
//    self.stateLabel = stateLabel;
//    
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLCouponsModel *model = (YBLCouponsModel *)itemModel;
    self.valueLabel.attributedText = model.js_att_value;
    self.conditionLabel.text = model.js_condition;
    self.couponsTextLabel.text = model.product.title;
    self.timeLabel.text = model.js_full_time;
    UIImage *couponsImage = nil;
    if ([model.state isEqualToString:@"running"]) {
        couponsImage = [UIImage imageNamed:@"Coupons_enable_bg"];
    } else {
        couponsImage = [UIImage imageNamed:@"Coupons_disable_bg"];
    }
    self.self.bgImageView.image = couponsImage;

}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return [super getItemCellHeightWithModel:itemModel];
}


@end
