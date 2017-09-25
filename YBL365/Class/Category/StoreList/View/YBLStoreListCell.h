//
//  YBLStoreListCell.h
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLStoreBaseInfoCell.h"
@class YBLGoodModel;

typedef void(^StoreListGoodClickBlock)(YBLGoodModel *selectGoodModel);

@interface YBLStoreListCell : YBLStoreBaseInfoCell

@property (nonatomic, copy  ) StoreListGoodClickBlock storeListGoodClickBlock;

@end
