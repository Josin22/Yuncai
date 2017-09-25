//
//  YBLStorePromotionViewController.h
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef void(^scrollViewBlock)(CGFloat alpha, UIScrollView * scrollView);

@interface YBLStorePromotionViewController : YBLMainViewController

@property (nonatomic, copy) scrollViewBlock scrollYBlock;

- (void)updateFeameWithY:(CGFloat)heightY;

@end
