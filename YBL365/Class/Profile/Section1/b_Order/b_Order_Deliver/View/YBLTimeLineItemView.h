//
//  YBLTimeLineItemView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TimeLineState) {
    TimeLineStateStartPoint = 0,//开始
    TimeLineStatePointLine,     //线
    TimeLineStateEndPoint       //结束
};

@interface YBLTimeLineItemView : UIView

@property (nonatomic, strong) UIColor *tinColor;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, assign) CGFloat pointLength;

@property (nonatomic, assign) CGFloat pointLineWidth;

@property (nonatomic, assign) TimeLineState timeLineState;

- (void)animate;

@end
