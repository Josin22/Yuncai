//
//  YBLFollowGoodCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFollowGoodCell.h"
#import "YBLGoodModel.h"

@implementation YBLFollowGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    [self.addToStoreButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.addToStoreButton.size = CGSizeMake(50, 50);
    self.addToStoreButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.addToStoreButton setTitle:nil forState:UIControlStateNormal];
    [self.addToStoreButton setImage:[UIImage imageNamed:@"bh_cart"] forState:UIControlStateNormal];
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    self.saleCountName.attributedText = [NSString price:[NSString stringWithFormat:@"%.2f",goodModel.price.doubleValue] color:YBLThemeColor font:20];
    if (![goodModel.state_value isEqualToString:@"online"]) {
        self.noStockImageView.hidden = NO;
        self.addToStoreButton.hidden = YES;
    } else {
        self.noStockImageView.hidden = YES;
        self.addToStoreButton.hidden = NO;
    }
    self.addToStoreButton.right = self.width;
    self.addToStoreButton.bottom = self.height-space;
}

@end
