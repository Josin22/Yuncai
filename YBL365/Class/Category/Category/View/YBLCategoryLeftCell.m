//
//  YBLCategoryLeftCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryLeftCell.h"


@implementation YBLCategoryLeftCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(@0);
    }];
    self.nameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.nameLabel.font = YBLFont(13);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.rightLineView = [[UIView alloc] init];
    [self.contentView addSubview:self.rightLineView];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(@0.5);
    }];
    self.rightLineView.backgroundColor = YBLColor(220, 220, 220, 1.0);
    
    UIView *bottomLineView = [[UIView alloc] init];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    bottomLineView.backgroundColor = YBLColor(220, 220, 220, 1.0);
    
    
}

@end
