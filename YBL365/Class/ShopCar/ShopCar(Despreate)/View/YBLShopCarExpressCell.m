//
//  YBLShopCarExpressCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarExpressCell.h"

@implementation YBLShopCarExpressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.expressLabel = [[UILabel alloc] init];
        self.expressLabel.font = YBLFont(13);
        self.expressLabel.numberOfLines = 2;
        self.expressLabel.textColor = YBLColor(150, 150, 150, 1.0);
        [self addSubview:self.expressLabel];
        [self.expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.equalTo(@5);
            make.bottom.equalTo(@-5);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINE_BASE_COLOR;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

@end
