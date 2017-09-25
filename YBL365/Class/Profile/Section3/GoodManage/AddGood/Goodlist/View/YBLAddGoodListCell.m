//
//  YBLAddGoodListCell.m
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodListCell.h"
#import "YBLGoodModel.h"
#import "YBLOrderCommentsItemModel.h"

@implementation YBLAddGoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creacreatessUIteUI];
    }
    return self;
}

- (void)creacreatessUIteUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat hei = [YBLAddGoodListCell getItemCellHeightWithModel:nil];
    CGFloat imageWi = hei-5;
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWi, imageWi)];
    goodImageView.centerY = hei/2;
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self.contentView addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    UIImageView *noStockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_car_no_stock"]];
    noStockImageView.frame = CGRectMake(0, 0, goodImageView.width/2, goodImageView.height/2);
    noStockImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    noStockImageView.center = goodImageView.center;
    [self.goodImageView addSubview:noStockImageView];
    self.noStockImageView = noStockImageView;
    self.noStockImageView.hidden = YES;
    
    CGFloat buttonWi = 80;
    CGFloat buttonHi = 30;
    
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.right+space, space, YBLWindowWidth-self.goodImageView.right-space*2, 40)];
    goodNameLabel.font = YBLFont(16);
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.textColor = BlackTextColor;
    [self.contentView addSubview:goodNameLabel];
    self.goodNameLabel = goodNameLabel;
    
    UILabel *saleCountName = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLabel.left, 0, goodNameLabel.width-buttonWi, 15)];
    saleCountName.textColor = YBLTextColor;
    saleCountName.font = YBLFont(14);
    saleCountName.bottom = hei-space;
    [self.contentView addSubview:saleCountName];
    self.saleCountName = saleCountName;
    
    UIButton *addToStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addToStoreButton.frame = CGRectMake(YBLWindowWidth-space-buttonWi, 0, buttonWi, buttonHi);
    addToStoreButton.bottom = saleCountName.bottom;
    [addToStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addToStoreButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [addToStoreButton setTitle:@"添加到店铺" forState:UIControlStateNormal];
    addToStoreButton.titleLabel.font = YBLFont(13);
    addToStoreButton.layer.cornerRadius = 3;
    addToStoreButton.layer.masksToBounds = YES;
    [self.contentView addSubview:addToStoreButton];
    self.addToStoreButton = addToStoreButton;
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(goodNameLabel.left, hei-0.5, YBLWindowWidth-goodImageView.right, 0.5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    NSString *title = nil;
    NSString *thubm = nil;
    if ([itemModel isKindOfClass:[YBLGoodModel class]]) {
        YBLGoodModel *model = (YBLGoodModel *)itemModel;
        title = model.title;
        thubm = model.thumb;
        int randomCount = [YBLMethodTools getRandomNumber:1 to:500];
        self.saleCountName.text = [NSString stringWithFormat:@"%d次使用",randomCount];
    } else if ([itemModel isKindOfClass:[YBLOrderCommentsItemModel class]]){
        YBLOrderCommentsItemModel *model = (YBLOrderCommentsItemModel *)itemModel;
        title = model.product_title;
        thubm = model.product_thumb;
    }
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:thubm] placeholderImage:smallImagePlaceholder];
    self.goodNameLabel.text = title;
    CGSize titleSize = [title heightWithFont:YBLFont(16) MaxWidth:self.width-self.goodNameLabel.left-space];
    self.goodNameLabel.height = titleSize.height;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 130;
}

@end
