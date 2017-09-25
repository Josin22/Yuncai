//
//  YBLStoreTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StoreListType) {
    StoreListTypeBaseInfo = 0,
    StoreListTypeSearch,
    StoreListTypeRedBag
};

@interface YBLStoreTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     listType:(StoreListType)listType;

@end
