//
//  YBLGoodListManageTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLGoodModel;

typedef NS_ENUM(NSInteger,GoodManageButtonStatus) {
    /**
     *  上架
     */
    GoodManageButtonStatusRack = 0,
    /**
     *  销售中
     */
    GoodManageButtonStatusOnline,
    /**
     *  已下架
     */
    GoodManageButtonStatusOffline
};

typedef void(^GoodListManageTableViewCellDidSelectBlock)(NSIndexPath *indexPath,YBLGoodModel *model);

typedef void(^GoodListManageTableViewButtonClickBlock)(NSIndexPath *indexPath,YBLGoodModel *model);

@interface YBLGoodListManageTableView : UITableView

@property (nonatomic, copy  ) GoodListManageTableViewCellDidSelectBlock goodListManageTableViewCellDidSelectBlock;

@property (nonatomic, copy  ) GoodListManageTableViewButtonClickBlock goodListManageTableViewButtonClickBlock;

@end
