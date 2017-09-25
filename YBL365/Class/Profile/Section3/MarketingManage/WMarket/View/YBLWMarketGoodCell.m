//
//  YBLWMarketGoodCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWMarketGoodCell.h"
#import "YBLWMarketGoodModel.h"

@interface YBLWMarketGoodCell ()

@end

@implementation YBLWMarketGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createssUI];
    }
    return self;
}

- (void)createssUI{
 
//    self.addToStoreButton.hidden = YES;
    [self.addToStoreButton setTitle:nil forState:UIControlStateNormal];
    [self.addToStoreButton setImage:[UIImage newImageWithNamed:@"bar_share" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    self.addToStoreButton.frame = CGRectMake(0, 0, 30, 30);
    [self.addToStoreButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
 
    CGFloat height_cell = [YBLWMarketGoodCell getItemCellHeightWithModel:nil];
    CGFloat imageWi = height_cell-5;
    self.goodImageView.size = CGSizeMake(imageWi, imageWi);
//    self.lineView.bottom = height_cell;
    self.goodNameLabel.width -= 2*space+5;
    self.saleCountName.font = YBLFont(14);
    self.saleCountName.width = self.goodNameLabel.width;
    
    self.goodArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.goodArrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    self.goodArrowImageView.right = YBLWindowWidth-5;
    [self.contentView addSubview:self.goodArrowImageView];
    
    self.addToStoreButton.bottom = self.saleCountName.bottom;
    self.addToStoreButton.right = self.goodArrowImageView.right;
}

- (void)updateItemCellModel:(id)itemModel{

    YBLWMarketGoodModel *model = (YBLWMarketGoodModel *)itemModel;
    self.goodArrowImageView.centerY = self.height/2;
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.product_avatar] placeholderImage:smallImagePlaceholder];
    self.goodNameLabel.text = model.product_title;
    CGSize titleSize = [model.product_title heightWithFont:YBLFont(16) MaxWidth:self.goodNameLabel.width];
    self.goodNameLabel.height = titleSize.height;
    self.saleCountName.text = [NSString stringWithFormat:@"%ld 文 %ld图",(long)model.copywritings.count,(long)model.mains.count];
    self.addToStoreButton.bottom = self.height-5;
}

@end
