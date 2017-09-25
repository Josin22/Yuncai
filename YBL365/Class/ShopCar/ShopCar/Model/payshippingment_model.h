//
//  payshippingment_model.h
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payshippingment_model : NSObject

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *need_face_to_face;

@property (nonatomic, strong) NSNumber *same_city;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *payment_method_id;

@property (nonatomic, strong) NSString *shipping_method_id;

@property (nonatomic, strong) NSMutableArray *permit_payment_method_ids;

@property (nonatomic, strong) NSMutableArray *permit_shipping_method_ids;

@end
