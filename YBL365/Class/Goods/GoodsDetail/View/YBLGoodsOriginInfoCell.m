//
//  YBLGoodsOriginInfoCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsOriginInfoCell.h"

@interface YBLGoodsOriginInfoCell ()



@end

@implementation YBLGoodsOriginInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createOriginUI];
    }
    return self;
}

- (void)createOriginUI{
    
    CGFloat wi = (YBLWindowWidth)/3-space;
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, wi, 35)];
    _countLabel.textAlignment = NSTextAlignmentLeft;
    _countLabel.textColor = YBLTextColor;
    _countLabel.text = @"成交 2.75万";
    _countLabel.font = YBLFont(10);
    [self addSubview:_countLabel];
    
    _priceCountButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _priceCountButton.frame = CGRectMake(CGRectGetMaxX(_countLabel.frame), CGRectGetMinY(_countLabel.frame), wi, _countLabel.height);
    _priceCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_priceCountButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    _priceCountButton.titleLabel.font = YBLFont(10);
    [self addSubview:_priceCountButton];
    
    _originLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceCountButton.frame), CGRectGetMinY(_priceCountButton.frame), wi, _priceCountButton.height)];
    _originLabel.textColor = YBLTextColor;
    _originLabel.textAlignment = NSTextAlignmentLeft;
    _originLabel.font = YBLFont(10);
    [self addSubview:_originLabel];
/*
    _cutsButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _cutsButton.frame = CGRectMake(YBLWindowWidth-wi, CGRectGetMinY(_originLabel.frame)+5, wi-10, _originLabel.height-10);
    _cutsButton.layer.borderColor = YBLTextColor.CGColor;
    _cutsButton.layer.borderWidth = 0.5;
    _cutsButton.layer.cornerRadius = 3;
    _cutsButton.layer.masksToBounds = YES;
    [_cutsButton setTitle:@"降价通知" forState:UIControlStateNormal];
    [_cutsButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    _cutsButton.titleLabel.font = YBLFont(13);
    [self addSubview:_cutsButton];
 */
}

+ (CGFloat)getOriginInfoCellHeight{
 
    return 35;
}

@end
