//
//  YBLCreditsPayRecordsModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCreditsPayRecordsModel : NSObject

@property (nonatomic, copy  ) NSString         *id;
@property (nonatomic, strong) NSString         *number;
@property (nonatomic, strong) NSNumber         *price;
@property (nonatomic, strong) NSNumber         *state;
@property (nonatomic, copy  ) NSString         *title;
@property (nonatomic, strong) NSNumber         *pay_mode;
@property (nonatomic, copy  ) NSString         *pay_url;
@property (nonatomic, copy  ) NSString         *paid_at;
@property (nonatomic, strong) NSNumber         *platform_profit;
@property (nonatomic, strong) NSNumber         *province_profit;
@property (nonatomic, strong) NSNumber         *agency_profit;
@property (nonatomic, strong) YBLUserInfoModel *userinfo;

@end
