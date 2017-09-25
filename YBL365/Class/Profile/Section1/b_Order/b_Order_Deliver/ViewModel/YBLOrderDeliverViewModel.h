//
//  YBLOrderDeliverViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YBLOrderDeliverViewModel : NSObject

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) NSMutableArray *deliverDataArray;

@property (nonatomic, strong) RACSignal *deliverSignal;

@end
