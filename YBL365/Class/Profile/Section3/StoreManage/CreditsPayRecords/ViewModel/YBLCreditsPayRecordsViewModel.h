//
//  YBLCreditsPayRecordsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLCreditsPayRecordsModel.h"

@interface YBLCreditsPayRecordsViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *recordsDataArray;

- (RACSignal *)siganlForCreditRecords;

@end
