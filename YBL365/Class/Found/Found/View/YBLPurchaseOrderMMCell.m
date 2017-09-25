//
//  YBLPurchaseOrderMMCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOrderMMCell.h"
#import "YBLTimeDown.h"

@interface YBLPurchaseOrderMMCell ()

@property (nonatomic, retain) UILabel *boxCountLabel;

@property (nonatomic, retain) UILabel *localLabel;

@property (nonatomic, strong) YBLTimeDown *timeDownLabel;

@end

@implementation YBLPurchaseOrderMMCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createOrderMMUI];
    }
    return self;
}

- (void)createOrderMMUI{
    
    self.isListType = NO;
    
    self.goodNameLabel.frame = CGRectMake(4, CGRectGetMaxY(self.goodImageView.frame), self.goodImageView.width-8, 35);
    
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.goodNameLabel.frame), CGRectGetMaxY(self.goodNameLabel.frame), self.goodNameLabel.width/2-2, 20);

//    self.goodNameLabel.font = YBLFont(13);
    
    _boxCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.left+self.priceLabel.width, self.priceLabel.top, self.priceLabel.width, 15)];
    _boxCountLabel.text = @"000箱";
    _boxCountLabel.bottom = self.priceLabel.bottom;
    _boxCountLabel.textAlignment = NSTextAlignmentRight;
    _boxCountLabel.textColor = YBLColor(150, 150, 150, 1);
    _boxCountLabel.font = YBLFont(11);
    [self.contentView addSubview:_boxCountLabel];

    self.saleCountLabel.frame = CGRectMake(self.priceLabel.left, self.priceLabel.bottom, self.priceLabel.width, self.priceLabel.height);
    self.saleCountLabel.textColor = YBLColor(150, 150, 150, 1);
    self.saleCountLabel.font = YBLFont(11);
    
    _localLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.saleCountLabel.left+self.saleCountLabel.width, self.saleCountLabel.top, self.saleCountLabel.width, self.saleCountLabel.height)];
    _localLabel.textColor = YBLColor(150, 150, 150, 1);
    _localLabel.textAlignment = NSTextAlignmentRight;
    _localLabel.font = YBLFont(11);
    _localLabel.text = @"郑州";
    [self.contentView addSubview:_localLabel];
    
    _timeDownLabel = [[YBLTimeDown alloc] initWithFrame:CGRectMake(2, self.height-20, self.width-4, 16) WithType:TimeDownTypeText];
    _timeDownLabel.textTimerLabel.font = YBLFont(12);
    _timeDownLabel.textTimerLabel.textColor = YBLColor(110, 110, 110, 1);
    [self.contentView addSubview:_timeDownLabel];
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLPurchaseOrderModel *model = (YBLPurchaseOrderModel *)itemModel;
    
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:smallImagePlaceholder];
    
//    CGSize titleSize = [model.title heightWithFont:YBLFont(13) MaxWidth:self.goodImageView.width-8];

    self.goodNameLabel.font = model.text_font;
    
    self.goodNameLabel.text = model.title;
    
    self.goodNameLabel.height = model.text_height;
    
    self.priceLabel.attributedText = model.att_price;
    
    self.boxCountLabel.text = [NSString stringWithFormat:@"%d%@",model.quantity.intValue,model.unit];
    
    NSString *looks = [NSString stringWithFormat:@"%@人/浏览",model.visit_times];
    self.saleCountLabel.text = looks;
    
    self.localLabel.text = [NSString stringWithFormat:@"%@ %@",model.address_info.province_name,model.address_info.city_name];
    
    //model.enddated_at
    [self.timeDownLabel setEndTime:model.enddated_at NowTime:model.system_time begainText:@"距结束:"];
}

//+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
//    
//   CGFloat superHi = [super getItemCellHeightWithModel:itemModel];
//    
//    return superHi+15;
//}

@end
