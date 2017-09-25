//
//  YBLStoreLookBusinessLicenseImageVC.h
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

@class YBLShopInfoModel;

@interface YBLStoreLookBusinessLicenseImageVC : YBLMainViewController

@property (nonatomic, strong) YBLShopInfoModel *shopInfoModel;

@property (nonatomic, copy  ) NSString         *licenseURL;

@property (nonatomic, assign) BOOL             isSelfStore;

@end
