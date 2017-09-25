//
//  YBLActionSheetView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetClickBlock)(NSInteger index);

@interface YBLActionSheetView : UIView

+ (void)showActionSheetWithTitles:(NSArray *)titlesArray
                      handleClick:(ActionSheetClickBlock)clickBlock;


@end
