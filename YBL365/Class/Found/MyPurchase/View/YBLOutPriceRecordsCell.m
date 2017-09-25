//
//  YBLOutPriceRecordsCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOutPriceRecordsCell.h"
#import "YBLTimeDown.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOutPriceRecordsCell ()

@property (nonatomic, strong) UIButton *signlButton;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, retain) UILabel *goodCurrentPriceLabel;

@property (nonatomic, retain) UILabel *endTimeLabel;

@property (nonatomic, strong) YBLTimeDown *timeDown;


@end

@implementation YBLOutPriceRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80, 80)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    goodImageView.layer.borderColor = YBLLineColor.CGColor;
    goodImageView.layer.cornerRadius = 3;
    goodImageView.layer.masksToBounds = YES;
    goodImageView.layer.borderWidth = 0.5;
    goodImageView.clipsToBounds = YES;
    [self addSubview:goodImageView];
    
    self.signlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signlButton.frame = CGRectMake(0, 0, goodImageView.width, 18);
    [self.signlButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.signlButton setBackgroundColor:YBLTextColor forState:UIControlStateDisabled];
    [self.signlButton setTitle:@"进行中" forState:UIControlStateNormal];
    [self.signlButton setTitle:@"已结束" forState:UIControlStateDisabled];
    self.signlButton.titleLabel.font = YBLFont(13);
    [self.signlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [goodImageView addSubview:self.signlButton];
    
    self.goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, 37)];
    self.goodTitleLabel.numberOfLines = 2;
    self.goodTitleLabel.font = YBLFont(15);
    self.goodTitleLabel.textColor = BlackTextColor;
    self.goodTitleLabel.text = @"洋河蓝色经典 飞天茅台 王子酒 52度 500ml 精品特供";
    [self addSubview:self.goodTitleLabel];
    
    self.goodCurrentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodTitleLabel.left, self.goodTitleLabel.bottom+1.5, self.goodTitleLabel.width, 20)];
    self.goodCurrentPriceLabel.text = @"当前价格 : ¥12.03-12.66";
    self.goodCurrentPriceLabel.font = YBLFont(13);
    self.goodCurrentPriceLabel.textColor = BlackTextColor;
    [self addSubview:self.goodCurrentPriceLabel];
    
    CGFloat buttonWi = 65;
    CGFloat buttonHi = 20;
    
    UIButton *signelTongchengPeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signelTongchengPeiButton.layer.cornerRadius = 3;
    signelTongchengPeiButton.layer.masksToBounds = YES;
    signelTongchengPeiButton.backgroundColor = YBLThemeColor;
    signelTongchengPeiButton.frame = CGRectMake(self.goodCurrentPriceLabel.left, self.goodCurrentPriceLabel.bottom+1.5, buttonWi, buttonHi);
    signelTongchengPeiButton.titleLabel.font = YBLFont(13);
    [signelTongchengPeiButton setTitle:@"同城配送" forState:UIControlStateNormal];
    [signelTongchengPeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:signelTongchengPeiButton];

    UIButton *signelWuliuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signelWuliuButton.layer.cornerRadius = 3;
    signelWuliuButton.layer.masksToBounds = YES;
    signelWuliuButton.backgroundColor = YBLThemeColor;
    signelWuliuButton.frame = CGRectMake(signelTongchengPeiButton.right+space, signelTongchengPeiButton.top, buttonWi, buttonHi);
    signelWuliuButton.titleLabel.font = YBLFont(13);
    [signelWuliuButton setTitle:@"物流到港" forState:UIControlStateNormal];
    [signelWuliuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:signelWuliuButton];
    
    UILabel *local_name_price_statue_label = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.left, goodImageView.bottom+space, YBLWindowWidth-goodImageView.left*2, 15)];
    local_name_price_statue_label.textColor = BlackTextColor;
    local_name_price_statue_label.text = @"郑州 / 张** / ¥12.03 / 目前低价";
    local_name_price_statue_label.font = YBLFont(12);
    [self addSubview:local_name_price_statue_label];
    
    UILabel *goodJoinRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(local_name_price_statue_label.left, local_name_price_statue_label.bottom+5, YBLWindowWidth/2-local_name_price_statue_label.left, 15)];
    goodJoinRecordLabel.font = YBLFont(13);
    goodJoinRecordLabel.text = @"10人参与/100人浏览";
    goodJoinRecordLabel.textColor = BlackTextColor;
    [self addSubview:goodJoinRecordLabel];
    
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodJoinRecordLabel.left, goodJoinRecordLabel.bottom+space/2, goodJoinRecordLabel.width, 15)];
    self.endTimeLabel.font = YBLFont(12);
    self.endTimeLabel.text = @"结束时间:2017-2-16日 08:32分";
    self.endTimeLabel.textColor = BlackTextColor;
    [self addSubview:self.endTimeLabel];
    
    self.timeDown = [[YBLTimeDown alloc] initWithFrame:[self.endTimeLabel frame] WithType:TimeDownTypeText];

    self.timeDown.textTimerLabel.textColor = YBLTextColor;
    self.timeDown.textTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.timeDown.textTimerLabel.font = YBLFont(12);
    [self addSubview:self.timeDown];

    
    CGFloat newHi = 30;
    CGFloat newWi = 70;
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(YBLWindowWidth-space-newWi, self.timeDown.bottom-newHi, newWi, newHi);
    self.payButton.layer.cornerRadius = 3;
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderColor = YBLThemeColor.CGColor;
    self.payButton.layer.borderWidth = 0.5;
    [self.payButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [self.payButton setTitle:@"支付货款" forState:UIControlStateNormal];
    self.payButton.titleLabel.font = YBLFont(14);
    [self addSubview:self.payButton];
    
    self.againPublishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.againPublishButton.frame = [self.payButton frame];
    self.againPublishButton.layer.cornerRadius = 3;
    self.againPublishButton.layer.masksToBounds = YES;
    self.againPublishButton.layer.borderColor = YBLColor(134, 134, 134, 1).CGColor;
    self.againPublishButton.layer.borderWidth = 0.5;
    [self.againPublishButton setTitleColor:YBLColor(95, 95, 95, 1) forState:UIControlStateNormal];
    [self.againPublishButton setTitle:@"再次发布" forState:UIControlStateNormal];
    self.againPublishButton.titleLabel.font = YBLFont(14);
    [self addSubview:self.againPublishButton];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.frame = CGRectMake(self.payButton.left-space-newWi, self.payButton.top, newWi, newHi);
    self.cancleButton.layer.cornerRadius = 3;
    self.cancleButton.layer.masksToBounds = YES;
    self.cancleButton.layer.borderColor = YBLColor(134, 134, 134, 1).CGColor;
    self.cancleButton.layer.borderWidth = 0.5;
    [self.cancleButton setTitleColor:YBLColor(95, 95, 95, 1) forState:UIControlStateNormal];
    [self.cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = YBLFont(14);
    [self addSubview:self.cancleButton];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, self.timeDown.bottom+space-0.5, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
    
}

- (CGFloat)getHi{
    return self.endTimeLabel.bottom+space;
}

+ (CGFloat)getMyPurchaseCellHeight{
    
    return [[YBLOutPriceRecordsCell new] getHi];
}

- (void)setStatue:(MyPurchaseStatue)statue{
    _statue = statue;
    switch (_statue) {
        case MyPurchaseStatueDoingNotNotPay:
        {
            self.signlButton.enabled = YES;
            self.payButton.hidden = NO;
            self.cancleButton.hidden = NO;
            self.againPublishButton.hidden = YES;
            self.endTimeLabel.hidden = YES;
            self.timeDown.hidden = NO;
            NSString *testTime = @"2017-02-09 9:06:30";
            [self.timeDown setEndTime:testTime
                           begainText:@"距结束时间:"];
        }
            break;
        case MyPurchaseStatueEndNotPay:
        {
            self.signlButton.enabled = NO;
            self.payButton.hidden = NO;
            self.cancleButton.hidden = NO;
            self.againPublishButton.hidden = YES;
            self.endTimeLabel.hidden = YES;
            self.timeDown.hidden = NO;
            NSString *testTime = @"2017-02-09 9:06:30";
            [self.timeDown setEndTime:testTime
                           begainText:@"付款剩余时间:"];
        }
            break;
        case MyPurchaseStatueEndPurchaseOutPriceAgain:
        {
            self.signlButton.enabled = NO;
            self.payButton.hidden = YES;
            self.cancleButton.hidden = YES;
            self.againPublishButton.hidden = NO;
            self.endTimeLabel.hidden = NO;
            self.timeDown.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
}

@end
