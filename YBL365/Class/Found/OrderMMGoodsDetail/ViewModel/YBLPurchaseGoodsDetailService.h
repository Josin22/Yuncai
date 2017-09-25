//
//  YBLPurchaseGoodsDetailService.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLPurchaseGoodsDetailService : YBLBaseService

@property (nonatomic, strong) UITableView *orderMMGoodsDetailTableView;

- (void)requestSingleRecords;

- (void)saveQRCodeIamge;

@end
