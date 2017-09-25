//
//  YBLOpenCreditsUerInfoHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOpenCreditsUerInfoHeaderView.h"
#import "YBLProgressView.h"
#import "TextImageButton.h"
#import "YBLCreditDayView.h"
#import "YBLSingletonMethodTools.h"
@interface YBLOpenCreditsUerInfoHeaderView ()

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, strong) YBLProgressView *progress;
@property (nonatomic, strong) YBLButton* dayButton;
@property (nonatomic, retain) UILabel *endTimeLabel;

@end

@implementation YBLOpenCreditsUerInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat temp_hi = [self getImageHeight];
    self.height = temp_hi+30;

    UIImage *bgImage = [UIImage contentFileWithName:@"credit_bg" Type:@"jpg"];
    CGFloat hi = (double)bgImage.size.height/bgImage.size.width * YBLWindowWidth;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, YBLWindowWidth, hi);
    [self addSubview:bgImageView];
    
    UIImageView *userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_head_icon_70x70_"]];
    userImageView.frame = CGRectMake(2*space, 2*space, 60, 60);
    userImageView.bottom = temp_hi/2-space*2;
    userImageView.layer.cornerRadius = userImageView.width/2;
    userImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:userImageView];
    self.userImageView = userImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.right+space*2, userImageView.top + userImageView.height / 2 - 20, YBLWindowWidth, 20)];
    nameLabel.text = [YBLUserManageCenter shareInstance].userInfoModel.nickname;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = YBLFont(15);
    [bgImageView addSubview:nameLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5, nameLabel.width, 18)];
    infoLabel.textColor = YBLTextColor;
    infoLabel.font = YBLFont(13);
    [bgImageView addSubview:infoLabel];
    self.infoLabel = infoLabel;
 
    UILabel *leftLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, hi/2+space, 38, 20)];
    leftLevelLabel.text = @"LV0";
    leftLevelLabel.font = YBLFont(15);
    leftLevelLabel.textColor = YBLColor(227, 173, 88, 1);//YBLColor(255, 210, 0, 1);
    [bgImageView addSubview:leftLevelLabel];
    
    YBLProgressView *progress = [[YBLProgressView alloc] initWithFrame:CGRectMake(leftLevelLabel.right+space, leftLevelLabel.top+12, YBLWindowWidth-leftLevelLabel.right-space*2-50, 6)];
    progress.newfillColor = YBLColor(227, 173, 88, 1);//YBLColor(255, 210, 0, 1);;
    progress.bgImageView.image = [UIImage imageNamed:@"credit_progress_bg"];
    [bgImageView addSubview:progress];
    self.progress = progress;
    
    YBLButton* dayButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    dayButton.frame = CGRectMake(0, progress.top-35, 50, 27);
    [dayButton setTitleColor:YBLColor(220, 220, 220, 1) forState:UIControlStateNormal];
    dayButton.titleLabel.font = YBLFont(12);
    dayButton.titleRect = CGRectMake(0, 0, 50, 23);
    dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIImage *dayViewBGImg = [UIImage imageNamed:@"credit_day_bg"];
    [dayButton setBackgroundImage:dayViewBGImg forState:UIControlStateNormal];
    [bgImageView addSubview:dayButton];
    self.dayButton = dayButton;
    
    UILabel *rightLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(progress.right+space, leftLevelLabel.top, leftLevelLabel.width, leftLevelLabel.height)];
    rightLevelLabel.text = @"LV10";
    rightLevelLabel.textAlignment = NSTextAlignmentRight;
    rightLevelLabel.font = YBLFont(15);
    rightLevelLabel.textColor = YBLColor(227, 173, 88, 1);//YBLColor(255, 210, 0, 1);
    [bgImageView addSubview:rightLevelLabel];
    
    
    NSArray *titleArray = @[@"店铺信用值",@"采购信用值",@"店铺收藏",@"粉丝"];
    CGFloat textButtonWI = YBLWindowWidth/titleArray.count;
    CGFloat textButtonHI = (hi-leftLevelLabel.bottom)*2/5;
    for (int i = 0; i<titleArray.count; i++) {
        NSString *text = titleArray[i];
        CGRect frame = CGRectMake(i*textButtonWI, hi-space-textButtonHI - space, textButtonWI, textButtonHI);
        TextImageButton *textButton = [[TextImageButton alloc] initWithFrame:frame Type:TypeText];
        textButton.topLabel.text = @"0";
        textButton.topLabel.textColor =  YBLColor(227, 173, 88, 1);//[UIColor whiteColor];
        textButton.topLabel.font = YBLFont(16);
//        textButton.bottomLabel.top = textButton.topLabel.bottom + 10;
        textButton.bottomLabel.text = text;
        textButton.bottomLabel.textColor = YBLTextColor;
        textButton.bottomLabel.font = YBLFont(14);
//        textButton.topLabel.top += 4;
        [bgImageView addSubview:textButton];
        
        if (i<titleArray.count-1) {
            UIView *line = [YBLMethodTools addLineView:CGRectMake(textButton.width-.5, 15, .2, textButton.height-10)];
            line.backgroundColor = YBLTextColor;
            [textButton addSubview:line];
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgImageView.bottom, self.width, 30)];
    lineView.backgroundColor = YBLColor(240, 240, 240, 1);
    [bgImageView addSubview:lineView];
    
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, lineView.width-2*space, lineView.height)];
    endTimeLabel.font = YBLFont(13);
    endTimeLabel.textColor = YBLTextColor;
    [lineView addSubview:endTimeLabel];
    self.endTimeLabel = endTimeLabel;
}

- (CGFloat)getImageHeight{
    UIImage *bgImage = [UIImage contentFileWithName:@"credit_bg" Type:@"jpg"];
    return (double)bgImage.size.height/bgImage.size.width * YBLWindowWidth;
}

- (void)reloadUserInfoData{
   
    NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
    if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
        [self.userImageView js_alpha_setImageWithURL:[NSURL URLWithString:useIconUrl] placeholderImage:smallImagePlaceholder];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"login_head_icon_70x70_"];
    }

    NSString *typeString = nil;
    BOOL isHidden = NO;
    if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
        typeString = @"信用通用户";
    } else {
        typeString = @"VIP用户";
    }
    NSString *final_string = nil;
    NSString* credit_begin_date = nil;
    NSString* credit_end_date = nil;
    if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeNone) {
        final_string = [NSString stringWithFormat:@"您还不是%@哟~",typeString];
        isHidden = YES;
    } else if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeCredit) {
        credit_begin_date = [YBLUserManageCenter shareInstance].userInfoModel.credit_begin_date;//
        credit_end_date = [YBLUserManageCenter shareInstance].userInfoModel.credit_end_date;//
        final_string = [NSString stringWithFormat:@"%@",typeString];
    } else if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeMember) {
        credit_begin_date = [YBLUserManageCenter shareInstance].userInfoModel.member_begin_date;//
        credit_end_date = [YBLUserManageCenter shareInstance].userInfoModel.member_end_date;//
        final_string = [NSString stringWithFormat:@"%@",typeString];
    }
    self.infoLabel.text = final_string;
    
    NSString* new_credit_begin_date = [credit_begin_date mutableCopy];
    NSString* new_credit_end_date = [credit_end_date mutableCopy];
    new_credit_begin_date = [YBLMethodTools replaceNYRDataStringWith:new_credit_begin_date];
    new_credit_end_date = [YBLMethodTools replaceNYRDataStringWith:new_credit_end_date];;
    NSString *begin_to_end_days = [YBLMethodTools diffDayOf:new_credit_begin_date andEndTime:new_credit_end_date];
    NSDateFormatter *fmt = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
    [fmt setDateFormat:@"yyyy-MM-dd"];
    NSDate *now =[NSDate date];
    NSString *now_str = [fmt stringFromDate:now];
    NSString *begin_to_now_days = [YBLMethodTools diffDayOf:new_credit_begin_date andEndTime:now_str];
    float loading_value =  1.0 * begin_to_now_days.intValue / begin_to_end_days.intValue;
    //    loading_value = .8;
    [self.progress loading:loading_value];
    
    self.dayButton.left = self.progress.left + self.progress.width * loading_value - 27;
    [self.dayButton setTitle:[NSString stringWithFormat:@"00%@天", begin_to_now_days] forState:UIControlStateNormal];
    
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@截止到:%@", typeString,credit_end_date];//credit_end_date;
    self.endTimeLabel.hidden = isHidden;
}

@end
