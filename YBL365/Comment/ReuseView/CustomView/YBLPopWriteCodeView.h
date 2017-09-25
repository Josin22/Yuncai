//
//  YBLPopWriteCodeView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopWriteCodeViewSureBlock)(NSString *codeText);

@interface YBLPopWriteCodeView : UIView

+ (void)showPopWriteCodeViewWithPopWriteCodeViewSureBlock:(PopWriteCodeViewSureBlock)block;

@end
