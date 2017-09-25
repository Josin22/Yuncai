//
//  YBLProductShareModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"

@interface YBLProductShareModel : NSObject

@property (nonatomic, copy  ) NSString     *id;
@property (nonatomic, strong) NSNumber     *total;
@property (nonatomic, strong) NSNumber     *per;
@property (nonatomic, strong) NSNumber     *remain;
@property (nonatomic, strong) NSNumber     *shared_count;
@property (nonatomic, strong) NSNumber     *visit_count;
@property (nonatomic, copy  ) NSString     *status;
@property (nonatomic, strong) YBLGoodModel *product;

@property (nonatomic, copy  ) NSString     *han_status;

@property (nonatomic, copy  ) NSString     *han_total_per;
@property (nonatomic, retain) NSMutableAttributedString     *att_total_per;

@property (nonatomic, copy  ) NSString     *han_shared_visit_count;
@property (nonatomic, retain) NSMutableAttributedString     *att_han_shared_visit_count;

@end
