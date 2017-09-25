//
//  YBLRechargeItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRechargeItemCell.h"
#import "TextImageButton.h"
#import "YBLRechargeWalletsModel.h"

@interface YBLRechargeItemCell ()

@end

@implementation YBLRechargeItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.itemButton = [[TextImageButton alloc] initWithFrame:CGRectMake(space, space, self.width-2*space, self.height-space) Type:TypeText];
    self.itemButton.topLabel.textColor = YBLColor(69, 170, 35, 1);
    self.itemButton.topLabel.font = YBLFont(16);
    self.itemButton.bottomLabel.textColor = YBLColor(69, 170, 35, 1);
    self.itemButton.bottomLabel.font = YBLFont(12);
//    self.itemButton.topLabel.bottom = self.itemButton.height/2;
//    self.itemButton.bottomLabel.top = self.itemButton.height/2+3;
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.layer.borderColor = YBLColor(69, 170, 35, 1).CGColor;
    self.itemButton.layer.borderWidth = .6;
    [self.contentView addSubview:self.itemButton];
}

- (void)updateItemModel:(YBLRechargeWalletsModel *)model{
    self.itemButton.topLabel.text = model.name;
    self.itemButton.bottomLabel.text = [NSString stringWithFormat:@"售价%@元",model.price];
}

@end
