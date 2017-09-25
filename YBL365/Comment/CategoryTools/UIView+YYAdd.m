//
//  UIView+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIView+YYAdd.h"
#import <objc/runtime.h>

@implementation UIView (YYAdd)

NSString * const _recognizerScale = @"_recognizerScale";

- (void)setScale:(CGFloat)scale {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerScale), @(scale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

- (CGFloat)scale {
    
    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerScale));
    return scaleValue.floatValue;
}

#pragma mark - Angle.

NSString * const _recognizerAngle = @"_recognizerAngle";

- (void)setAngle:(CGFloat)angle {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerAngle), @(angle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (CGFloat)angle {
    
    NSNumber *angleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerAngle));
    return angleValue.floatValue;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 

+ (void)transformOpenView:(UIView *)view
                SuperView:(UIView *)sview
                  fromeVC:(UIViewController *)vc
                      Top:(CGFloat)top{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.backgroundColor = [UIColor blackColor];
    [keyWindow addSubview:sview];
    
    [UIView animateWithDuration:.35f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         vc.view.layer.transform = [YBLMethodTools transformFirstViewLayer];
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.4f
                                               delay:0
                              usingSpringWithDamping:.85f
                               initialSpringVelocity:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                              vc.view.layer.transform = [YBLMethodTools transformSecondViewLayer];
                                              sview.backgroundColor = YBLColor(0, 0, 0, 0.5);
                                              view.top = top;
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
    
 
}

+ (void)transformCloseView:(UIView *)view SuperView:(UIView *)sview fromeVC:(UIViewController *)vc Top:(CGFloat)top completion:(void (^)(BOOL finished))completion{
    
    [UIView animateWithDuration:.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         vc.view.layer.transform = [YBLMethodTools transformFirstViewLayer];
                         sview.backgroundColor = YBLColor(0, 0, 0, 0);
                         view.top = top;
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.24f
                                               delay:0
                              usingSpringWithDamping:10
                               initialSpringVelocity:5
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              vc.view.layer.transform = CATransform3DIdentity;
                                          }
                                          completion:^(BOOL finished) {
                                              UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                                              keyWindow.backgroundColor = [UIColor whiteColor];

                                              if (finished) {
                                                  completion(finished);
                                              }
                                              
                                          }];
                         
                     }];
    
    
}

- (void)addCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)corner{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

+ (UIView *)getSnapshotViewWith:(UIView *)view{
    
    UIView *snapshotView = [[UIView alloc]init];
    UIView *cellSnapshotView = nil;
    if ([view respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [view snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(view.bounds.size.width + 20, view.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
