//
//  YBLEditPicItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPicItemCell.h"
#import "YBLEditPicItemModel.h"
#import "YYWebImage.h"

@implementation YBLEditPicItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteUI];
    }
    return self;
}

- (void)creteUI {

    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.width, self.width)];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.clipsToBounds = YES;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.layer.cornerRadius  = 3;
    iconImageView.layer.borderWidth = .8;
    iconImageView.layer.borderColor = YBLLineColor.CGColor;
    iconImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, 30, 30);
    self.selectButton.right = iconImageView.width;
    [self.selectButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self.iconImageView addSubview:self.selectButton];
    self.selectButton.hidden = YES;
    
    /*
    self.deleteIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"area_delete"]];
    self.deleteIconImageView.frame = CGRectMake(0, 3, 20, 20);
    self.deleteIconImageView.right = iconImageView.width-3;
    [self.iconImageView addSubview:self.deleteIconImageView];
    self.deleteIconImageView.hidden = YES;
    */
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.bottom, self.width, 20)];
    infoLabel.textColor = BlackTextColor;
    infoLabel.font = YBLFont(13);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
}

- (void)updateModel:(YBLEditPicItemModel *)itemModel row:(NSInteger)row{

    if ([itemModel.good_Image_url isKindOfClass:[NSString class]]) {
//        [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:itemModel.good_Image_url] placeholder:[UIImage imageNamed:smallImagePlaceholder]];
        [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:itemModel.good_Image_url] placeholderImage:smallImagePlaceholder];
    } else if ([itemModel.good_Image_url isKindOfClass:[UIImage class]]) {
        self.iconImageView.image = itemModel.good_Image_url;
    } else {
        self.iconImageView.image = nil;
    }
    if (itemModel.good_info) {
        self.infoLabel.text = [NSString stringWithFormat:@"%@ %ld",itemModel.good_info,row+1];
        self.infoLabel.hidden = YES;
    } else {
        self.infoLabel.hidden = NO;
    }
}

- (UIView *)snapshotView {

    return [UIView getSnapshotViewWith:self];
}

@end
