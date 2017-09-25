//
//  YBLOrderStoreFooter.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLCartModel;

@interface YBLOrderStoreFooter : UITableViewHeaderFooterView

@property (nonatomic, strong) XXTextField *liuyanTextFeild;
//运费
@property (nonatomic, strong) UIButton *hesuanyunfeiButton;
//支付配送
@property (nonatomic, strong) UIButton *zhifupeisongBtn;
//票据
@property (nonatomic, strong) UIButton *invoiceButton;
//票据
@property (nonatomic, retain) UILabel *invoiceLabel;
/**
 *  支付方式
 */
@property (nonatomic, retain) UILabel *zfps_1_label;
/**
 *  配送方式
 */
@property (nonatomic, retain) UILabel *zfps_2_label;

- (void)updateShopModel:(YBLCartModel *)model;

+ (CGFloat)getOrderStoreFooterHi;

@end
