//
//  YBLChooseDeliveryGoodAndLogisticsCompanyCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLEditPurchaseCell;

typedef void(^ChooseDeliveryGoodAndLogisticsCompanyCellItemBlock)(id model);

typedef void(^ChooseDeliveryGoodAndLogisticsCompanyCellButtonClickBlock)(void);

@interface YBLChooseDeliveryGoodAndLogisticsCompanyCell : UITableViewCell

@property (nonatomic, copy) ChooseDeliveryGoodAndLogisticsCompanyCellItemBlock chooseDeliveryGoodAndLogisticsCompanyCellItemBlock;

@property (nonatomic, copy) ChooseDeliveryGoodAndLogisticsCompanyCellButtonClickBlock chooseDeliveryGoodAndLogisticsCompanyCellButtonClickBlock;

@property (nonatomic, retain) UILabel *titleNameLable;

@property (nonatomic, strong) UIButton *selectAllButton;

@property (nonatomic, strong) YBLEditPurchaseCell *numCell;

- (void)updateSection:(NSInteger)section;

@end
