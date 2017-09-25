//
//  YBLMyPurchaseTableView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLFoundMyPurchaseViewController,YBLMyPurchaseViewModel;

@interface YBLMyPurchaseTableView : UITableView

@property (nonatomic, weak  ) YBLFoundMyPurchaseViewController *VC;

@property (nonatomic, weak  ) YBLMyPurchaseViewModel           *viewModel;

@property (nonatomic, copy  ) ViewPrestrainBlock               myPurchasePrestrainBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style PurchaseType:(MyPurchaseType)type;

@end
/*
typedef NS_ENUM(NSInteger , PurchaseType) {
    PurchaseTypeMyPuchaseOrder = 0, //我的订单
    PurchaseTypeMyPuchase,          //我的采购
    PurchaseTypeAllRecords          //全部采购记录
};
*/
