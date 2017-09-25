//
//  YBLSeckillSegmentControl.h
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLSeckillSegmentControlDelegate <NSObject>

- (void)seckillSegmentControlIndex:(NSInteger)index;

@end

@interface YBLSeckillSegmentControl : UIView

@property (nonatomic, weak) id<YBLSeckillSegmentControlDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *timesArray;

@property (nonatomic, assign) NSInteger currentIndex;

@end
