//
//  YBLSelectAreaCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLBaseView.h"

typedef void(^SelectAreaCollectionViewDoneBlock)(NSMutableArray *renew_array);

typedef NS_ENUM(NSInteger,SelectAreaType) {
    SelectAreaTypeShow = 0,
    SelectAreaTypeSave
};

@interface YBLSelectAreaCollectionView : YBLBaseView

+ (void)showSelectAreaCollectionViewFromVC:(UIViewController *)Vc
                                  areaData:(NSMutableArray *)areaData
                                doneHandle:(SelectAreaCollectionViewDoneBlock)doneBlock;

+ (void)showSelectAreaCollectionViewFromVC:(UIViewController *)Vc
                            selectAreaType:(SelectAreaType)selectAreaType
                                  areaData:(NSMutableArray *)areaData
                                doneHandle:(SelectAreaCollectionViewDoneBlock)doneBlock;

@end
