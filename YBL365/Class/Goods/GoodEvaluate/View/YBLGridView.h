//
//  YBLGridView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GridViewItemClickBlock)(NSInteger index,UIImageView *clickImageView);

@interface YBLGridView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                 gridViewType:(GridViewType)gridViewType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) GridViewItemClickBlock itemClickBlock;

@end
