//
//  YBLOrderAddressView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddressModel;

@interface YBLOrderAddressView : UIView

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIButton *addressButton;

@property (nonatomic, retain) UILabel *namePhoneLabel;
@property (nonatomic, retain) UILabel *addressLabel;

- (void)updateAdressModel:(YBLAddressModel *)model;

@end


