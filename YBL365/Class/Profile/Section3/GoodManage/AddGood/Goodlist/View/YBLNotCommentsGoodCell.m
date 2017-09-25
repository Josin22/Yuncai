
//
//  YBLNotCommentsGoodCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLNotCommentsGoodCell.h"

@implementation YBLNotCommentsGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    [self.addToStoreButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToStoreButton setImage:[UIImage imageNamed:@"order_comment_action"] forState:UIControlStateNormal];
    [self.addToStoreButton setTitle:@"晒单评价" forState:UIControlStateNormal];
    [self.addToStoreButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    self.addToStoreButton.layer.borderColor = YBLThemeColor.CGColor;
    self.addToStoreButton.layer.borderWidth = .6;
    self.addToStoreButton.titleLabel.font = YBLFont(12);
    self.addToStoreButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.addToStoreButton.imageRect = CGRectMake(5, 7.5, 15, 15);
    self.addToStoreButton.titleRect = CGRectMake(25, 0, self.addToStoreButton.width-25, self.addToStoreButton.height);
    self.saleCountName.text = @"评价+晒图就送云币哟";
    self.saleCountName.font = YBLFont(10);
    self.saleCountName.top = self.goodNameLabel.bottom+space;
    self.saleCountName.width = self.goodNameLabel.width;
    
}

@end
