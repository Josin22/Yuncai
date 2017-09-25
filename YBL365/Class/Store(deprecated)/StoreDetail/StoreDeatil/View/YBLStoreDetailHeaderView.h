//
//  YBLStoreDetailHeaderView.h
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonSelectBlock)(NSInteger selectIndex);

@interface YBLStoreDetailHeaderView : UIView

@property (nonatomic, copy) buttonSelectBlock buttonSelectBlock;

@end
