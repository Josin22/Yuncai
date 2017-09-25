//
//  YBLEvaluateTextSegment.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextImageButton.h"

@protocol YBLEvaluateTextSegmentDelegate <NSObject>

- (void)textDidSelectIndex:(NSInteger)index clickItem:(TextImageButton *)clickItem;

@end

@interface YBLEvaluateTextSegment : UIView

@property (nonatomic, weak) id<YBLEvaluateTextSegmentDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *nummberArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) UIFont *textFont;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray;

@end
