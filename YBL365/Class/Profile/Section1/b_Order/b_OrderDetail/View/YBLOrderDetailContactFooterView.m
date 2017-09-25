//
//  YBLOrderDetailContactFooterView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailContactFooterView.h"

@interface YBLOrderDetailContactFooterView ()

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YBLOrderDetailContactFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonWi = (YBLWindowWidth-space*2);
    CGFloat buttonHi = 36;
    
    self.moreButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.frame = CGRectMake(0, 0, YBLWindowWidth, 30);
    [self.moreButton setTitle:@"更多 >>" forState:UIControlStateNormal];
    [self.moreButton setTitle:@"收起 ∧∧" forState:UIControlStateSelected];
    self.moreButton.titleLabel.font = YBLFont(12);
    [self.moreButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self.moreButton setTitleColor:YBLTextColor forState:UIControlStateSelected];
    self.moreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.moreButton];
    
    [self.moreButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.moreButton.height-0.5, self.moreButton.width, 0.5)]];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.moreButton.bottom, YBLWindowWidth, buttonHi+space*3)];
    bottomView.backgroundColor = YBLColor(247, 247, 247, 1);
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, buttonHi+space*2)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:buttonView];
    YBLButton *callButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake(space, space, buttonWi, buttonHi);
    callButton.backgroundColor = [UIColor whiteColor];
    callButton.layer.borderColor = YBLLineColor.CGColor;
    callButton.layer.borderWidth = 0.5;
    callButton.layer.cornerRadius = 3;
    callButton.layer.masksToBounds = YES;
    callButton.titleLabel.font = YBLFont(14);
    [callButton setTitle:@"联系卖家" forState:UIControlStateNormal];
    [callButton setTitleColor:YBLColor(110, 110, 110, 1) forState:UIControlStateNormal];
    [callButton setImage:[UIImage imageNamed:@"goods_phonecall"] forState:UIControlStateNormal];
    callButton.imageRect = CGRectMake(buttonWi/2-35, (buttonHi-15)/2, 15, 15);
    callButton.titleRect = CGRectMake(buttonWi/2-15, 0, buttonWi/2+buttonHi, buttonHi);
    [buttonView addSubview:callButton];
    self.contactButton = callButton;
}

- (void)setIsHaveTwoCount:(BOOL)isHaveTwoCount{
    _isHaveTwoCount = isHaveTwoCount;
    
    self.moreButton.hidden = !_isHaveTwoCount;
    self.bottomView.top = _isHaveTwoCount == YES?self.moreButton.bottom:0;
}

+ (CGFloat)getHi:(BOOL)isHasMore{
    
    if (isHasMore) {
        return [YBLOrderDetailContactFooterView new].bottomView.bottom;
    } else {
        return [YBLOrderDetailContactFooterView new].bottomView.height;
    }
}

@end
