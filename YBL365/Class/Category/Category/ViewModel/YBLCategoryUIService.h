//
//  YBLCategoryUIService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLCategoryLeftView.h"
#import "YBLCategoryRightView.h"

@interface YBLCategoryUIService : YBLBaseService

@property (nonatomic, strong) YBLCategoryLeftView *leftTableView;
@property (nonatomic, strong) YBLCategoryRightView *rightTableView;

@end
