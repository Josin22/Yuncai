//
//  YBLStoreListTableViewCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreListTableViewCell.h"

@interface YBLStoreListTableViewCell ()
@property (nonatomic, strong) UIImageView * storeImage;
@property (nonatomic, strong) UILabel * storeNameLab;
@property (nonatomic, strong) UILabel * attentionLab;
@property (nonatomic, strong) UILabel * commentLab;

@end

@implementation YBLStoreListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createrUI];
    }
    return self;
}

- (void)createrUI {
    _storeImage = [[UIImageView alloc] init];
    [self addSubview:_storeImage];
    [_storeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
        make.top.equalTo(@((self.height-50)/2));
    }];
    _storeImage.image = [UIImage imageNamed:smallImagePlaceholder];
    
    _storeNameLab = [[UILabel alloc] init];
    _storeNameLab.font = YBLFont(15);
    _storeNameLab.textColor = YBLColor(40, 40, 40, 1.0);
    [self addSubview:_storeNameLab];
    [_storeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storeImage.mas_top);
        make.right.equalTo(@-40);
        make.height.equalTo(@20);
        make.left.equalTo(_storeImage.mas_right).with.offset(10);
    }];
    
    _attentionLab = [[UILabel alloc] init];
    _attentionLab.font = YBLFont(12);
    _attentionLab.textColor = YBLColor(40, 40, 40, 1.0);
    _attentionLab.numberOfLines = 2;
    [self addSubview:_attentionLab];
    [_attentionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_storeImage.mas_right).with.offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.top.equalTo(_storeNameLab.mas_bottom).with.offset(0);
    }];
    _attentionLab.text = @"1.5万人关注";
    
    
    _commentLab = [[UILabel alloc] init];
    _commentLab.font = YBLFont(12);
    _commentLab.textColor = YBLColor(40, 40, 40, 1.0);
    _commentLab.numberOfLines = 2;
    [self addSubview:_commentLab];
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentLab.mas_right).with.offset(10);
        make.right.equalTo(@-8);
        make.height.equalTo(@20);
        make.top.equalTo(_storeNameLab.mas_bottom).with.offset(0);
    }];
    _commentLab.text = @"综合评分5.7";
    
    UIImageView * rightArrowImage = [[UIImageView alloc]init];
    [rightArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-8);
        make.height.equalTo(@25);
        make.width.equalTo(@20);
        make.top.equalTo(@((self.height-25)/2));
    }];
    
    
    UIView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 0.8)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
