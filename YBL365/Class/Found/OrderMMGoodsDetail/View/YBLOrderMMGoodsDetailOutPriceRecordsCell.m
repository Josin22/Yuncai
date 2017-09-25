//
//  YBLOrderMMGoodsDetailOutPriceRecordsCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailOutPriceRecordsCell.h"

@interface YBLOrderMMOutPriceView ()

@end

@implementation YBLOrderMMOutPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = YBLTextColor.CGColor;
    self.layer.borderWidth = 0.5;
    
    UIButton *numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numButton setTitle:@"1" forState:UIControlStateNormal];
    [numButton setBackgroundColor:YBLThemeColor];
    numButton.titleLabel.font = YBLFont(9);
    [numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:numButton];
    numButton.frame = CGRectMake(0, 0, 25, 15);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(numButton.right, numButton.top, self.width-numButton.width, numButton.height)];
    nameLabel.text = @"****";
    nameLabel.font = YBLFont(9);
    nameLabel.textColor = YBLTextColor;
    [self addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numButton.bottom, self.width, self.height-numButton.height)];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:priceLabel];
    
}

@end

@interface YBLOrderMMGoodsDetailOutPriceRecordsCell ()

@end

@implementation YBLOrderMMGoodsDetailOutPriceRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createOutyPricesRecordsUI];
    }
    return self;
}

- (void)createOutyPricesRecordsUI{
    
    CGFloat hi = [YBLOrderMMGoodsDetailOutPriceRecordsCell getGoodsDetailOutPriceRecordsCellHeight];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-hi-space*2, hi)];
    recordLabel.textColor = YBLTextColor;
    recordLabel.font = YBLFont(14);
    [self.contentView addSubview:recordLabel];
    self.recordLabel = recordLabel;

    YBLButton *moreButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, YBLWindowWidth, hi);
    [self.contentView addSubview:moreButton];
    self.moreButton = moreButton;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.centerY = moreButton.height/2;
    arrowImageView.left = moreButton.width-8-space;
    [moreButton addSubview:arrowImageView];
    
   /*
    YBLButton *moreButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"orderMM_more"] forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(YBLWindowWidth-space-40, 0, 40, 40);
    moreButton.imageRect = CGRectMake(20, 15, 10, 12.5);
    [self addSubview:moreButton];
    self.moreButton = moreButton;
    
    UIScrollView *recordsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, recordLabel.bottom+space, YBLWindowWidth, 50)];
    recordsScrollView.backgroundColor = [UIColor whiteColor];
    recordsScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:recordsScrollView];
    
    
#warning test data
    
    CGFloat itemWi = 80;
    CGFloat itemHi = 40;
    
    recordsScrollView.contentSize = CGSizeMake(itemWi*10, itemHi);
    
    for (int i = 0; i< 10; i++) {
        
        CGRect frame = CGRectMake(space+i*(itemWi+space), 5, itemWi, itemHi);
        
        YBLOrderMMOutPriceView *itemView = [[YBLOrderMMOutPriceView alloc] initWithFrame:frame];
        
        [recordsScrollView addSubview:itemView];
    }
    */
}

+ (CGFloat)getGoodsDetailOutPriceRecordsCellHeight{
    
    return 45;
}

@end
