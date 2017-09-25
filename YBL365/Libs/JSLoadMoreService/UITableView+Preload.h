//
//  UITableView+Prereload.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import <UIKit/UIKit.h>

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;

/**
 *  预加载触发的数量
 */
static NSInteger const PreloadMinCount = 10;

typedef void(^PreloadBlock)(void);

typedef void(^ReloadBlock)(void);

@interface UITableView (Prereload)
/**
 *  预加载回调
 */
@property (nonatomic, copy  ) PreloadBlock js_preloadBlock;
/**
 *  tableview数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  计算当前index是否达到预加载条件并回调
 *
 *  @param currentIndex row or section
 */
- (void)preloadDataWithCurrentIndex:(NSInteger)currentIndex;
/**
 *  上拉刷新
 *
 *  @param js_reloadBlock 刷新回调
 */
- (void)headerReloadBlock:(ReloadBlock)js_reloadBlock;
/**
 *  结束上拉刷新
 */
- (void)endReload;

@end
