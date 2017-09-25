//
//  YBLCategoryViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLCategoryTreeModel.h"

@interface YBLCategoryViewModel : NSObject

@property (nonatomic, assign) GoodCategoryType goodCategoryType;

@property (nonatomic, strong) NSMutableArray *topCategoryArray;
///key1:section key2:row 
@property (nonatomic, strong) NSMutableDictionary *allSubTreeCategoryDict;

- (RACSignal *)singalForCategoryTreeWithId:(NSString *)ids Index:(NSInteger)index;

@end
