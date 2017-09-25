//
//  YBLReverseOrderBanner.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLReverseOrderBannerModel : NSObject

@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *image_name;

@end

@class YBLPurchaseDataCountModel;

@interface YBLReverseOrderBanner : UIView

@property (nonatomic, strong) YBLPurchaseDataCountModel *purchaseDataCountModel;

- (void)addTimer ;

- (void)removeTimer ;

@end
