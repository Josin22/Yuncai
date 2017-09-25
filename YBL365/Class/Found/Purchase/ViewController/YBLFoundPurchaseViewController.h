//
//  YBLFoundPurchaseViewController.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef NS_ENUM(NSInteger, PurchaseType) {
    PurchaseTypeTab = 0,
    PurchaseTypeSingle
};


@interface YBLFoundPurchaseViewController : YBLMainViewController

@property (nonatomic, assign) PurchaseType purchaseType;

@end
