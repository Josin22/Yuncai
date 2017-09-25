//
//  YBLGoodsEvaluateFooterView.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsEvaluateFooterView.h"

@interface YBLGoodsEvaluateFooterView ()

@end

@implementation YBLGoodsEvaluateFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createFooterViewUI];
    }
    return self;
}

- (void)createFooterViewUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    YBLButton *picButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    picButton.frame = CGRectMake(10, 10, YBLWindowWidth-20, 30);
    picButton.layer.borderColor = YBLTextLightColor.CGColor;
    picButton.layer.borderWidth = 0.5;
    picButton.layer.masksToBounds = YES;
    picButton.layer.cornerRadius = 3;
    picButton.titleLabel.font = YBLFont(14);
    [picButton setTitle:@"查看全部评价" forState:UIControlStateNormal];
    [picButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self addSubview:picButton];
    self.picButton = picButton;
    
    UIView *fackView = [[UIView alloc] initWithFrame:CGRectMake(0, picButton.bottom+space, YBLWindowWidth, space)];
    fackView.backgroundColor = YBLColor(243, 243, 246, 1);
    [self addSubview:fackView];
}


+ (CGFloat)getGoodsEvaluateFooterViewHeight{
    
    return 60;
}

@end
