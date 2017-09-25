//
//  YBLMyJoinHeaderView.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyJoinHeaderView.h"

@implementation YBLMyJoinHeaderView
- (instancetype)initWithFrame:(CGRect)frame and:(NSString*)name and:(NSString*)pictureName{
    if (self = [super initWithFrame:frame]) {
        self.name = name;
        self.imageName = pictureName;
        [self createUI];
        
    }

    return self;
}
- (void)createUI{
    self.backgroundColor = YBLColor(242, 242, 246, 1);
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-75/2, 50,75, 75)];
    self.imageView.layer.cornerRadius = self.imageView.width/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [UIColor blueColor];
//    self.imageView.image = [UIImage imageNamed:self.imageName];
    [self addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,self.imageView.bottom + 25,self.width-200, 17)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:14.f];
    self.nameLabel.text = @"云采";
//    self.nameLabel.text = self.name;
    [self addSubview:self.nameLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-0.5,self.width,0.5)];
    line.backgroundColor = YBLLineColor;
    [self addSubview:line];
}

@end
