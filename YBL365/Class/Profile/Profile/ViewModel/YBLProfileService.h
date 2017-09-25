//
//  YBLProfileService.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseService.h"
#import "YBLProfileWaveHeaderView.h"

@interface YBLProfileService : YBLBaseService

@property (nonatomic, strong) YBLProfileWaveHeaderView *waveHeaderView;

- (void)requestUserInfoData;

@end
