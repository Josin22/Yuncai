//
//  YBLDBManage.h
//  YC168
//
//  Created by 乔同新 on 2017/6/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLGoodModel;

@interface YBLDBManage : NSObject

+ (YBLDBManage *)shareDB;

- (void)saveRecordsGoodDetailModel:(YBLGoodModel *)good;

- (void)deleRecordsGoodModelByGoodID:(NSString *)goodID;

- (NSMutableArray *)getRecordsGoodDataArray;

- (NSMutableArray *)getTenRecordsGoodDataArray;

- (void)cleanAllRecordsGood;

- (NSInteger)getRecordsCount;

@end
