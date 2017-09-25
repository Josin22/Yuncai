//
//  YBLFoundPurchaseCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundPurchaseCell.h"

@interface YBLFoundPurchaseCell ()



@end

@implementation YBLFoundPurchaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [YBLFoundPurchaseCell getPurchaseCellHeight];
    
    UIImageView *goodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space, height-space*2, height-space*2)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    goodImageView.layer.cornerRadius = 3;
    goodImageView.layer.masksToBounds = YES;
    goodImageView.layer.borderColor = YBLLineColor.CGColor;
    goodImageView.layer.borderWidth = .8;
    [self addSubview:goodImageView];
    
    //40 100 100 xx
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, 40)];
    nameLabel.text = @"洋河蓝色经典之天之蓝52度 新年 特供 480ml";
    nameLabel.font = YBLFont(15);
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = BlackTextColor;
    [self addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 20)];
    priceLabel.textColor = YBLThemeColor;
    priceLabel.text = @"当前价:¥12.33-12.10";
    priceLabel.font = YBLFont(13);
    [self addSubview:priceLabel];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, priceLabel.width, priceLabel.height)];
    countLabel.textColor = BlackTextColor;
    countLabel.text = @"采购量:100箱";
    countLabel.font = YBLFont(13);
    [self addSubview:countLabel];
    
    UIButton *wantPurchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wantPurchaseButton setBackgroundColor:YBLThemeColor];
    wantPurchaseButton.layer.cornerRadius = 3;
    wantPurchaseButton.layer.masksToBounds = YES;
    [wantPurchaseButton setTitle:@"我要采购" forState:UIControlStateNormal];
    [wantPurchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wantPurchaseButton.titleLabel.font = YBLFont(13);
    wantPurchaseButton.frame = CGRectMake(YBLWindowWidth-space-80, height-space-30, 80, 30);
    [self addSubview:wantPurchaseButton];
    self.wantPurchaseButton = wantPurchaseButton;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(goodImageView.left, height-0.5, YBLWindowWidth-goodImageView.left, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

+ (CGFloat)getPurchaseCellHeight{
    
    return 100;
}

@end
