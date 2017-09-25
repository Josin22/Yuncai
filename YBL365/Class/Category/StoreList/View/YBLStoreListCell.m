//
//  YBLStoreListCell.m
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreListCell.h"
#import "shop.h"
#import "YBLGoodModel.h"

static NSInteger const tag_button =  5;
static NSInteger const tag_image_view =  4564165;
static NSInteger const tag_price_label =  9064165;

@interface YBLStoreListCell()

@property (nonatomic, weak  ) shop *model;

@end

@implementation YBLStoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createssUI];
    }
    return self;
}

- (void)createssUI{
    
    CGFloat count = 3;
    CGFloat buttonHi = 20;
    CGFloat imageWi = (YBLWindowWidth-4*space)/3;
    
    self.bgStoreButton.hidden = NO;
    
    self.inStoreButton.frame = CGRectMake(0, self.storeTitleLabel.top, 40, 18);
    self.inStoreButton.right = self.bgStoreButton.width-space;
    self.inStoreButton.layer.cornerRadius = 3;
    self.inStoreButton.layer.masksToBounds = YES;
    [self.inStoreButton setImage:nil forState:UIControlStateNormal];
    [self.inStoreButton setTitle:@"进店" forState:UIControlStateNormal];
    [self.inStoreButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    self.inStoreButton.titleLabel.font = YBLFont(12);
    self.inStoreButton.layer.borderWidth = .6;
    self.inStoreButton.layer.borderColor = YBLThemeColor.CGColor;
    
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(space+i*(imageWi+space), self.bgStoreButton.bottom+space, imageWi, imageWi)];
        imageView.tag = tag_image_view+i;
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        imageView.hidden = YES;
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.width/2, imageView.height-buttonHi, imageView.width/2, buttonHi)];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        priceLabel.tag = tag_price_label+i;
        priceLabel.font = YBLFont(12);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:priceLabel];
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = [imageView bounds];
        imageButton.tag = tag_button+i;
        [imageView addSubview:imageButton];
        [imageButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)updateItemCellModel:(id)itemModel{

    [super updateItemCellModel:itemModel];
    
    shop *model = (shop *)itemModel;
    self.model = model;
    NSInteger goodCount = model.shop_products.count;
    if (goodCount>3) {
        goodCount = 3;
    }
    for (int i = 0;i < 3;i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:tag_image_view+i];
        imageView.hidden = YES;
        if (i<goodCount) {
            imageView.hidden = NO;
            YBLGoodModel *goodModel = model.shop_products[i];
            UILabel *priceLabel = (UILabel *)[self viewWithTag:tag_price_label+i];
            [imageView js_alpha_setImageWithURL:[NSURL URLWithString:goodModel.avatar_url] placeholderImage:smallImagePlaceholder];
            NSString *priceValue = [NSString stringWithFormat:@"¥%.2f",goodModel.price.doubleValue];
            priceLabel.text = priceValue;
            CGSize priceSize = [priceValue heightWithFont:YBLFont(12) MaxWidth:200];
            priceLabel.width = priceSize.width+4;
            priceLabel.right = imageView.width;
 
        }
    }
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 70+YBLWindowWidth/3+space;
}

- (void)imageClick:(UIButton *)btn {

    NSInteger index = btn.tag-tag_button;
    YBLGoodModel *clickGoodModel =  self.model.shop_products[index];
    BLOCK_EXEC(self.storeListGoodClickBlock,clickGoodModel);
}

@end
