//
//  YBLUserInfosParaModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLUserInfosParaModel : NSObject

@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *companytype;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *addressfour;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, copy  ) NSString *usertype;

@property (nonatomic, strong) NSString *acct_name;
@property (nonatomic, strong) NSString *acct_pan;
@property (nonatomic, strong) NSString *bankname;
@property (nonatomic, strong) NSString *cert_id;
@property (nonatomic, strong) NSString *phone_num;
@property (nonatomic, strong) NSString *pickuppassword;

@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSString *desc_address;

@end
