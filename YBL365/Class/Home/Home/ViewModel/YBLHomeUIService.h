//
//  YBLHomeUIService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLHomeUIService : YBLBaseService

@property (nonatomic, strong) UICollectionView *homeCollectionView;
//首页tabview的滚动距离
@property (nonatomic, assign) CGFloat contentY;

- (void)requestHomeData;

- (void)startTimer;

- (void)stopTimer;

@end
