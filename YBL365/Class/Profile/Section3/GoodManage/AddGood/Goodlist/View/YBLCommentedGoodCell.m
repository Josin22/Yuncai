
//
//  YBLCommentedGoodCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCommentedGoodCell.h"

@implementation YBLCommentedGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    [self.addToStoreButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToStoreButton setImage:[UIImage imageNamed:@"order_comment_look_action"] forState:UIControlStateNormal];
    [self.addToStoreButton setTitle:@"查看评价" forState:UIControlStateNormal];
    [self.addToStoreButton setTitleColor:YBLColor(110, 110, 110, 1) forState:UIControlStateNormal];
    self.addToStoreButton.layer.borderColor = YBLColor(110, 110, 110, 110).CGColor;
    self.addToStoreButton.layer.borderWidth = .6;
    self.addToStoreButton.titleLabel.font = YBLFont(12);
    self.addToStoreButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.addToStoreButton.imageRect = CGRectMake(5, 7.5, 15, 15);
    self.addToStoreButton.titleRect = CGRectMake(25, 0, self.addToStoreButton.width-25, self.addToStoreButton.height);

}

@end
