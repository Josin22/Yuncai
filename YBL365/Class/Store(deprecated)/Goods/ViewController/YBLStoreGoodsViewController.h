//
//  YBLStoreGoodsViewController.h
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef void(^scrollViewBlock)(CGFloat alpha, UIScrollView * scrollView);


@interface YBLStoreGoodsViewController : YBLMainViewController
@property (nonatomic ,assign) BOOL isChangeList;

@property (nonatomic, copy) scrollViewBlock scrollYBlock;

@property (nonatomic, assign) BOOL isShowSelect;

- (void)updateFeameWithY:(CGFloat)heightY;

@end
