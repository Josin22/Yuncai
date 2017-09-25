//
//  YBLWalletsHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWalletsTitleHeaderView.h"

@interface YBLWalletsTitleHeaderView ()

@property (nonatomic, retain) UILabel *topLabel;

@property (nonatomic, retain) UILabel *bottomLabel;

@end

@implementation YBLWalletsTitleHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = YBLColor(243, 243, 243, 1);
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-2*space, 25)];
    self.topLabel.textColor = YBLTextColor;
    self.topLabel.text = loadString;
    self.topLabel.font = YBLFont(14);
    [self.contentView addSubview:self.topLabel];
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLabel.left, self.topLabel.bottom, self.topLabel.width, self.topLabel.height)];
    self.bottomLabel.textColor = YBLTextColor;
    self.bottomLabel.text = loadString;
    self.bottomLabel.font = YBLFont(14);
    [self.contentView addSubview:self.bottomLabel];
}

+ (CGFloat)getHi{
    
    return 50;
}

@end
