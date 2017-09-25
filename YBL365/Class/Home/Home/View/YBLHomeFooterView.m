//
//  YBLHomeFooterView.m
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeFooterView.h"
#import "YBLFooterSignView.h"

@interface YBLHomeFooterView ()

@property (nonatomic, strong) YBLFooterSignView *bottomImageView;

@end

@implementation YBLHomeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.bottomImageView = [[YBLFooterSignView alloc] initWithFrame:[self bounds]];
    [self addSubview:self.bottomImageView];
}

+ (CGFloat)getHomeFooterHeight{
    
    return kNavigationbarHeight;
}

@end
