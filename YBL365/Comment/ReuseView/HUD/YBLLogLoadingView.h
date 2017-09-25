//
//  YBLLogLoadingView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLLogLoadingView : UIView

-(void)show;

-(void)dismiss;

+(void)showInView:(UIView*)view;

+(void)dismissInView:(UIView*)view;

+ (void)showInWindow;

+ (void)dismissInWindow;

@end
