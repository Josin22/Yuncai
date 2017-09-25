//
//  YBLStoreLogoView.h
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^storeDetailBlock)();

@interface YBLStoreLogoView : UIView
@property (nonatomic, strong) UIButton * collectBtn;
@property (nonatomic, copy) storeDetailBlock storeDetailBlock;

- (void)changeFrame;

@end
