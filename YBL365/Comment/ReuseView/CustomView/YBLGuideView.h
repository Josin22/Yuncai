//
//  YBLGuideView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuideViewDoneBlock)(void);

@interface YBLGuideView : UIView

+ (void)showGuideViewWithDataArray:(NSMutableArray *)dataArray doneBlock:(GuideViewDoneBlock)doneBlock;

@end
