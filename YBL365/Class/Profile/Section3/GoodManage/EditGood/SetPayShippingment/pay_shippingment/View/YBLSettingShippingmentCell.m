//
//  YBLSettingShippingmentCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingShippingmentCell.h"
#import "payshippingment_model.h"
#import "YBLShowPayShippingsmentModel.h"

@interface YBLSettingShippingmentCell ()

@end

@implementation YBLSettingShippingmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cteateUI];
    }
    return self;
}

- (void)cteateUI{
    
    CGFloat hi = [YBLSettingShippingmentCell getItemCellHeightWithModel:nil];
    
    CGFloat buttonWi = YBLWindowWidth/4-space;
    CGFloat buttonHi = 30;
    
    self.itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itemButton.frame = CGRectMake(space, 0, buttonWi, buttonHi);
    [self.itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    self.itemButton.titleLabel.font = YBLFont(13);
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.centerY = hi/2;
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.layer.borderWidth = .5;
    self.itemButton.layer.borderColor = YBLLineColor.CGColor;
    [self.contentView addSubview:self.itemButton];
    
    CGFloat sameHi = 16;
    
    self.defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultButton.frame = CGRectMake(self.itemButton.right+space, 0, self.itemButton.width/2, sameHi);
    self.defaultButton.layer.cornerRadius = sameHi/2;
    self.defaultButton.layer.masksToBounds = YES;
    self.defaultButton.centerY = hi/2;
    [self.defaultButton setTitle:@"默认" forState:UIControlStateNormal];
    self.defaultButton.titleLabel.font = YBLFont(10);
    [self.defaultButton setBackgroundColor:YBLColor(210, 210, 210, 1) forState:UIControlStateNormal];
    [self.defaultButton setBackgroundColor:YBLColor(6, 156, 22, 1) forState:UIControlStateSelected];
    [self.contentView addSubview:self.defaultButton];
    
    self.textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.textButton.frame = CGRectMake(self.defaultButton.right+space, 0, YBLWindowWidth-2*space-self.defaultButton.right-buttonHi, buttonHi);
    self.textButton.centerY = hi/2;
    [self.textButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.textButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    self.textButton.titleLabel.font = YBLFont(14);
    [self.contentView addSubview:self.textButton];
    
    self.arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.arrowButton.frame = CGRectMake(YBLWindowWidth-buttonHi, 0, buttonHi, buttonHi);
    [self.arrowButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    self.arrowButton.centerY = hi/2;
    [self.contentView addSubview:self.arrowButton];
    
//    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, 0, YBLWindowWidth-space, .5)]];
}


- (void)updateItemCellModel:(id)itemModel{
    
    YBLShowPayShippingsmentModel *shipping_model = (YBLShowPayShippingsmentModel *)itemModel;
    NSString *sef_code = nil;
    NSString *sef_name = nil;
    if (shipping_model.shipping_method) {
        sef_code = shipping_model.shipping_method.code;
        sef_name = shipping_model.shipping_method.name;
    }
    self.itemButton.selected = shipping_model.is_select;
    [self.itemButton setTitle:sef_name forState:UIControlStateNormal];
    self.defaultButton.selected = shipping_model.is_default.boolValue;
    NSInteger count = 0;
    self.arrowButton.hidden = NO;
    if ([sef_code isEqualToString:@"tcps"]) {
        //同城配送  --->>当前城市
        count = shipping_model.radius_prices.count;
        
    } else if ([sef_code isEqualToString:@"shsm"]){
        //送货上门  -->>全国
        count = shipping_model.area_text.count;
        
    } else if ([sef_code isEqualToString:@"smzt"]) {
        //上门自提  --->>自提地址库
        count = shipping_model.addresses.count;
    } else if ([sef_code isEqualToString:@"wlzt"]) {
        self.arrowButton.hidden = YES;
    }
    if (count!=0) {
        NSString *textString = [NSString stringWithFormat:@"%ld",(long)count];
        [self.textButton setTitle:textString forState:UIControlStateNormal];
    } else {
        [self.textButton setTitle:nil forState:UIControlStateNormal];
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 50;
}

@end
