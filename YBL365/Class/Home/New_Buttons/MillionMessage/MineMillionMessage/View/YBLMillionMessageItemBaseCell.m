//
//  YBLMillionMessageItemBaseCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageItemBaseCell.h"

@implementation YBLMillionMessageItemBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUIsss];
    }
    return self;
}

- (void)createUIsss{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat hi = [YBLMillionMessageItemBaseCell getItemCellHeightWithModel:nil];
    
    UIView *contentBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, hi)];
    [self.contentView addSubview:contentBGView];
    self.contentBGView = contentBGView;

    YBLCustomersLabel *nameLabel = [[YBLCustomersLabel alloc] initWithFrame:CGRectMake(space, space, 60, 60)];
    [self.contentBGView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_icon"]];
//    iconImageView.frame = CGRectMake(space, space, 60, 60);
//    [self.contentBGView addSubview:iconImageView];
    
    CGFloat leftSpace = 0;
    
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right+space, nameLabel.top, YBLWindowWidth-(nameLabel.right+space*2+leftSpace), 20)];
    shopNameLabel.font = YBLFont(14);
    shopNameLabel.textColor = BlackTextColor;
    [self.contentBGView addSubview:shopNameLabel];
    self.shopNameLabel = shopNameLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(shopNameLabel.left, shopNameLabel.bottom, shopNameLabel.width,shopNameLabel.height)];
    phoneLabel.font = YBLFont(12);
    [self.contentBGView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UILabel *localLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabel.left, phoneLabel.bottom, phoneLabel.width,phoneLabel.height)];
    localLabel.font = YBLFont(12);
    localLabel.textColor = YBLTextColor;
    [self.contentBGView addSubview:localLabel];
    self.localLabel = localLabel;
    
    [self.contentBGView addSubview:[YBLMethodTools addLineView:CGRectMake(nameLabel.left, nameLabel.bottom+space-.5, YBLWindowWidth-nameLabel.left, .5)]];
    
}

- (void)updateItemCellModel:(id)itemModel{

    YBLMineMillionMessageItemModel *model = (YBLMineMillionMessageItemModel *)itemModel;
    self.nameLabel.backgroundColor = model.name_bg_color;
    self.nameLabel.text = model.first_name;
    self.shopNameLabel.text = model.shopname;
    self.phoneLabel.text = model.mobile;
    self.localLabel.text = model.area_name;
    self.fousButton.selected = NO;
    self.fousButton.enabled = !model.binded.boolValue;
    self.selectButton.selected = model.is_select.boolValue;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 80;
}

@end
