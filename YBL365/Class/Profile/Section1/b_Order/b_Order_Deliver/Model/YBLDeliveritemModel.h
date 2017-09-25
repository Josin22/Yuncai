//
//  YBLDeliveritemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLDeliveritemModel : NSObject

@property (nonatomic, copy  ) NSString *text;

@property (nonatomic, copy  ) NSString *name;

@property (nonatomic, copy  ) NSString *mobile;

@property (nonatomic, copy  ) NSString *next_state;

@property (nonatomic, copy  ) NSString *date_time;

@property (nonatomic, strong) NSArray *shipping_evidence_urls;

@end
