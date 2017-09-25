
//
//  YBLBriberyMoneyView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBriberyItemView.h"

@interface YBLBriberyItemView()

@end

@implementation YBLBriberyItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = YBLLineColor.CGColor;
    self.layer.borderWidth = .8;
    self.clipsToBounds = YES;
    
    self.backgroundColor = YBLColor(227, 155, 69, 1);

    UIImage *iconImage = [UIImage imageNamed:@"bribery_money"];
    self.briberyIconImageView = [[UIImageView alloc] initWithImage:iconImage];
    self.briberyIconImageView.frame = CGRectMake(space*2, space, 60, 60);
    [self addSubview:self.briberyIconImageView];
    
    self.briberyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.briberyIconImageView.right+space*2, self.briberyIconImageView.top, self.width-(self.briberyIconImageView.right+space*4), 35)];
    self.briberyTitleLabel.textColor = [UIColor whiteColor];
    self.briberyTitleLabel.font = YBLBFont(18);
    self.briberyTitleLabel.text = @"恭 喜 发 财 , 大 吉 大 利";
    [self addSubview:self.briberyTitleLabel];
    
    self.briberyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.briberyTitleLabel.left, self.briberyTitleLabel.bottom, self.briberyTitleLabel.width, 25)];
    self.briberyInfoLabel.textColor = [UIColor whiteColor];
    self.briberyInfoLabel.font = YBLFont(14);
    [self addSubview:self.briberyInfoLabel];
    
    self.briberyStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:self.briberyStateImageView];
    self.briberyStateImageView.hidden = YES;
    
    self.briberyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.briberyIconImageView.bottom+space, self.width, 30)];
    self.briberyTypeLabel.backgroundColor = [UIColor whiteColor];
    self.briberyTypeLabel.textColor = BlackTextColor;
    self.briberyTypeLabel.font = YBLFont(12);
    self.briberyTypeLabel.text = @"    关注红包";
    [self addSubview:self.briberyTypeLabel];
    
    
}

- (void)setBriberyType:(BriberyType)briberyType{
    _briberyType = briberyType;
    
    switch (_briberyType) {
        case BriberyTypeNormal:
        {
            self.backgroundColor = YBLColor(227, 155, 69, 1);
            self.briberyStateImageView.hidden = YES;
        }
            break;
        case BriberyTypeReceived:
        {
            self.backgroundColor = YBLColor(222, 121, 47, 1);
            self.briberyStateImageView.hidden = NO;
            self.briberyStateImageView.image = [UIImage imageNamed:@"received"];
        }
            break;
        case BriberyTypeOverdued:
        {
            self.backgroundColor = YBLColor(230, 230, 230, 1);
            self.briberyStateImageView.hidden = NO;
            self.briberyStateImageView.image = [UIImage imageNamed:@"orverdued"];
        }
            break;
            
        default:
            break;
    }
}


@end
