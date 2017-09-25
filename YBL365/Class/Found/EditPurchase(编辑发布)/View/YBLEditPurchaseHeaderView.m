//
//  YBLEditPurchaseHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseHeaderView.h"

@implementation YBLEditPurchaseHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createIU];
    }
    return self;
}

- (void)createIU{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = [YBLEditPurchaseHeaderView getEditPurchaseHeadeHeight];
    
    UIImageView *goodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space, height-space*2, height-space*2)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    goodImageView.layer.cornerRadius = 3;
    goodImageView.layer.masksToBounds = YES;
    goodImageView.layer.borderColor = YBLLineColor.CGColor;
    goodImageView.layer.borderWidth = .8;
    [self.contentView addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
//    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, goodImageView.width, 20)];
//    signLabel.backgroundColor = YBLThemeColor;
//    signLabel.textColor = [UIColor whiteColor];
//    signLabel.text = @"正在进行";
//    signLabel.textAlignment = NSTextAlignmentCenter;
//    signLabel.font = YBLFont(13);
//    [goodImageView addSubview:signLabel];
    
    //40 100 100 xx
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, 40)];
    nameLabel.text = @"洋河蓝色经典之天之蓝52度 新年 特供 480ml";
    nameLabel.font = YBLFont(15);
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = BlackTextColor;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
    
}

+ (CGFloat)getEditPurchaseHeadeHeight{
    
    return 80;
}

@end
