//
//  YBLExpressCompantItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLExpressCompanyItemModel : NSObject

@property (nonatomic, copy  ) NSString *id;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *creator_id;

@property (nonatomic, copy  ) NSString *avatar;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, assign) BOOL     is_select;

@end
