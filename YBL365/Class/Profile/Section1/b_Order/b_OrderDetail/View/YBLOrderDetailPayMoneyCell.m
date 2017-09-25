//
//  YBLOrderDetailPayMoneyCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailPayMoneyCell.h"
#import "YBLOrderItemModel.h"

@interface YBLOrderDetailPayMoneyCell ()

@end

@implementation YBLOrderDetailPayMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.confirmCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2-space, 20)];
    self.confirmCodeLabel.textColor = YBLThemeColor;
    self.confirmCodeLabel.font = YBLFont(14);
//    self.confirmCodeLabel.centerY = hei/2;
    [self.contentView addSubview:self.confirmCodeLabel];
    self.confirmCodeLabel.hidden = YES;
    
    self.payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth-space, 35)];
    self.payMoneyLabel.text = loadString;
    self.payMoneyLabel.textColor = YBLThemeColor;
    self.payMoneyLabel.font = YBLFont(16);
    self.payMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.payMoneyLabel];
    
    self.payTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.payMoneyLabel.bottom, self.payMoneyLabel.width, 20)];
    self.payTimeLabel.text = loadString;
    self.payTimeLabel.textColor = YBLTextColor;
    self.payTimeLabel.font = YBLFont(12);
    self.payTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.payTimeLabel];
    
    self.finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.payTimeLabel.bottom, self.payMoneyLabel.width, 20)];
    self.finishTimeLabel.text = loadString;
    self.finishTimeLabel.textColor = YBLTextColor;
    self.finishTimeLabel.font = YBLFont(12);
    self.finishTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.finishTimeLabel];
}

- (void)updateItemCellModel:(id)itemModel{
    YBLOrderItemModel *itemDetailModel = (YBLOrderItemModel *)itemModel;
    
    self.confirmCodeLabel.centerY = self.height/2;
    
    if (itemDetailModel.payment_total.doubleValue==0) {
        self.payMoneyLabel.text = [NSString stringWithFormat:@"应付款:¥%.2f",itemDetailModel.total.doubleValue];
    } else {
        self.payMoneyLabel.text = [NSString stringWithFormat:@"已付款:¥%.2f",itemDetailModel.payment_total.doubleValue];
    }
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",itemDetailModel.created_at];
    
    if (itemDetailModel.confirm_code.integerValue != 0) {
        self.confirmCodeLabel.hidden = NO;
        self.confirmCodeLabel.text = [NSString stringWithFormat:@"提货码:%@",itemDetailModel.confirm_code];
    } else {
        self.confirmCodeLabel.hidden = YES;
    }
    if (itemDetailModel.full_completed_at) {
        self.finishTimeLabel.text = [NSString stringWithFormat:@"完成时间:%@",itemDetailModel.full_completed_at];;
        self.finishTimeLabel.hidden = NO;
    } else {
        self.finishTimeLabel.hidden = YES;
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLOrderItemModel *model = (YBLOrderItemModel *)itemModel;
    if (model.full_completed_at) {
        return 80;
    } else {
        return 60;
    }
}

@end
