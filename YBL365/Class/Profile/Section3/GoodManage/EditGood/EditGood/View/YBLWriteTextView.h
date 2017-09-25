//
//  YBLWriteTextView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WriteTextViewTextBlock)(NSString *text);

@interface YBLWriteTextView : UIView

+ (void)showWriteTextViewOnView:(UIViewController *)vc
                    currentText:(NSString *)currentText
               LimmitTextLength:(NSInteger)limmetLength
                   completetion:(WriteTextViewTextBlock)block;

@end
