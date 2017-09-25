//
//  YBLOrderBarrageView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderBarrageViewDelegate <NSObject>

- (void)orderBarrageViewItemSelect:(id)selectModel;

@end

@interface YBLOrderBarrageView : UIView

@property (nonatomic, weak  ) id<OrderBarrageViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isStopRunning;

@end
