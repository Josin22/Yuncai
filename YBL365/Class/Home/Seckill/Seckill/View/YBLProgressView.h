//
//  YBLProgressView.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLProgressView : UIView

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIColor *newfillColor;

@property (nonatomic, strong) UIImageView *bgImageView;

- (void)loading:(float)value;

@end
