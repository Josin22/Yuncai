//
//  YBLStoreRedbagCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreRedbagCell.h"

@interface YBLStoreRedbagCell ()

@property (nonatomic, strong) YBLButton *moneyButton;

@property (nonatomic, strong) UIButton *foucsButton;

@end

@implementation YBLStoreRedbagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.bgStoreButton.hidden = NO;
    
    self.moneyButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.moneyButton.frame = CGRectMake(0, 0, 200, 20);
    [self.moneyButton setImageRect:CGRectMake(space, 0, 20, 20)];
    self.moneyButton.titleRect = CGRectMake(35, 0, 170, 20);
    [self.moneyButton setImage:[UIImage imageNamed:@"yun_money"] forState:UIControlStateNormal];
    [self.moneyButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    self.moneyButton.titleLabel.font = YBLFont(14);
    [self.contentView addSubview:self.moneyButton];
    
    self.foucsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.foucsButton.frame = CGRectMake(0, self.bgStoreButton.bottom, 40, 40);
    self.foucsButton.right = YBLWindowWidth-space;
    [self.foucsButton setImage:[UIImage imageNamed:@"goods_foucs_normal"] forState:UIControlStateNormal];
    [self.foucsButton setImage:[UIImage imageNamed:@"goods_foucs_select"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.foucsButton];
    
    self.moneyButton.centerY = self.foucsButton.centerY;
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLUserInfoModel *model = (YBLUserInfoModel *)itemModel;
    
    [self.moneyButton setTitle:[NSString stringWithFormat:@"%@",model.follow_shop_money] forState:UIControlStateNormal];
    
    self.foucsButton.selected = model.follow_state.boolValue;
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    CGFloat superHi = [super getItemCellHeightWithModel:itemModel];
    return superHi+40;
}

@end
