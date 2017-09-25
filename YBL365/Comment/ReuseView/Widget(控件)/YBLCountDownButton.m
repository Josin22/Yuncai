//
//  YBLCountDownButton.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCountDownButton.h"

@implementation YBLCountDownButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.titleLabel.font = YBLFont(15);
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:YBLColor(212, 212, 212, 1) forState:UIControlStateDisabled];
        [self setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
        [self setBackgroundColor:YBLColor(238, 238, 238, 1) forState:UIControlStateDisabled];
    }
    return self;
}


- (void)begainCountDown{
    
    __block NSInteger timeout = self.timeCount; //倒计时时间

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                BLOCK_EXEC(self.countDownEndBlock,);
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                self.enabled = NO;
                [self setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)timeout] forState:UIControlStateDisabled];
            });
            timeout = timeout - 1;
        }
    });
    dispatch_resume(_timer);
}

@end

