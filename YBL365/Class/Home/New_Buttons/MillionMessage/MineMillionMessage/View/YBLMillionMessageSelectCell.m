//
//  YBLMillionMessageSelectCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageSelectCell.h"

@implementation YBLMillionMessageSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.contentBGView.left = 40;
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, 40, self.contentBGView.height);
    [self.selectButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    
}

@end
