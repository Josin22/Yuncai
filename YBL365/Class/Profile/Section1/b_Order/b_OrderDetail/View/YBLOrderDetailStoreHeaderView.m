//
//  YBLOrderDetailStoreHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailStoreHeaderView.h"

@interface YBLOrderDetailStoreHeaderView ()

@end

@implementation YBLOrderDetailStoreHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttinWi = YBLWindowWidth-space;
    CGFloat buttinHi = 40;
    
    self.storeButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.storeButton.frame = CGRectMake(space, 0, buttinWi, buttinHi);
    [self.storeButton setTitle:loadString forState:UIControlStateNormal];
    self.storeButton.titleLabel.font = YBLFont(14);
    self.storeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.storeButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    self.storeButton.titleRect = CGRectMake(0, 0, buttinWi-space-7, buttinHi);
    self.storeButton.imageRect = CGRectMake(buttinWi-space-7, (buttinHi-15)/2, 7, 15);
    [self.storeButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.storeButton];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.storeButton.bottom-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHi{
    
    return [YBLOrderDetailStoreHeaderView new].storeButton.height;
}

@end
