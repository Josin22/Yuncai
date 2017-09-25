//
//  YBLSearchModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSearchModel.h"

@implementation YBLSearchModel

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.keyWord = [aDecoder decodeObjectForKey:@"keyWord"];
        self.searchType = [aDecoder decodeIntegerForKey:@"searchType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.keyWord forKey:@"keyWord"];
    [aCoder encodeInteger:self.searchType forKey:@"searchType"];
}

+ (YBLSearchModel *)getSearchModelWithKeyword:(NSString *)keyword searchType:(SearchType)searchType{
    YBLSearchModel *searm = [YBLSearchModel new];
    searm.keyWord = keyword;
    searm.searchType = searchType;
    return searm;
}

@end
