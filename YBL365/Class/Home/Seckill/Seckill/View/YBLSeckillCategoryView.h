//
//  YBLSeckillCategoryView.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryViewDismissBlock)();

typedef void(^CategoryViewClickBlock)(NSString *selectTitlte,NSInteger selectIndex);

@interface YBLSeckillCategoryView : UIView

///
+ (void)showCategoryViewOnView:(UIView *)view
                     DataArray:(NSMutableArray *)dataArray
                   SelectIndex:(NSInteger)index
                   SelectBlock:(CategoryViewClickBlock)block
                  DismissBlock:(CategoryViewDismissBlock)misBlock;

+ (void)dismissView;

@end
