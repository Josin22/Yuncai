//
//  UINavigationItem+YBL.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "UIBarButtonItem+YBL.h"

static BarItemClickBlock block1;

@implementation UIBarButtonItem (YBL)

+ (instancetype)itemWithImage:(NSString *)image block:(BarItemClickBlock)block{
    block1 = block;
    YBLButton *button = [YBLButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return itemButton;
}

+ (instancetype)itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font block:(BarItemClickBlock)block {
    block1 = block;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    item.tintColor = color;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
    return item;
}

+ (void)click {
    if (block1) {
        block1();
    }
}

@end
