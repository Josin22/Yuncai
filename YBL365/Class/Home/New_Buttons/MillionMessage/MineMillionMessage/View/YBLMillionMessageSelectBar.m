//
//  YBLMillionMessageSelectBar.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageSelectBar.h"

@implementation YBLMillionMessageSelectBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.backgroundColor = YBLColor(242, 242, 242, 1);
    
    self.selectAllButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.frame = CGRectMake(0, 0, 100, self.height);
    [self.selectAllButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [self.selectAllButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllButton setTitleColor:YBLColor(120, 120, 120, 1) forState:UIControlStateNormal];
    self.selectAllButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.selectAllButton.imageRect = CGRectMake(space, (self.height-20)/2, 20, 20);
    self.selectAllButton.titleRect = CGRectMake(40, 0, 55, self.height);
    self.selectAllButton.titleLabel.font = YBLFont(14);
    [self addSubview:self.selectAllButton];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.frame = CGRectMake(0, 0, 90, self.height);
    self.sureButton.right = self.width;
    [self.sureButton setTitle:@"确定(0/100)" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = YBLFont(12);
    [self.sureButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self addSubview:self.sureButton];
}

- (void)setSelectCount:(NSInteger)selectCount{
    _selectCount = selectCount;
    [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%ld/100)",_selectCount] forState:UIControlStateNormal];
    if (_selectCount==100) {
        self.selectAllButton.selected = YES;
    }
}

@end
