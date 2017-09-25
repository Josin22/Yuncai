//
//  YBLFloorsModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLFloorsModel : NSObject

@property NSString *id;
@property NSString *title;
@property NSString *avatar;
@property NSString *num;
@property NSString *parent_id;
@property NSMutableArray *parent_ids;
@property NSString *depth;

@end
