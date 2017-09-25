//
//  YBLOrderMMHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderClickBlock)(NSInteger index);

@interface YBLOrderMMHeaderView : UIView

@property (nonatomic, copy) HeaderClickBlock headerClickBlock;

- (instancetype)initWithFrame:(CGRect)frame ValueArray:(NSArray *)array;

@end
