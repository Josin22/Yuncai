//
//  YBLStoreInfoHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreInfoHeaderView.h"

@implementation YBLStoreInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIImageView *storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80, 30)];
    storeImageView.image = [UIImage imageNamed:middleImagePlaceholder];
    storeImageView.userInteractionEnabled = YES;
    storeImageView.layer.borderColor = YBLLineColor.CGColor;
    storeImageView.layer.borderWidth = 1;
    [self addSubview:storeImageView];
    self.storeImageView = storeImageView;
    
    CGFloat foucsWi = 0;
    
    YBLButton *storeNameButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    storeNameButton.frame = CGRectMake( storeImageView.right+5,storeImageView.top, self.width-storeImageView.right-5-foucsWi-5, 15);
    [storeNameButton setTitle:@"云采商城" forState:UIControlStateNormal];
    [storeNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    storeNameButton.titleLabel.font = YBLFont(15);
    storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    storeNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:storeNameButton];
    self.storeNameButton = storeNameButton;
    
    UILabel *signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeNameButton.left, storeNameButton.bottom, 55, 15)];
    signalLabel.bottom = storeImageView.bottom;
    signalLabel.text = @"综合 9.5";
    signalLabel.textColor = [UIColor whiteColor];
    signalLabel.font = YBLFont(10);
    [self addSubview:signalLabel];
    self.signalLabel = signalLabel;

}

@end
