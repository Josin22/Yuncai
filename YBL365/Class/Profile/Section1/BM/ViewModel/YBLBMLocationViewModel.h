//
//  YBLBMLocationViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

typedef void(^MapSelectBlock)(BMKPoiInfo *model);

@interface YBLBMLocationViewModel : NSObject

@property (nonatomic, strong) BMKPoiInfo *currentModel;

@property (nonatomic, copy  ) MapSelectBlock mapSelectBlock;

- (BOOL)checkLocationServicesIsEnabled;


@end
