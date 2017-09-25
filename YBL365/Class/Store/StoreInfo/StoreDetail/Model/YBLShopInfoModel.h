//
//  YBLShopInfoModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLShopInfoModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *shop_intro;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *company_name;
@property (nonatomic, strong) NSString *registration_numbe;
@property (nonatomic, strong) NSString *company_type;
@property (nonatomic, strong) NSString *leal_person;
@property (nonatomic, strong) NSString *seat;
@property (nonatomic, strong) NSString *capital;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *useful_life_from;
@property (nonatomic, strong) NSString *useful_life_end;
@property (nonatomic, strong) NSString *liutong;
@property (nonatomic, strong) NSMutableArray   *range;
@property (nonatomic, strong) NSMutableArray   *licensing_brand;
@property (nonatomic, strong) NSString         *full_address;
@property (nonatomic, strong) YBLUserInfoModel *userinfo;

@end
