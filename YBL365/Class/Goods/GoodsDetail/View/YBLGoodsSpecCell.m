//
//  YBLGoodsSpecCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsSpecCell.h"

@interface YBLGoodsSpecCell ()


@end

@implementation YBLGoodsSpecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSpecUI];
    }
    return self;
}

- (void)createSpecUI{
    
    NSString *labelText = @"已选";

    [self handleTextLabel:labelText];

    _specLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ttLabel.right+5, 0, YBLWindowWidth-20-10-30, 30)];
    _specLabel.font = YBLFont(14);
    _specLabel.centerY = self.ttLabel.centerY;
    _specLabel.textColor = BlackTextColor;
    [self addSubview:_specLabel];
    
}


+ (CGFloat)getGoodsSpecCellHeight{
    
    return [self getItemCellHeightWithModel:nil];
}

@end
