//
//  YBLOrderMMMyDepositCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TypeDeposit) {
    
    TypeDepositDoing = 0,//正在进行中
    TypeDepositEndNotPay,//结束未支付
    TypeDepositEndBack//结束已返还
};

@interface YBLOrderMMMyDepositCell : UITableViewCell

@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, assign) TypeDeposit type;

+ (CGFloat)getDepositCellHeight;

@end
