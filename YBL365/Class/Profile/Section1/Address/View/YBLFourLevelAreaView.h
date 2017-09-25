//
//  YBLFourLevelAreaView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLAddressAreaModel.h"

typedef NS_ENUM(NSInteger,AreaViewType) {
    /**
     *  无需done按钮
     */
    AreaViewTypeWithoutDoneButton = 0,
    /**
     *  done button
     */
    AreaViewTypeWithDoneButton
};

typedef void(^AreaViewCompletionBlcok)(YBLAddressAreaModel *lastAreaModel,NSMutableArray *selectAllAreaDataArray);

typedef void(^AreaViewCancelBlcok)(void);

@interface YBLFourLevelAreaView : UIView

+ (void)showFourLevelAreaViewFromVc:(UIViewController *)fromVc
                           echoData:(NSMutableArray *)echoData
                       areaViewType:(AreaViewType)areaViewType
                     areaLevelCount:(NSInteger)areaLevelCount
                    completionBlock:(AreaViewCompletionBlcok)completionBlock
                        cancelBlock:(AreaViewCancelBlcok)cancelBlock;

@end
