//
//  YBLEditPurchaseSingleView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ditPurchaseSingleViewType) {
    ditPurchaseSingleViewTypeGoodsName = 0, //
    ditPurchaseSingleViewTypeSpec,          //
    ditPurchaseSingleViewTypeQRCode         //
};

typedef void(^EditPurchaseSingleViewSelectBlock)(NSString *selectValue);

@interface YBLEditPurchaseSingleView : UIView

+ (void)showEditPurchaseSingleViewInVC:(UIViewController *)VC
                                  Data:(NSMutableArray *)data
                                  Type:(ditPurchaseSingleViewType)type
                                Handle:(EditPurchaseSingleViewSelectBlock)block;


@end
