//
//  UICollectionViewCell+updateModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (updateModel)

- (void)updateItemCellModel:(id)itemModel;

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel;

@end
