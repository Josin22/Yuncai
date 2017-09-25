//
//  UINavigationItem+YBL.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BarItemClickBlock)();

@interface UIBarButtonItem (YBL)

+ (instancetype)itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font block:(BarItemClickBlock)block;

+ (instancetype)itemWithImage:(NSString *)image block:(BarItemClickBlock)block;

@end
