//
//  YBLShopCarService.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseService.h"
#import "YBLShopCarBarView.h"

@interface YBLShopCarService : YBLBaseService

@property (nonatomic, strong) YBLShopCarBarView *barView;

@property (nonatomic, strong) UITableView *carTableView;

- (void)requestShopCarData;

@end
