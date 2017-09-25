//
//  YBLRankingListCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRankingListCell.h"
#import "YBLSignLabel.h"

@interface YBLRankingListCell ()

@property (nonatomic, retain) YBLSignLabel *signLabel;

@end

@implementation YBLRankingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = 120;
    
    UIImageView *goodsIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, height-2*space, height-2*space)];
    goodsIamgeView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self addSubview:goodsIamgeView];
    
    
    _signLabel = [[YBLSignLabel alloc] initWithFrame:CGRectMake(space, 0, 20, 30) SiginDirection:SiginDirectionTop];
    _signLabel.signText = @"1";
    _signLabel.textFont = YBLFont(14);
    _signLabel.isFillAll = YES;
    [self addSubview:_signLabel];
    
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsIamgeView.right+space, goodsIamgeView.top, YBLWindowWidth-goodsIamgeView.width-space*3, 40)];
    goodsNameLabel.numberOfLines = 2;
//    goodsNameLabel.attributedText = [NSString stringPrice:@"¥ 109.78" color:BlackTextColor font:18 isBoldFont:YES appendingString:nil];
    goodsNameLabel.font = YBLFont(14);
    goodsNameLabel.text = @"云采超市 鲁花5s 压榨一级 花生油 4L级 花生油 4L";
    goodsNameLabel.textColor = BlackTextColor;
    [self addSubview:goodsNameLabel];
    

    UILabel *goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsNameLabel.left, goodsNameLabel.bottom+space, goodsNameLabel.width/2, 20)];
    goodsPriceLabel.attributedText = [NSString stringPrice:@"¥ 109.78" color:BlackTextColor font:20 isBoldFont:YES appendingString:nil];
    goodsPriceLabel.font = YBLFont(18);
    [self addSubview:goodsPriceLabel];
    
    UILabel *goodsPeopleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsPriceLabel.left, goodsPriceLabel.bottom+space, goodsNameLabel.width/2, 20)];
    goodsPeopleCountLabel.text = @"1113人围观";
    goodsPeopleCountLabel.font = YBLFont(13);
    goodsPeopleCountLabel.textColor = YBLTextColor;
    [self addSubview:goodsPeopleCountLabel];
    
    NSString *string1 = @"采购数量";
    CGSize stringSize = [string1 heightWithFont:YBLFont(12) MaxWidth:100];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(YBLWindowWidth-space-stringSize.width, height-space/2-40, stringSize.width ,40)];
    [self addSubview:view];
    
    UILabel *saleCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 19.5)];
    saleCount.text = @"89";
    saleCount.textAlignment = NSTextAlignmentCenter;
    saleCount.textColor = YBLTextColor;
    saleCount.font = YBLFont(12);
    [view addSubview:saleCount];
    
    UIView *lineSale = [[UIView alloc] initWithFrame:CGRectMake(0, saleCount.bottom, view.width, 0.5)];
    lineSale.backgroundColor = YBLLineColor;
    [view addSubview:lineSale];
    
    UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineSale.bottom, view.width, 20)];
    saleLabel.text = string1;
    saleLabel.textAlignment = NSTextAlignmentCenter;
    saleLabel.textColor = YBLTextColor;
    saleLabel.font = YBLFont(12);
    [view addSubview:saleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, height-0.5, YBLWindowWidth-2*space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}


@end
