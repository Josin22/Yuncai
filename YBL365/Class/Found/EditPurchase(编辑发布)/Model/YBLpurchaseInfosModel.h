//
//  YBLPurchaseInfosModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLPurchaseInfosModel : NSObject

@property (nonatomic , copy  ) NSString       * _id;
@property (nonatomic , copy  ) NSString       * parent_id;
@property (nonatomic , copy  ) NSString       * id;
@property (nonatomic , copy  ) NSString       * title;
@property (nonatomic , copy  ) NSString       * code;
@property (nonatomic , copy  ) NSString       * type;
@property (nonatomic , copy  ) NSString       * time;
@property (nonatomic , copy  ) NSString       * desc;
@property (nonatomic , strong) NSNumber       * active;
@property (nonatomic , strong) NSNumber       * same_city;
@property (nonatomic , strong) NSNumber       * depth;
@property (nonatomic , assign) BOOL           is_select;
@property (nonatomic , strong) NSMutableArray *purchase_pay_type_ids;
@property (nonatomic , strong) NSMutableArray *purchase_distribution_ids;
/**
 *  @[@[同城],@[异地]]
 */
@property (nonatomic , strong) NSMutableArray *filter_purchase_distribution_data;

@end
