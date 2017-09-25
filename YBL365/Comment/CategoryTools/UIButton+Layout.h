//
//  UIButton+Layout.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Layout)

@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;

- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state;

@end
