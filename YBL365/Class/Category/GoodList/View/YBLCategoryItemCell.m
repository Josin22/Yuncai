//
//  YBLCategoryItemCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryItemCell.h"
#import "YBLFoucsStoreView.h"
#import "YBLListBaseModel.h"

@interface YBLCategoryItemCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLCategoryItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.goodImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.goodImageView];

    _goodNameLabel = [[UILabel alloc] init];
    _goodNameLabel.font = YBLFont(14);
    _goodNameLabel.textColor = BlackTextColor;
    _goodNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_goodNameLabel];
   
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.text = @"¥ 00.00";
    [self.contentView addSubview:_priceLabel];
    
    _saleCountLabel = [[UILabel alloc] init];
    _saleCountLabel.text = [NSString stringWithFormat:@"成交0笔"];
    _saleCountLabel.textColor = YBLColor(150, 150, 150, 150);
    _saleCountLabel.font = YBLFont(12);
    _saleCountLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_saleCountLabel];
    
    self.lineView = [YBLMethodTools addLineView:CGRectMake(0, 0, self.width, .5)];
    [self.contentView addSubview:self.lineView];
    self.lineView.hidden = YES;
}

- (void)updateItemCellModel:(id)itemModel{
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    if ([itemModel isKindOfClass:[YBLListCellItemModel class]]) {
        YBLListCellItemModel *model = (YBLListCellItemModel *)itemModel;
        goodModel = model.valueOfRowItemCellData;
    }
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:goodModel.thumb]
                                placeholderImage:smallImagePlaceholder];
    CGSize titleSize = [goodModel.title heightWithFont:YBLFont(14) MaxWidth:self.goodNameLabel.width];
    self.goodNameLabel.text = goodModel.title;
    self.goodNameLabel.height = titleSize.height>35?35:titleSize.height;
    self.saleCountLabel.bottom = self.height-3;
    self.priceLabel.bottom = self.saleCountLabel.top;
    self.priceLabel.attributedText = goodModel.att_price;
    self.saleCountLabel.text = [NSString stringWithFormat:@"成交%ld笔  %ld条评论",goodModel.sale_order_count.integerValue,goodModel.comments_total.integerValue];
}

- (void)setIsListType:(BOOL)isListType
{
    _isListType = isListType;
    
    if (self.isListType) {
        
        self.lineView.hidden = NO;
        self.goodImageView.frame = CGRectMake(0, 0, self.height-5, self.height-5);
        self.goodImageView.centerY = self.height/2;
        self.goodNameLabel.frame = CGRectMake(self.goodImageView.right+space, space, YBLWindowWidth-self.goodImageView.right-space*2, 20);
        self.saleCountLabel.frame = CGRectMake(_goodNameLabel.left, 0, _goodNameLabel.width, _goodNameLabel.height);
        self.saleCountLabel.bottom = self.goodImageView.bottom;
        self.priceLabel.frame = CGRectMake(_goodNameLabel.left, 0, _goodNameLabel.width, _goodNameLabel.height+5);
        self.priceLabel.bottom = self.saleCountLabel.top-5;
        self.lineView.left = self.goodNameLabel.left;
        self.lineView.width = self.width-self.lineView.left;
        self.lineView.bottom = self.height;
    } else {
        self.lineView.hidden = YES;
        self.goodImageView.frame = CGRectMake(0, 0, self.width, self.width);
        self.goodNameLabel.frame = CGRectMake(4, self.goodImageView.bottom+space/2, self.width-8, 20);
        self.priceLabel.frame = CGRectMake(_goodNameLabel.left, _goodNameLabel.bottom, _goodNameLabel.width, _goodNameLabel.height+5);
        self.saleCountLabel.frame = CGRectMake(_goodNameLabel.left, _priceLabel.bottom, _goodNameLabel.width, _goodNameLabel.height);
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    CGFloat width = (YBLWindowWidth-15)/2;
    CGFloat hi = width+85;
    return hi;
}

@end
