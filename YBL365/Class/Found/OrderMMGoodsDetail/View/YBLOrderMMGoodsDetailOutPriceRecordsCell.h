//
//  YBLOrderMMGoodsDetailOutPriceRecordsCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLOrderMMOutPriceView : UIView

@end

@interface YBLOrderMMGoodsDetailOutPriceRecordsCell : UITableViewCell

@property (nonatomic, strong) UILabel *recordLabel;

@property (nonatomic, strong) UIButton *moreButton;

+ (CGFloat)getGoodsDetailOutPriceRecordsCellHeight;

@end
