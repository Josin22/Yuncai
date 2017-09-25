//
//  YBLCategoryListHeadView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const key_composite = @"综合";
static NSString *const key_sale_count = @"销量";
static NSString *const key_price = @"价格";

typedef void(^CategoryListHeadViewItemClickBlock)(NSString *buttonTitle ,CurrentButtonState currentButtonState);

@interface YBLGoodListFilterItemHeadView : UIView

@property (nonatomic, copy  ) CategoryListHeadViewItemClickBlock categoryListHeadViewItemClickBlock;

@end
