//
//  UINavigationController+PopGestureRecognizer.h
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PopGestureRecognizer)<UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isPopGestureRecognizerEnable;

//@property (readwrite,getter = isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end
