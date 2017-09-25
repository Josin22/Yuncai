//
//  YBLBrandView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLStoreBrandViewDelegate <NSObject>

- (void)brandItemClickToDelete:(NSInteger)index;

@end

@interface YBLStoreBrandView : UIView

@property (nonatomic, weak  ) id<YBLStoreBrandViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *brandDataArray;

@end
