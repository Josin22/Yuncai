//
//  YBLStoreNewCollectionHeader.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreNewCollectionHeader.h"

@interface YBLStoreNewCollectionHeader ()

@property (nonatomic, strong) UILabel * titleLab;

@end

@implementation YBLStoreNewCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YBLColor(243, 243, 243, 1);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.titleLab = [[UILabel alloc]init];
    _titleLab.text = @"12月22日本店上新";
    _titleLab.textColor = [UIColor lightGrayColor];
    _titleLab.font = YBLFont(12);
    CGFloat width = [_titleLab.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]}];
    [self addSubview:self.titleLab];
    
    UIImageView * rightArrowImg = [[UIImageView alloc]initWithFrame:CGRectMake((YBLWindowWidth-25-width)/2, 5, 20, 20)];
    rightArrowImg.image = [UIImage imageNamed:@"NewFinderNaviMessageIcon_20x20_"];
    [self addSubview:rightArrowImg];
    
    _titleLab.frame = CGRectMake(rightArrowImg.right+5, 5, width, 20);

    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(8, 14.5, rightArrowImg.frame.origin.x-10, 1)];
    leftView.backgroundColor = YBLLineColor;
    [self addSubview:leftView];
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(_titleLab.right+2, 14.5, leftView.width, 1)];
    rightView.backgroundColor = YBLLineColor;
    [self addSubview:rightView];
}

@end
