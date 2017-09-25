//
//  YBLExpressGoodListCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLExpressGoodListAndCompanyCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"
#import "YYWebImage.h"

@interface YBLExpressGoodListAndCompanyCell ()
/*
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *infoLabel;
*/
@end

@implementation YBLExpressGoodListAndCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createKKUI];
    }
    return self;
}

- (void)createKKUI{
    
    CGFloat cell_height = [YBLExpressGoodListAndCompanyCell getItemCellHeightWithModel:nil];
    
    /*
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, cell_height-2*space, cell_height-2*space)];
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = .5;
    self.iconImageView.layer.borderColor = YBLLineColor.CGColor;
    [self.contentView addSubview:self.iconImageView];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+space, self.iconImageView.top, YBLWindowWidth-self.iconImageView.right-space*3-circleButtonWi, self.iconImageView.height/2)];
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = YBLFont(15);
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, self.nameLabel.height)];
    self.infoLabel.textColor = YBLThemeColor;
    self.infoLabel.font = YBLFont(13);
    [self.contentView addSubview:self.infoLabel];
    */
    CGFloat circleButtonWi  = 30;
    
    self.circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.circleButton.frame = CGRectMake(0, 0, circleButtonWi, circleButtonWi);
    self.circleButton.right = YBLWindowWidth-space/2;
    self.circleButton.centerY = cell_height/2;
    [self.circleButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [self.circleButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.circleButton];

    self.addToStoreButton.hidden = YES;
    self.saleCountName.textColor = YBLThemeColor;
    self.saleCountName.font = YBLFont(14);
    self.goodNameLabel.width -= self.circleButton.width;
    self.saleCountName.width = self.goodNameLabel.width;
}

- (void)updateItemCellModel:(id)itemModel{

    BOOL isSelect = NO;
    NSString *imageURL = nil;
    NSString *infoString = nil;
    NSString *textString = nil;
    NSString *imageplace = smallImagePlaceholder;
    if ([itemModel isKindOfClass:[YBLExpressCompanyItemModel class]]) {
        YBLExpressCompanyItemModel *new_model = (YBLExpressCompanyItemModel *)itemModel;
        isSelect = new_model.is_select;
        imageURL = new_model.avatar;
        textString = new_model.title;
        infoString = nil;
    } else if ([itemModel isKindOfClass:[YBLGoodModel class]]) {
        YBLGoodModel *newModel = (YBLGoodModel *)itemModel;
        isSelect = newModel.is_select;
        imageURL = newModel.avatar_url;
        textString = newModel.title;
        infoString = [NSString stringWithFormat:@"¥ %.2f",newModel.price.doubleValue];
    }
    self.circleButton.selected = isSelect;
    if ([imageURL rangeOfString:@"missing.png"].location!=NSNotFound) {
        imageplace = @"myself_express";
    }
//    [self.goodImageView yy_setImageWithURL:[NSURL URLWithString:imageURL] placeholder:[UIImage imageNamed:imageplace]];
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:imageplace];
    self.goodNameLabel.text = textString;
    CGSize titleSize = [textString heightWithFont:YBLFont(16) MaxWidth:self.goodNameLabel.width];
    CGFloat lessHeight = self.height-self.saleCountName.height-space*2;
    self.goodNameLabel.height = titleSize.height>lessHeight?lessHeight:titleSize.height;
    if (infoString) {
        self.saleCountName.text = infoString;
    }
}

@end
