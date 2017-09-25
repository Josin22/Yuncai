//
//  YBLMyPurchaseCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLPurchaseOrderModel;

typedef void(^MyPurchaseCellButtonBlock)(YBLPurchaseOrderModel *selectModel,NSString *currentTitle);

@interface YBLMyPurchaseCell : UITableViewCell

@property (nonatomic, strong) UIButton *clickPurchaseGoodButton;

@property (nonatomic, copy  ) MyPurchaseCellButtonBlock myPurchaseCellButtonBlock;

@end
