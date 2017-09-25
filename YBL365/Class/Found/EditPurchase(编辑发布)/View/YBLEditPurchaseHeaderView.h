//
//  YBLEditPurchaseHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLEditPurchaseHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *nameLabel;

+ (CGFloat)getEditPurchaseHeadeHeight;

@end
