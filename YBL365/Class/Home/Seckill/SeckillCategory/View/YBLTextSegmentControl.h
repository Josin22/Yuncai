//
//  YBLTextSegmentControl.h
//  YBL365
//
//  Created by 乔同新 on 12/23/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLTextSegmentControlDelegate <NSObject>

@optional

- (void)textSegmentControlIndex:(NSInteger)index;

- (void)textSegmentControlIndex:(NSInteger)index selectModel:(id)model;

@end

typedef NS_ENUM(NSInteger,TextSegmentType) {
    TextSegmentTypeCategoryArrow = 0,//分类
    TextSegmentTypeLocationArrow,//三级地址库
    TextSegmentTypeGoodsDetail, //商品详情
    TextSegmentTypeNoArrow      //纯文字滚动
};

typedef void(^YBLTextSegmentControlShowAllBlock)(BOOL isShow);

@interface YBLTextSegmentControl : UIView

@property (nonatomic, assign) BOOL enableSegment;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, copy  ) NSString *selectLocation;

@property (nonatomic, weak) id<YBLTextSegmentControlDelegate>delegate;

@property (nonatomic, copy) YBLTextSegmentControlShowAllBlock textSegmentControlShowAllBlock;

- (instancetype)initWithFrame:(CGRect)frame TextSegmentType:(TextSegmentType)type;

- (void)updateTitleData:(NSMutableArray *)data;

- (void)defaultView;

@end
