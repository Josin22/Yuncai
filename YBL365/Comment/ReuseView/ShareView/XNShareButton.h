//
//  XNShareButton.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNShareButton : UIButton

+ (instancetype)shareButton;
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                     imageTag:(NSInteger)imageTAG
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                   titleColor:(UIColor *)titleColor;

@end
