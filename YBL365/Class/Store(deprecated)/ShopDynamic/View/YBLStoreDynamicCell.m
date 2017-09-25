//
//  YBLStoreDynamicCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDynamicCell.h"

@interface YBLStoreDynamicCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *PVLab;
@property (nonatomic, strong) UILabel * promotionLab;
@property (nonatomic, strong) UILabel * goodsNameLab;

@end

@implementation YBLStoreDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubviews];
    // Initialization code
}

- (void)addSubviews {
    _promotionLab = [[UILabel alloc]initWithFrame:CGRectMake(8, _timeLab.bottom+5, 35, 20)];
    _promotionLab.text = @" 促销";
    _promotionLab.textColor = YBLThemeColor;
    _promotionLab.font = YBLFont(13);
    [self.contentView addSubview:_promotionLab];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(36, 0, 1, 20)];
    lineView.backgroundColor = YBLLineColor;
    [_promotionLab addSubview:lineView];
    
    _goodsNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_promotionLab.right+8, _timeLab.bottom+5, YBLWindowWidth - _promotionLab.right-16, 20)];
    _goodsNameLab.text = @"有优惠哦～";
    _goodsNameLab.textColor = YBLTextColor;
    _goodsNameLab.font = YBLFont(13);
    [self.contentView addSubview:_goodsNameLab];
    
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(YBLWindowWidth-116, self.height-48, 50, 40);
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 0, 0)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    UIImage *commentImage       = [UIImage newImageWithNamed:@"" size:(CGSize){18,18}];
    [commentBtn setImage:commentImage forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.titleLabel.font = YBLFont(12);
    [commentBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:commentBtn];

    

    UIButton * zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.frame = CGRectMake(YBLWindowWidth-58, self.height-48, 50, 40);
    [zanBtn setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 0, 0)];
    [zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    UIImage *zanImage       = [UIImage newImageWithNamed:@"" size:(CGSize){18,18}];
    [zanBtn setImage:zanImage forState:UIControlStateNormal];
    UIImage *zanSelectImage       = [UIImage newImageWithNamed:@"" size:(CGSize){18,18}];
    [zanBtn setImage:zanSelectImage forState:UIControlStateSelected];
    [zanBtn setTitle:@"100" forState:UIControlStateNormal];
    [zanBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [zanBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    zanBtn.titleLabel.font = YBLFont(12);
    [self.contentView addSubview:zanBtn];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
