//
//  XNPopView.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/14.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNSelectRowAtIndexBlock)(NSInteger index);

typedef void(^XNPopViewDismissBlock)();

@interface YBLPopView : UIView

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) XNSelectRowAtIndexBlock selectRowAtIndexBlock;
@property (nonatomic, copy) XNPopViewDismissBlock dismissBlock;

+ (void)showWithPoint:(CGPoint)point
               titles:(NSArray *)titles
               images:(NSArray *)images
            doneBlock:(XNSelectRowAtIndexBlock)doneBlock
         dismissBlock:(XNPopViewDismissBlock)dismissBlock;

- (instancetype)initWithPoint:(CGPoint)point
                       titles:(NSArray *)titles
                       images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@end
