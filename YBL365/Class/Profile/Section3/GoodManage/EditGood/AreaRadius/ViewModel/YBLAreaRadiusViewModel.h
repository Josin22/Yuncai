//
//  YBLAreaRadiusViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AreaRadiusViewModelBlock)(NSMutableArray *selectArray);

@interface YBLAreaRadiusViewModel : NSObject

@property (nonatomic, copy  ) AreaRadiusViewModelBlock areaRadiusViewModelBlock;

@property (nonatomic, strong) NSMutableArray *areaDataArray;

@property (nonatomic, strong) NSMutableArray *areaSelectDataArray;

@property (nonatomic, strong) NSMutableArray *savePriceArray;

- (void)handleData;

@end
