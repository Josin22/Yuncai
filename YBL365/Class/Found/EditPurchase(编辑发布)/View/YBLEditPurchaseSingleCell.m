
//
//  YBLEditPurchaseSingleCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseSingleCell.h"

@implementation YBLEditPurchaseSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [YBLEditPurchaseSingleCell getEditPurchaseSingleCellHeight];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-space*3-30, height-0.5)];
    label.numberOfLines = 0;
    label.font = YBLFont(15);
    label.textColor = BlackTextColor;
    [self addSubview:label];
    self.titleLabel = label;
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, 0, 30, 30);
    selectButton.center = CGPointMake(YBLWindowWidth-space-30/2, height/2);
    [selectButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self addSubview:selectButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

+ (CGFloat)getEditPurchaseSingleCellHeight{
    return 50;
}

@end

