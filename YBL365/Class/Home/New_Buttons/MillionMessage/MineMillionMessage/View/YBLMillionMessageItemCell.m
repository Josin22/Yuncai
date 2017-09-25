//
//  YBLMillionMessageItemCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageItemCell.h"

@interface YBLMillionMessageItemCell ()

@property (nonatomic, retain) UILabel *moneyLabel;

@end

@implementation YBLMillionMessageItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.fousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fousButton.frame = CGRectMake(0, 0, 70, 30);
    [self.fousButton setBackgroundColor:YBLColor(220, 220, 220, 1) forState:UIControlStateDisabled];
    [self.fousButton setBackgroundColor:YBLColor(220, 220, 220, 1) forState:UIControlStateSelected];
    [self.fousButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.fousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.fousButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    [self.fousButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.fousButton setTitle:@"关注中" forState:UIControlStateSelected];
    [self.fousButton setTitle:@"已关注" forState:UIControlStateDisabled];
    self.fousButton.titleLabel.font = YBLFont(13);
    self.fousButton.layer.cornerRadius = 3;
    self.fousButton.layer.masksToBounds = YES;
    self.fousButton.right = YBLWindowWidth-space;
    self.fousButton.centerY = self.contentBGView.height/2;
    [self.contentView addSubview:self.fousButton];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:[self.fousButton bounds]];
    self.moneyLabel.textColor = YBLThemeColor;
    self.moneyLabel.font = YBLFont(28);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.text = @"-1";
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.hidden = YES;
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    
}

- (void)showMoneyView{
    if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeCredit) {
        return;
    }
    self.moneyLabel.hidden = NO;
    self.moneyLabel.center = self.fousButton.center;
    [UIView animateWithDuration:1.5 animations:^{
        self.moneyLabel.top = 0;
    } completion:^(BOOL finished) {
        self.moneyLabel.hidden = YES;
    }];
}

@end
