//
//  YBLRewardGoodCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRewardGoodCell.h"
#import "YBLProductShareModel.h"

@implementation YBLRewardGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createRewardUI];
    }
    return self;
}

- (void)createRewardUI{
    
    self.goodNameLabel.numberOfLines = 1;
    
    [self.addToStoreButton setTitle:@"立即分享" forState:UIControlStateNormal];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodNameLabel.left, self.goodNameLabel.bottom, self.goodNameLabel.width, 30)];
    priceLabel.font = YBLFont(14);
    priceLabel.textColor = YBLThemeColor;
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    self.saleCountName.font = YBLFont(12);
    self.saleCountName.width = self.goodNameLabel.width;
    
    self.total_per_label = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.left, 0, self.goodNameLabel.width, 20)];
    self.total_per_label.textColor = YBLTextColor;
    self.total_per_label.font = YBLFont(12);
    self.total_per_label.bottom = self.saleCountName.top;
    [self.contentView addSubview:self.total_per_label];
}

- (void)updateItemCellModel:(id)itemModel{
    YBLProductShareModel *model = (YBLProductShareModel *)itemModel;
    self.addToStoreButton.centerY = self.height/2;
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.product.avatar_url] placeholderImage:smallImagePlaceholder];
    self.goodNameLabel.text = model.product.title;
    self.saleCountName.attributedText = model.att_total_per;
    self.total_per_label.attributedText = model.att_han_shared_visit_count;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.product.price.doubleValue];
}

@end
