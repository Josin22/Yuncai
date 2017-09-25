//
//  YBLOrderDetailTextCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailTextCell.h"

@interface YBLOrderDetailTextCell ()



@end

@implementation YBLOrderDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/3-space, 40)];
    self.titleLabel.text = loadString;
    self.titleLabel.textColor = YBLColor(170, 170, 170, 1);
    self.titleLabel.font = YBLFont(14);
    [self.contentView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 0, YBLWindowWidth-self.titleLabel.right-space, self.titleLabel.height)];
    self.valueLabel.text = loadString;
    self.valueLabel.textColor = BlackTextColor;
    self.valueLabel.font = YBLFont(14);
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.valueLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, 39.5, YBLWindowWidth, 0.5)]];
}



+ (CGFloat)getHi{
    
    return 40;
}
@end
