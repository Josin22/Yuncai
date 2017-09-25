//
//  YBLOrderDetailNoStatusCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailNoStatusCell.h"

@interface YBLOrderDetailNoStatusCell ()



@end

@implementation YBLOrderDetailNoStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLOrderDetailNoStatusCell getHi];
    
    self.orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2-space, 40)];
    self.orderNoLabel.text = loadString;
    self.orderNoLabel.textColor = BlackTextColor;
    self.orderNoLabel.font = YBLFont(14);
    [self.contentView addSubview:self.orderNoLabel];
    
    self.orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.orderNoLabel.right, 0, YBLWindowWidth-space-self.orderNoLabel.right, self.orderNoLabel.height)];
    self.orderStatusLabel.text = loadString;
    self.orderStatusLabel.textAlignment = NSTextAlignmentRight;
    self.orderStatusLabel.textColor = YBLThemeColor;
    self.orderStatusLabel.font = YBLFont(14);
    [self.contentView addSubview:self.orderStatusLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHi{
    
    return 40;
}

@end
