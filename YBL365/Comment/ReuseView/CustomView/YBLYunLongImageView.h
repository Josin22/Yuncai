//
//  YBLYunLongImageView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YunLongImageViewType) {
    YunLongImageViewTypeGood = 0,
    YunLongImageViewTypeStore
};

@interface YBLYunLongImageView : UIView

+ (void)showYunLongImageViewWithModel:(YBLSystemSocialModel *)socialModel;

+ (void)showStoreYunLongImageViewWithModel:(YBLSystemSocialModel *)socialModel;

@end
