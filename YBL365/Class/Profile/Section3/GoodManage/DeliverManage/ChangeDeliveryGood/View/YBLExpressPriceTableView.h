//
//  YBLExpressPriceTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExpressPriceTableViewCellDidSelectRowBlock)(NSIndexPath *indexPath,id model);

@interface YBLExpressPriceTableView : UITableView

@property (nonatomic, copy) ExpressPriceTableViewCellDidSelectRowBlock expressPriceTableViewCellDidSelectRowBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style distanceRadiusType:(DistanceRadiusType)distanceRadiusType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isCanDelete;

@end
