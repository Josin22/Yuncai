
//
//  YBLMyRecommendCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyRecommendCell.h"
#import "YBLTimeDown.h"

@interface YBLMyRecommendCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, retain) UILabel *goodsNameLaebl;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) YBLTimeDown *timeDown;

@property (nonatomic, retain) UILabel *signLabel;

@end

@implementation YBLMyRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [YBLMyRecommendCell getMyRecommendCellHeight];
    
    self.goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space*2, height-4*space, height-4*space)];
    self.goodsImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    self.goodsImageView.layer.borderColor = YBLLineColor.CGColor;
    self.goodsImageView.layer.borderWidth = 0.5;
    self.goodsImageView.layer.cornerRadius = 3;
    self.goodsImageView.layer.masksToBounds = YES;
    [self addSubview:self.goodsImageView];
    
    self.goodsNameLaebl = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageView.right+space, self.goodsImageView.top, YBLWindowWidth-(self.goodsImageView.right+space*2), 40)];
    self.goodsNameLaebl.numberOfLines = 2;
    self.goodsNameLaebl.font = YBLFont(14);
    self.goodsNameLaebl.text = @"创见 (transcend) kNavigationbarHeightGB UHS-HCLASS10 TF (mircrio SGYASD) 储存";
    [self addSubview:self.goodsNameLaebl];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsNameLaebl.left, self.goodsNameLaebl.bottom+space, self.goodsNameLaebl.width, 20)];
    self.priceLabel.attributedText = [self getBaoPrice:@"¥ 1228.00" needPrice:@"420.00"];
    [self addSubview:self.priceLabel];
    
    self.timeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(self.priceLabel.left, self.priceLabel.bottom+space/2, self.goodsNameLaebl.width, 15) WithType:TimeDownTypeText];
    self.timeDown.textTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.timeDown.textColor = YBLTextColor;
    NSString *testTime = @"2017-02-09 9:06:30";
    [self.timeDown setEndTime:testTime begainText:@"剩余时间:"];
    [self addSubview:self.timeDown];
    
    self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeDown.left, self.timeDown.bottom+space, 40, 20)];
    self.signLabel.layer.cornerRadius = 3;
    self.signLabel.layer.masksToBounds = YES;
    self.signLabel.backgroundColor = YBLThemeColor;
    self.signLabel.textColor = [UIColor whiteColor];
    self.signLabel.text = @"同城配";
    self.signLabel.textAlignment = NSTextAlignmentCenter;
    self.signLabel.font = YBLFont(10);
    [self addSubview:self.signLabel];
    
    CGFloat buttonWi = 60;
    
    self.lookSameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookSameButton.frame = CGRectMake(YBLWindowWidth-space*2-buttonWi*2, height-space-30, buttonWi, 30);
    [self.lookSameButton setTitle:@"看相似" forState:UIControlStateNormal];
    [self.lookSameButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    self.lookSameButton.titleLabel.font = YBLFont(13);
    self.lookSameButton.layer.borderColor = YBLLineColor.CGColor;
    self.lookSameButton.layer.cornerRadius = 3;
    self.lookSameButton.layer.masksToBounds = YES;
    self.lookSameButton.layer.borderWidth = 0.5;
    [self addSubview:self.lookSameButton];
    

    self.tradeNotificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tradeNotificationButton.frame = CGRectMake(self.lookSameButton.right+space, self.lookSameButton.top, buttonWi, 30);
    [self.tradeNotificationButton setTitle:@"成交通知" forState:UIControlStateNormal];
    [self.tradeNotificationButton setTitle:@"已通知" forState:UIControlStateSelected];
    [self.tradeNotificationButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self.tradeNotificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.tradeNotificationButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tradeNotificationButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    self.tradeNotificationButton.titleLabel.font  = YBLFont(13);
    self.tradeNotificationButton.layer.masksToBounds = YES;
    self.tradeNotificationButton.layer.cornerRadius = 3;
    self.tradeNotificationButton.layer.borderWidth = 0.5;
    self.tradeNotificationButton.layer.borderColor = YBLLineColor.CGColor;
    [self addSubview:self.tradeNotificationButton];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.goodsNameLaebl.left, height-0.5, YBLWindowWidth-self.goodsNameLaebl.left, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (NSMutableAttributedString *)getBaoPrice:(NSString *)baoPrice needPrice:(NSString *)needPrice{
    
    NSString *str1 = [NSString stringWithFormat:@"%@ 报价",baoPrice];
    NSString *str2 = [NSString stringWithFormat:@"/ %@需求价",needPrice];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[str1 stringByAppendingString:str2]];

    [attString addAttributes:@{NSForegroundColorAttributeName:YBLThemeColor} range:NSMakeRange(0, baoPrice.length)];
    
    [attString addAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:YBLFont(12)} range:NSMakeRange(baoPrice.length+1, 2)];
    
    [attString addAttributes:@{NSForegroundColorAttributeName:YBLTextColor} range:NSMakeRange(baoPrice.length+3, needPrice.length+5)];
    
    NSInteger dian1 = [baoPrice rangeOfString:@"."].location;
    
    [attString addAttributes:@{NSFontAttributeName:YBLFont(14)} range:NSMakeRange(0, 1)];
    [attString addAttributes:@{NSFontAttributeName:YBLFont(19)} range:NSMakeRange(2, dian1-2)];
    [attString addAttributes:@{NSFontAttributeName:YBLFont(13)} range:NSMakeRange(dian1, 3)];
    
    NSInteger dian2 = [str2 rangeOfString:@"."].location;

    [attString addAttributes:@{NSFontAttributeName:YBLFont(19)} range:NSMakeRange(str1.length, dian2)];
    [attString addAttributes:@{NSFontAttributeName:YBLFont(13)} range:NSMakeRange(str1.length+dian2, 6)];
    
    
    return attString;
}


+ (CGFloat)getMyRecommendCellHeight{
    
    return 160;
}

@end
