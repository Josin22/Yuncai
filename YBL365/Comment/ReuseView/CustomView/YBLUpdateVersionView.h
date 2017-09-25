//
//  YBLUpdateVersionView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLUpdateReaseNotModel : NSObject

@property (nonatomic, copy  ) NSString *version;

@property (nonatomic, copy  ) NSString *releaseNot;

@end

typedef void(^UpdateVersionGoBlock)(void);

@interface YBLUpdateVersionView : UIView

+ (void)showUpdateVersionViewWithModel:(YBLUpdateReaseNotModel *)releaseModel
                             doneBlock:(UpdateVersionGoBlock)doneBlock;

@end
