//
//  YBLPayshipmentCell.h
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lineitems;

typedef NS_ENUM(NSInteger,WayType) {
    WayTypePay = 0,
    WayTypeShipping
};

typedef void(^PayshipmentCellButtonClickBlock)(id select_model,NSInteger index);

@interface YBLPayshipmentCell : UITableViewCell

@property (nonatomic,copy) PayshipmentCellButtonClickBlock payshipmentCellButtonClickBlock;

@property (nonatomic, assign) WayType wayType;

- (void)updateModel:(lineitems *)model;

+ (CGFloat)getHi;

@end
