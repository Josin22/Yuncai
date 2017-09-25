//
//  YBLStoreHeaderView.h
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^storeCollectBlock)(BOOL isCollect);

typedef void(^classifyButtonBlock)(NSInteger tag,
                                    BOOL isSeclect);
typedef void(^storeDetailBlock)();


@interface YBLStoreHeaderView : UIView

@property (nonatomic, copy) storeCollectBlock storeCollectBlock;

@property (nonatomic, copy) classifyButtonBlock classifyButtonBlock;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) storeDetailBlock storeDetailBlock;


@end
