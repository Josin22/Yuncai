//
//  YBLTimeDown.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLTimeDown.h"
#import "YBLSingletonMethodTools.h"

#define TimeLabelLineColor  YBLColor(180, 180, 180, 1)

#define TimeLabelColor  YBLColor(70, 70, 70, 1)

#define TimeLabelFont  YBLFont(13)

//static CGFloat const TimeLabelH = 16;

static CGFloat const TimeLabelW = 20.f;

static CGFloat const JIANJU = 10.f;

@interface YBLTimeDown ()
{
    dispatch_source_t _timer;
    NSString *final_endTime;
}
@property (nonatomic, retain) UILabel *hourLabel;
@property (nonatomic, retain) UILabel *minuteLabel;
@property (nonatomic, retain) UILabel *secondLabel;
@property (nonatomic, retain) UILabel *otherLabel;
@property (nonatomic, retain) UILabel *otherLabel1;
@property (nonatomic, retain) UIView *bgView;
/**
 *  设置倒计时类型
 */
@property (nonatomic, assign) TimeDownType timeDownType;

@end

@implementation YBLTimeDown

- (instancetype)initWithFrame:(CGRect)frame WithType:(TimeDownType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        CGRect frame_new =  [self frame];
//        frame_new.size.height = 16;
//        self.frame  =frame_new;
        
        _timeDownType = type;
        
        [self initTimeDownUI:type];
        
    }
    return self;
}

#pragma mark - 初始化视图

- (void)initTimeDownUI:(TimeDownType)type{
    
    self.backgroundColor = [UIColor clearColor];
    
    /****************************************数字倒计时****************************************/
    if (type == TimeDownTypeNumber) {
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TimeLabelW, self.height)];
        hourLabel.text = @"00";
        hourLabel.textColor = YBLTextColor;
        hourLabel.layer.borderWidth = 0.5;
        hourLabel.textAlignment = NSTextAlignmentCenter;
        hourLabel.layer.borderColor = YBLLineColor.CGColor;
        hourLabel.font = TimeLabelFont;
        [self addSubview:hourLabel];
        self.hourLabel = hourLabel;
        
        UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(hourLabel.frame.origin.x+hourLabel.frame.size.width, -2, JIANJU, hourLabel.frame.size.height)];
        otherLabel.text = @":";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = YBLTextColor;
        [self addSubview:otherLabel];
        self.otherLabel = otherLabel;
        
        UILabel *minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(otherLabel.frame.origin.x+otherLabel.frame.size.width, 0, TimeLabelW, self.height)];
        minuteLabel.text = @"00";
        minuteLabel.textColor = YBLTextColor;
        minuteLabel.layer.borderWidth = 0.5;
        minuteLabel.textAlignment = NSTextAlignmentCenter;
        minuteLabel.layer.borderColor = YBLLineColor.CGColor;
        minuteLabel.font = TimeLabelFont;
        [self addSubview:minuteLabel];
        self.minuteLabel = minuteLabel;
        
        UILabel *otherLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(minuteLabel.frame.origin.x+minuteLabel.frame.size.width, -2, JIANJU, minuteLabel.frame.size.height)];
        otherLabel1.text = @":";
        otherLabel1.textAlignment = NSTextAlignmentCenter;
        otherLabel1.textColor = YBLTextColor;
        [self addSubview:otherLabel1];
        self.otherLabel1 = otherLabel1;
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(otherLabel1.frame.origin.x+otherLabel1.frame.size.width, 0, TimeLabelW, self.height)];
        secondLabel.text = @"00";
        secondLabel.textColor = YBLTextColor;
        secondLabel.layer.borderWidth = 0.5;
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.layer.borderColor = YBLLineColor.CGColor;
        secondLabel.font = TimeLabelFont;
        [self addSubview:secondLabel];
        self.secondLabel = secondLabel;
    } else {
        /****************************************文字倒计时****************************************/
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.alpha = 1;
        [self addSubview:_bgView];
        
        self.textTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.textTimerLabel.text = @"距离时间00小时00分钟00秒";
        self.textTimerLabel.textColor = YBLTextColor;
        self.textTimerLabel.numberOfLines = 0;
        self.textTimerLabel.textAlignment = NSTextAlignmentCenter;
        self.textTimerLabel.font = YBLFont(11);
        [self addSubview:self.textTimerLabel];
        
    }
}

#pragma mark - 设置结束时间

- (void)setEndTime:(NSString *)endTime begainText:(NSString *)text{
    [self setEndTime:endTime NowTime:nil begainText:text];
}

- (void)setEndTime:(NSString *)endTime NowTime:(NSString *)NowTime begainText:(NSString *)text{
    
    final_endTime = endTime;
    NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;;
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *nowDate = [dateFormatter dateFromString:NowTime];
    int ii = [YBLMethodTools compareOneDay:nowDate withAnotherDay:endDate dateFormatter:dateFormatter];
    if (ii == 1) {
        //现在时间比结束时间晚
        [self defaultSettingTime];
        return;
    }
        
    __block int timeout = abs((int)([endDate timeIntervalSince1970]-[nowDate timeIntervalSince1970])); //倒计时时间
    
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout==0){ //倒计时结束，关闭

                if (self.timeOverBlock) {
                    self.timeOverBlock();
                }
                [self defaultSettingTime];
                
            }else if(timeout > 0){
                int second = (int)timeout%60;
                int minute = (int)(timeout%3600)/60;
                int hours = (int)(timeout)/3600;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (_timeDownType == TimeDownTypeText) {
                        
                        _textTimerLabel.text = [text stringByAppendingString:[NSString stringWithFormat:@"%d时%d分%d秒",hours,minute,second]];
                        
                    } else {
                        
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    }
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
}

- (void)defaultSettingTime{
    
    [self destroyTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"秒杀结束--------------------");
        if (_timeDownType == TimeDownTypeText) {
            _textTimerLabel.text = [NSString stringWithFormat:@"已结束:%@",final_endTime];
        } else {
            self.hourLabel.text = @"00";
            self.minuteLabel.text = @"00";
            self.secondLabel.text = @"00";
        }
    });
  
}

- (void)destroyTimer{
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor TextColor:(UIColor *)color radiuo:(CGFloat)rad{
    
    [self labelBGColor:backgroundColor rad:rad];
    
    [self labelTextColor:color];
}

- (void)setTextColor:(UIColor *)textColor{
    
    [self labelTextColor:textColor];
    
    if ([textColor isEqual:[UIColor whiteColor]]) {
        
        UIColor *wi = BlackTextColor;
        
        [self labelBGColor:wi rad:3];
    }
}

- (void)labelTextColor:(UIColor *)color{
    
    self.hourLabel.textColor = color;
    self.secondLabel.textColor = color;
    self.minuteLabel.textColor = color;
    
}

- (void)labelBGColor:(UIColor *)bgColor rad:(CGFloat)rad{
    
    self.hourLabel.layer.cornerRadius = rad;
    self.hourLabel.layer.masksToBounds = YES;
    self.secondLabel.layer.cornerRadius = rad;
    self.secondLabel.layer.masksToBounds = YES;
    self.minuteLabel.layer.cornerRadius = rad;
    self.minuteLabel.layer.masksToBounds = YES;
    
    self.hourLabel.layer.borderColor = bgColor.CGColor;
    self.secondLabel.layer.borderColor = bgColor.CGColor;
    self.minuteLabel.layer.borderColor = bgColor.CGColor;
    
    self.hourLabel.backgroundColor = bgColor;
    self.secondLabel.backgroundColor = bgColor;
    self.minuteLabel.backgroundColor = bgColor;
}

@end
