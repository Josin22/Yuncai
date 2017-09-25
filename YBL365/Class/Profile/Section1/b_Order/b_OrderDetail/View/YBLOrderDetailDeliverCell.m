//
//  YBLOrderDetailDeliverCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailDeliverCell.h"

@implementation YBLOrderDetailDeliverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLOrderDetailDeliverCell getHi];
    
    CGFloat buttinWi = YBLWindowWidth-space;
    self.undefineButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.undefineButton.frame = CGRectMake(space, 0, buttinWi, hi);
    [self.undefineButton setTitle:loadString forState:UIControlStateNormal];
    self.undefineButton.titleLabel.font = YBLFont(14);
    self.undefineButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.undefineButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.undefineButton setTitle:@"查看物流" forState:UIControlStateNormal];
    [self.undefineButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    self.undefineButton.titleRect = CGRectMake(0, 0, buttinWi-space-10, hi);
    self.undefineButton.imageRect = CGRectMake(buttinWi-space-7, (hi-15)/2, 7, 15);
    [self.contentView addSubview:self.undefineButton];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHi{
    
    return 40;
}

@end
