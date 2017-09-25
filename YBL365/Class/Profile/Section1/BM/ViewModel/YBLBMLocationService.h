//
//  YBLBMLocationService.h
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseService.h"
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

@interface BMKPoiInfoModel : BMKPoiInfo

@property (nonatomic, assign) BOOL isSelect;

@end

@interface YBLBMLocationService : YBLBaseService

@end
