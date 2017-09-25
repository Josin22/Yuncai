//
//  YBLBaseInfoViewController.h
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

@class YBLAddressAreaModel;

@interface YBLBaseInfoViewController : YBLMainViewController

@property (nonatomic, strong) UIButton               *addressButton;

@property (nonatomic, strong) UIButton               *jieadao_addressButton;

@property (nonatomic, strong) XXTextField            *storeNameTextFeild;

@property (nonatomic, retain) UILabel                *storeNameLabel;

@property (nonatomic, strong) XXTextField            *contactTextFeild;

@property (nonatomic, retain) UILabel                *contactLabel;

@property (nonatomic, strong) XXTextField            *menpaihaoTextFeild;

@property (nonatomic, strong) UITextField            *addressInfoTextFeild;

@property (nonatomic, strong) UIScrollView           *contentScrollView;

@property (nonatomic, strong) YBLAddressAreaModel    *addressModel;

@property (nonatomic, assign) CLLocationCoordinate2D local_pt;

@property (nonatomic, strong) UIView                 *menpaihaolView;

@end
