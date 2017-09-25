//
//  YBLScanRecordsModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BGModel.h"

static NSString *const Record_Key = @"RecordKey";

typedef NS_ENUM(NSInteger, ScanType) {
    ScanTypeText = 0,
    ScanTypeGood,
    ScanTypeURL
};

@interface YBLScanRecordsModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) ScanType scanType;

@property (nonatomic, copy) NSString *content_title;

@property (nonatomic, assign) CGFloat content_height;

@end
