//
//  YBLShowSelectAreaRadiusView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseView.h"

typedef void(^ShowSelectAreaRadiusViewDoneBlock)(void);

@interface YBLShowSelectAreaRadiusView : YBLBaseView

+ (void)showselectAreaRadiusViewFromVC:(UIViewController *)Vc
                    distanceRadiusType:(DistanceRadiusType)distanceRadiusType
                   areaRadiusDataArray:(NSMutableArray *)areaRadiusDataArray
                            doneHandle:(ShowSelectAreaRadiusViewDoneBlock)doneBlock;

@end
