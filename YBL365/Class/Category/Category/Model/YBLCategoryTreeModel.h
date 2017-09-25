//
//  YBLCategoryTreeModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCategoryTreeModel : NSObject

@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *para_value;
@property (nonatomic, copy  ) NSString *para_three_value;
@property (nonatomic, copy  ) NSString *avatar;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, copy  ) NSString *parent_id;
@property (nonatomic, strong) NSArray  *parent_ids;
@property (nonatomic, strong) NSNumber *depth;

@end
