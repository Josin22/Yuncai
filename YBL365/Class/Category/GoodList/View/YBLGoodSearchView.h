//
//  YBLGoodSearchView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GoodSearchCancelBlock)(void);
typedef void(^GoodSearchClickBlock)(NSString *searchText,SearchType searchType);
typedef void(^GoodSearchAnimationEndBlock)(void);

typedef NS_ENUM(NSInteger,rightItemViewType) {
    rightItemViewTypeHomeNews = 0,
    rightItemViewTypeCatgeoryNews,
    rightItemViewTypeNone,
    //无记录
    rightItemViewTypeNoView
};

@interface YBLGoodSearchView : UIView

+ (void)showGoodSearchViewWithRightItemViewType:(rightItemViewType)itemType
                                   SearchHandle:(GoodSearchClickBlock)searchBlock
                                   cancleHandle:(GoodSearchCancelBlock)cancelBlock
                             animationEndHandle:(GoodSearchAnimationEndBlock)endBlock
                                    currentText:(NSString *)currentText;

+ (void)showGoodSearchViewWithVC:(UIViewController *)Vc
               RightItemViewType:(rightItemViewType)itemType
                    SearchHandle:(GoodSearchClickBlock)searchBlock
                    cancleHandle:(GoodSearchCancelBlock)cancelBlock
              animationEndHandle:(GoodSearchAnimationEndBlock)endBlock
                     currentText:(NSString *)currentText;

@end
