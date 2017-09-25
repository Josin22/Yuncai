//
//  YBLPatResultHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLPatResultHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton *lookOrderButton;

@property (nonatomic, strong) UIButton *backHomeButton;

+ (CGFloat)getMMPayResultViewHeight;

@end
