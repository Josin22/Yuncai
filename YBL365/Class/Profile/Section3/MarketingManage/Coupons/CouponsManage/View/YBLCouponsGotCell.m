//
//  YBLCouponsGotCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsGotCell.h"

@implementation YBLCouponsGotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCouponsGotCellUI];
    }
    return self;
}

- (void)createCouponsGotCellUI{
    
    UIButton *gotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gotButton.frame = CGRectMake(0, 0, 70, 25);
    [gotButton setTitle:@"点击领取" forState:UIControlStateNormal];
    gotButton.layer.cornerRadius = gotButton.height/2;
    gotButton.layer.masksToBounds = YES;
    gotButton.layer.borderColor = YBLColor(155, 70, 251, 1).CGColor;
    gotButton.layer.borderWidth = .5;
    [gotButton setTitleColor:YBLColor(155, 70, 251, 1) forState:UIControlStateNormal];
    gotButton.titleLabel.font = YBLFont(12);
    [self.bgImageView addSubview:gotButton];
    self.couponsButton = gotButton;
    
    self.couponsTextLabel.height -=  self.couponsTextLabel.height/2;
    gotButton.centerY = self.bgImageView.height/2;
    gotButton.right = self.bgImageView.width-5;
    
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.height*2/3, self.bgImageView.height*2/3)];
    stateImageView.image = [UIImage imageNamed:@"coupons_got"];
    stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    stateImageView.right = self.bgImageView.width-5;
    [self.bgImageView addSubview:stateImageView];
    self.stateImageView = stateImageView;
    self.stateImageView.hidden = YES;
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    YBLCouponsModel *model = (YBLCouponsModel *)itemModel;
    self.stateImageView.hidden = !model.binded.boolValue;
    self.couponsButton.hidden = model.binded.boolValue;
    
}

@end
