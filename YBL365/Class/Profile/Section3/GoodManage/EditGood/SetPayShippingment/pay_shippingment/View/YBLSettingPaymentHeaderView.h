//
//  YBLSettingPaymentHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLShowPayShippingsmentModel;

typedef void(^SettingPaymentDependBlock)(YBLShowPayShippingsmentModel *selectPayModel,NSMutableArray *dependIDArray);

@interface YBLSettingPaymentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) SettingPaymentDependBlock settingPaymentDependBlock;

- (void)updateItemCellModel:(id)itemModel row:(NSInteger)row;

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel;

@end
