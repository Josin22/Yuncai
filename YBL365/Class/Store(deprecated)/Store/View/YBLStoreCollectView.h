//
//  YBLStoreCollectView.h
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismissBlock)();

@interface YBLStoreCollectView : UIView

@property (nonatomic, copy) dismissBlock dismissBlock;

- (void)showWithCollect:(BOOL)collect;
@end
