//
//  YBLFourLevelAddressItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFourLevelAddressItemCell.h"
#import "YBLAreaItemButton.h"
#import "YBLAddressAreaModel.h"

@interface YBLFourLevelAddressItemCell ()

@end

@implementation YBLFourLevelAddressItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
//    self.backgroundColor = randomColor;
    self.backgroundColor = [UIColor whiteColor];
    
    self.itemButton = [[YBLAreaItemButton alloc] initWithFrame:CGRectMake(space, 0, self.width-space, self.height) areaItemButtonType:AreaItemButtonTypeSpacial];
    self.itemButton.normalColor = BlackTextColor;
    self.itemButton.selectColor = YBLThemeColor;
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.textLabel.font = YBLFont(13);
    [self.itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.itemButton setBackgroundColor:YBLColor(240, 240, 240, 1) forState:UIControlStateSelected];
    [self.contentView addSubview:self.itemButton];
    
}

- (void)updateModel:(YBLAddressAreaModel *)model{
    
    self.itemButton.frame = CGRectMake(space, 0, self.width-space, self.height);
    [self.itemButton resetFrame];
    self.itemButton.textLabel.text = model.text;
    self.itemButton.arrowButton.selected = model.isArrowSelect;
}

@end
