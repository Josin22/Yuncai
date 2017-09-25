//
//  YBLMineMillionMessageItemCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMineMillionMessageItemCell.h"

@interface YBLMineMillionMessageItemCell ()

@end

@implementation YBLMineMillionMessageItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [self.nameLabel addGestureRecognizer:self.iconTap];
    self.nameLabel.userInteractionEnabled = YES;

}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    
}

@end
