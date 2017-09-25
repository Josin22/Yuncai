//
//  YBLSingleTextSegment.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLSingleTextSegmentDelegate <NSObject>

@optional;

- (void)CurrentSegIndex:(NSInteger)index;
/**
 *  已选择segment 重复点击
 *
 *  @param index 当前选择索引
 */
- (void)CurrentSegIndexReclick:(NSInteger)index;

@end

@interface YBLSingleTextSegment : UIView

@property (nonatomic, assign) BOOL enableSegment;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) NSInteger currentInex;

@property (nonatomic, weak) id<YBLSingleTextSegmentDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)array;

- (void)repalceTitleWith:(NSString *)text repIndex:(NSInteger)repIndex;

@end
