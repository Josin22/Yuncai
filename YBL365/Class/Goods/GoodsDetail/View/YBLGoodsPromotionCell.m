//
//  YBLGoodsPromotionCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsPromotionCell.h"

@interface YBLGoodsPromotionCell ()

@end

@implementation YBLGoodsPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self createPromotionUI];
    }
    return self;
}

- (void)createPromotionUI{

    NSString *labelText = @"促销";
    
    CGFloat hi = [YBLGoodsPromotionCell getPromotionCellHeight];
    
    CGSize labelSize = [labelText heightWithFont:YBLFont(14) MaxWidth:200];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, labelSize.width, labelSize.height)];
    label.text  = labelText;
    label.centerY = hi/2;
    label.textColor = YBLTextColor;
    label.font = YBLFont(13);
    [self addSubview:label];
    
    NSString *title = @"满赠";
    NSString *text = @"满29.00另加29.00元,或满66.00另加66.00元,即可在购物车换购热销商品";
    
    CGSize titleSize = [title heightWithFont:YBLFont(12) MaxWidth:100];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, label.top, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.font = YBLFont(11);
    titleLabel.layer.borderColor = YBLThemeColor.CGColor;
    titleLabel.layer.borderWidth = 0.5;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 3;
    titleLabel.centerY = label.centerY;
    titleLabel.textColor = YBLThemeColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, CGRectGetMinY(titleLabel.frame), YBLWindowWidth-10-CGRectGetMaxX(titleLabel.frame)-40, titleLabel.height)];
    textLabel.text = text;
    textLabel.numberOfLines = 1;
    textLabel.textColor = BlackTextColor;;
    textLabel.centerY = label.centerY;
    textLabel.font = YBLFont(12);
    [self addSubview:textLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(YBLWindowWidth-10-30, 5, 30,20);
    moreButton.centerY = hi/2;
    [moreButton setImage:[UIImage imageNamed:@"more_sandian"] forState:UIControlStateNormal];
    moreButton.enabled = NO;
    [self addSubview:moreButton];
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, YBLWindowWidth, 1)]];
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-1, YBLWindowWidth, 1)]];
 
}

+ (CGFloat)getPromotionCellHeight{
    
    return 50;
}

@end
