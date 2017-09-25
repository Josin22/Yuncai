//
//  YBLContentBaseView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLContentBaseView.h"

@implementation YBLContentBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self addSubview:titleView];
    self.titleView = titleView;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLable.textColor = YBLTextColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = YBLFont(16);
    titleLable.centerX = titleView.width/2;
    titleLable.centerY = titleView.height/2;
    [titleView addSubview:titleLable];
    self.titleLable = titleLable;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    [titleView addSubview:dismissButton];
    dismissButton.frame = CGRectMake(titleView.width - 50, 0, 50, 50);
    self.dismissButton = dismissButton;
    
    [titleView addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleView.height-0.5, titleView.width, 0.5)]];

}

@end
