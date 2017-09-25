//
//  YBLBrandView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreBrandView.h"
#import "YBLLicensBrandItemView.h"

static NSInteger const tag_button = 302405841;

@interface YBLStoreBrandView ()

@property (nonatomic, strong) UIView *brandView;

@property (nonatomic, retain) UILabel *infoLabel;

@end

@implementation YBLStoreBrandView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, self.width, 35)];
    infoLabel.text = @"品牌授权";
    infoLabel.textColor = BlackTextColor;
    infoLabel.font = YBLFont(15);
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    self.brandView = [[UIView alloc] initWithFrame:CGRectMake(0, infoLabel.bottom, self.width, self.height-infoLabel.bottom)];
    self.brandView.backgroundColor = YBLColor(248, 248, 248, 1);
    [self addSubview:self.brandView];
}

- (void)setBrandDataArray:(NSMutableArray *)brandDataArray{
    if ([brandDataArray isKindOfClass:[NSString class]]) {
        NSString *compString = (NSString *)brandDataArray;
        if ([compString rangeOfString:@","].location==NSNotFound) {
            brandDataArray = @[compString].mutableCopy;
        } else {
            NSArray *compenArray = [compString componentsSeparatedByString:@","];
            brandDataArray = compenArray.mutableCopy;
        }
    }
    _brandDataArray = brandDataArray;
    for (UIView *suvbje in self.brandView.subviews) {
        [suvbje removeFromSuperview];
    }
    NSInteger index = 0;
    NSInteger payshiping_lie = 2;
    CGFloat brand_space = 15;
    CGFloat itemWi = (self.width-brand_space*3)/payshiping_lie;
    CGFloat itemHi = 35;
    for (NSString *brandString in _brandDataArray) {
        if (brandString.length==0) {
            return;
        }
        NSInteger row = index/payshiping_lie;
        NSInteger col = index%payshiping_lie;
        
        YBLLicensBrandItemView *itemView = [[YBLLicensBrandItemView alloc] initWithFrame:CGRectMake(brand_space+col*(itemWi+brand_space), brand_space+row*(itemHi+brand_space/2), itemWi, itemHi)];
        itemView.brandLabel.text = brandString;
        [self.brandView addSubview:itemView];
        itemView.tag = tag_button+index;
        [itemView addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (index == _brandDataArray.count-1) {
            self.brandView.height = itemView.bottom+brand_space;
            self.height = self.brandView.bottom;
        }
        index++;
    }
}

- (void)itemClick:(UIButton *)btn{

    NSInteger index = btn.tag-tag_button;
    if ([self.delegate respondsToSelector:@selector(brandItemClickToDelete:)]) {
        [self.delegate brandItemClickToDelete:index];
    }
}

@end
