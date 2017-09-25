//
//  YBLWalletsRecordModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWalletsRecordModel.h"

@implementation YBLWalletflowsItemModel

@end

@implementation YBLWalletsRecordModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"walletflows":[YBLWalletflowsItemModel class]};
    
}

@end
