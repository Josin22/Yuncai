//
//  YBLOrderDetailTotalMoenyCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailTotalMoenyCell.h"

@interface YBLOrderDetailTotalMoenyCell ()



@end

@implementation YBLOrderDetailTotalMoenyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/3-space, 30)];
    label1.text = @"商品总额";
    label1.textColor = BlackTextColor;
    label1.font = YBLFont(14);
    [self.contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(space, label1.bottom, label1.width, 25)];
    label2.text = @"+运费";
    label2.textColor = YBLTextColor;
    label2.font = YBLFont(12);
    [self.contentView addSubview:label2];
    
    self.totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.right, label1.top, YBLWindowWidth - label1.right-space, label1.height)];
    self.totalMoneyLabel.text = @"¥00.00";
    self.totalMoneyLabel.textColor = YBLThemeColor;
    self.totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.totalMoneyLabel.font = YBLFont(14);
    [self.contentView addSubview:self.totalMoneyLabel];

    self.yunfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.totalMoneyLabel.left, self.totalMoneyLabel.bottom, self.totalMoneyLabel.width, label2.height)];
    self.yunfeiLabel.text = @"¥0.00";
    self.yunfeiLabel.textColor = YBLThemeColor;
    self.yunfeiLabel.textAlignment = NSTextAlignmentRight;
    self.yunfeiLabel.font = YBLFont(12);
    [self.contentView addSubview:self.yunfeiLabel];
}
+ (CGFloat)getHi{
    
    return 65;
}
@end
