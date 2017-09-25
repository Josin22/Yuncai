//
//  YBLSpecInfoCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSpecInfoCell.h"

@implementation YBLSpecInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createSpecInfoCellUI];
    }
    return self;
}

- (void)createSpecInfoCellUI{
    
    NSString *labelText = @"规格";
    
    [self handleTextLabel:labelText];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ttLabel.right+5, self.ttLabel.top, (YBLWindowWidth-self.ttLabel.right-5-40-10)/2, 20)];
    titleLabel.font = YBLFont(14);
    titleLabel.centerY = self.ttLabel.centerY;
    titleLabel.textColor = BlackTextColor;;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
}

+ (CGFloat)getHI{
 
    return [self getItemCellHeightWithModel:nil];
}

@end
