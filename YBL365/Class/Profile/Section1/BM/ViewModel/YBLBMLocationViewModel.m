//
//  YBLBMLocationViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBMLocationViewModel.h"

@interface YBLBMLocationViewModel ()
@end

@implementation YBLBMLocationViewModel

- (BOOL)checkLocationServicesIsEnabled{
    
    BOOL isEnable = NO;
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status = [CLLocationManager authorizationStatus];
    if(!enable || status<3){
        isEnable = NO;
    } else {
        isEnable = YES;
    }
    return isEnable;
}



@end
