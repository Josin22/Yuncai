//
//  YBLOrderActionView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLOrderActionView.h"

static YBLOrderActionView *orderActionView = nil;

@interface YBLOrderActionView ()

@end

@implementation YBLOrderActionView


+ (void)showTitle:(NSString *)title
           cancle:(NSString *)cancle
             sure:(NSString *)sure
  WithSubmitBlock:(void(^)())block
      cancelBlock:(void(^)())block1{
    
    if (!orderActionView) {
        orderActionView = [[YBLOrderActionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        orderActionView.backgroundColor = YBLColor(0, 0, 0, 0);
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, orderActionView.width-60, (orderActionView.width-60)*0.5)];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.center = orderActionView.center;
        bgView.backgroundColor = [UIColor whiteColor];
        [orderActionView addSubview:bgView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space/2, 0, bgView.width-space, bgView.height-44)];
        label.text = @"便宜不等人，请三思而后行~";
        if (title != nil) {
            label.text = title;
        }
        label.font =YBLFont(16);
        label.numberOfLines = 0;
        label.textColor = YBLColor(70, 70, 70, 1.0);
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height - 44.5, orderActionView.width-44, 0.5)];
        lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
        [bgView addSubview:lineView];
        
        
        UIButton *dimissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dimissButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
        [dimissButton setTitle:@"我再想想" forState:UIControlStateNormal];
        if (cancle != nil) {
            [dimissButton setTitle:cancle forState:UIControlStateNormal];
        }
        dimissButton.backgroundColor = [UIColor whiteColor];
        dimissButton.titleLabel.font = YBLFont(17);
        dimissButton.frame = CGRectMake(0, bgView.height - 44, bgView.width/2, 44);
        [bgView addSubview:dimissButton];
        
        __weak typeof (bgView)weakbgView = bgView;
        __weak typeof (orderActionView)weakorderActionView = orderActionView;
        [[dimissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakbgView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakbgView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                weakorderActionView.backgroundColor = YBLColor(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                [orderActionView removeFromSuperview];
                orderActionView = nil;
                if (block1) {
                    block1();
                }
            }];
        }];
        
        
        UIButton *submitBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBUtton.backgroundColor = YBLColor(240, 70, 73, 1.0);
        [submitBUtton setTitle:@"去意已决" forState:UIControlStateNormal];
        if (sure != nil) {
            [submitBUtton setTitle:sure forState:UIControlStateNormal];
        }
        submitBUtton.titleLabel.font = YBLFont(17);
        submitBUtton.frame = CGRectMake(dimissButton.right, bgView.height - 44, bgView.width/2, 44);
        [bgView addSubview:submitBUtton];
        [[submitBUtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakbgView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakbgView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                weakorderActionView.backgroundColor = YBLColor(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                [orderActionView removeFromSuperview];
                orderActionView = nil;
                if (block) {
                    block();
                }
            }];
        }];
        
        weakbgView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakbgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            weakorderActionView.backgroundColor = YBLColor(0, 0, 0, 0.5);
        } completion:nil];
        
        [[UIApplication sharedApplication].keyWindow addSubview:orderActionView];
    }
}
@end
