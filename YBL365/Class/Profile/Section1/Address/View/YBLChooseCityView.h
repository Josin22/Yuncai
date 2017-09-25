//
//  YBLChooseCityView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLAddressViewModel.h"

typedef NS_ENUM(NSInteger,ChooseCityViewType) {
    ChooseCityViewTypeWithDismissButton = 0,
    ChooseCityViewTypeWithDoneButton
};

typedef void(^ChooseCitySuccessBlcok)(YBLAddressAreaModel *model,NSMutableArray *selectArray);

@interface YBLChooseCityView : UIView

+ (void)chooseCityWithViewController:(UIViewController *)VC
                           cityCount:(NSInteger)cityCount
                        cityViewType:(ChooseCityViewType)cityViewType
                        successBlock:(ChooseCitySuccessBlcok)successBlock;

@end
