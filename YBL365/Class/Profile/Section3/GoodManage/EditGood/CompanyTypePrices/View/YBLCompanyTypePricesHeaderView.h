//
//  YBLCompanyTypePricesHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompanyTypePricesHeaderViewDirectionButtonBlock)(BOOL isShow);

@interface YBLCompanyTypePricesHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UISwitch *priceSwitch;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, copy  ) CompanyTypePricesHeaderViewDirectionButtonBlock companyTypePricesHeaderViewDirectionButtonBlock;

- (void)updatePriceArray:(id)priceArray;

+ (CGFloat)getHeaderHi;

@end
