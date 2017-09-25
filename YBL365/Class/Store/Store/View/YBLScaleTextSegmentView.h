//
//  YBLScaleTextSegmentView.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLScaleTextSegmentViewDelegate <NSObject>

- (void)textSegmentControlIndex:(NSInteger)index;

@end

@interface YBLScaleTextSegmentView : UIView

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSMutableArray *topValue;
@property (nonatomic, strong) NSMutableArray *bottomsValue;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id<YBLScaleTextSegmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                      UpValue:(NSArray *)upValue
                  BottomValue:(NSArray *)bottomValue;

@end
