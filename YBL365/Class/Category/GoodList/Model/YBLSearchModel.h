//
//  YBLSearchModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const search_key = @"YBLSearchModel";

@interface YBLSearchModel : NSObject<NSCoding>

@property (nonatomic, assign) SearchType searchType;

@property (nonatomic, strong) NSString *keyWord;

+ (YBLSearchModel *)getSearchModelWithKeyword:(NSString *)keyword searchType:(SearchType)searchType;

@end
