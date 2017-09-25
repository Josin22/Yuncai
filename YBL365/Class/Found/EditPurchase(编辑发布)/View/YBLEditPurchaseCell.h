//
//  YBLEditPurchaseCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLEditItemGoodParaModel.h"

@interface YBLEditPurchaseCell : UITableViewCell

@property (nonatomic, retain) UILabel     *ttLabel;

@property (nonatomic, strong) UIButton    *maskButton;

@property (nonatomic, strong) UITextField *valueTextFeild;

@property (nonatomic, retain) UILabel     *valueTextLabel;

@property (nonatomic, strong) UIButton    *arrowButton;

@property (nonatomic, strong) UISwitch    *good_switch;

@property (nonatomic, strong) UIView      *lineView;

@end
