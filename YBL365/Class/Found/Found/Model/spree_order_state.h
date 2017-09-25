//
//  spree_order_state.h
//  YC168
//
//  Created by 乔同新 on 2017/4/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface spree_order_button : NSObject
@property (nonatomic, copy   ) NSString           *button;
@property (nonatomic, copy   ) NSString           *action;
@end

@interface spree_order_state : NSObject
@property (nonatomic , copy  ) NSString           * spree_order_state_cn;
@property (nonatomic , copy  ) NSString           * spree_order_state_en;
@property (nonatomic , strong) spree_order_button *spree_order_button;
@end
