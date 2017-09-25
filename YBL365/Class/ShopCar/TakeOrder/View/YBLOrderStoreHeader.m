//
//  YBLOrderStoreHeader.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderStoreHeader.h"

@interface YBLOrderStoreHeader ()

@end

@implementation YBLOrderStoreHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLOrderStoreHeader getOrderStoreHeaderHi];
    
    UILabel *storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-2*space, hi)];
    storeNameLabel.text = @"订单1 : 郑州某某贸易有限公司";
    storeNameLabel.textColor = BlackTextColor;
    storeNameLabel.font = YBLFont(15);
    [self addSubview:storeNameLabel];
    self.storeNameLabel = storeNameLabel;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getOrderStoreHeaderHi{
    
    return 40;
}

@end
