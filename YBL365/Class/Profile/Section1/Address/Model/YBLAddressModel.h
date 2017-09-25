//
//  YBLAddressModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLAddressModel : NSObject

@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * province_name;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * consignee_phone;
@property (nonatomic , copy) NSString              * full_address;
@property (nonatomic , copy) NSString              * consignee_name;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * county;
@property (nonatomic , copy) NSString              * district;
@property (nonatomic , copy) NSString              * city_name;
@property (nonatomic , copy) NSString              * county_name;
@property (nonatomic , copy) NSString              * district_name;
@property (nonatomic , strong) NSMutableArray      * location;
@property (nonatomic , copy) NSString              * genre;
@property (nonatomic , copy) NSNumber              * _default;
@property (nonatomic , assign) BOOL                is_select;
///街道地址
@property (nonatomic , copy) NSString              * street_address;
///详细地址
@property (nonatomic , copy) NSString              * desc_address;
//纬度
@property (nonatomic,  strong) NSNumber            * lat;
//精度
@property (nonatomic,  strong) NSNumber            * lng;

@end
