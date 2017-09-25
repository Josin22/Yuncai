//
//  YBLCompanyTypePriceItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLEditPurchaseCell.h"

typedef void(^CompanyTypePriceItemCellNumTextfieldBlock)(NSString *text);

typedef void(^CompanyTypePriceItemCellPriceTextfieldBlock)(NSString *text);

@interface YBLCompanyTypePriceItemCell : UITableViewCell

@property (nonatomic, strong) CompanyTypePriceItemCellNumTextfieldBlock companyTypePriceItemCellNumTextfieldBlock;

@property (nonatomic, strong) CompanyTypePriceItemCellPriceTextfieldBlock companyTypePriceItemCellPriceTextfieldBlock;

@property (nonatomic, strong) YBLEditPurchaseCell *numCell;

@property (nonatomic, strong) YBLEditPurchaseCell *priceCell;

@end
