//
//  YBLHomeNavigationView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLHomeNavigationView.h"

@interface YBLHomeNavigationView ()

@property (nonatomic, assign) NavigationType navigationType;

@property (nonatomic, strong) UIImageView *searchImageView;

@end

@implementation YBLHomeNavigationView

- (instancetype)initWithFrame:(CGRect)frame navigationType:(NavigationType)navigationType {
    if (self = [super initWithFrame:frame]) {
        
        _navigationType = navigationType;
        
        [self createSubViews];
    }
    return self;
}

/**
 *  修改颜色
 */
- (void)changeColorWithState:(BOOL)state {
    
    if (state) {
        self.searchImageView.image = [UIImage imageNamed:@"JDMainPage_icon_search02_15x15_"];
        self.searchButton.backgroundColor = YBLColor(200, 202, 205, 0.4);
        self.searchLabel.textColor = YBLColor(170, 172, 179, 1);
        [self.scanButton setImage:[UIImage imageNamed:@"JDMainPage_icon_scan02_18x18_"] forState:UIControlStateNormal];
         [self.scanButton setTitleColor:YBLColor(47, 47, 47, 1.0) forState:UIControlStateNormal];
        [self.messageButton setImage:[UIImage imageNamed:@"JDMainPage_icon_message02_18x18_"] forState:UIControlStateNormal];
        [self.messageButton setTitleColor:YBLColor(47, 47, 47, 1.0) forState:UIControlStateNormal];
    
        
    }else {
        
        self.searchImageView.image = [UIImage imageNamed:@"JDMainPage_icon_search_15x15_"];
        self.searchButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        self.searchLabel.textColor = [UIColor whiteColor];
        [self.scanButton setImage:[UIImage imageNamed:@"JDMainPage_icon_scan_18x18_"] forState:UIControlStateNormal];
        [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.messageButton setImage:[UIImage imageNamed:@"JDMainPage_icon_message_18x18_"] forState:UIControlStateNormal];
     
    }
}


- (void)createSubViews {
    
    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scanButton.frame = CGRectMake(5, 20, 44, 44);
    [self addSubview:self.scanButton];

    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(54, 20+7, YBLWindowWidth - 54*2, 30);
    self.searchButton.layer.cornerRadius = self.searchButton.height/2;
    self.searchButton.layer.masksToBounds = YES;
    [self addSubview:self.searchButton];
    
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7.5, 15, 15)];
    [self.searchButton addSubview:self.searchImageView];
    
    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.searchImageView.right+5, 0, self.searchButton.width-self.searchImageView.right-20, self.searchButton.height)];
    self.searchLabel.font = YBLFont(14);
    self.searchLabel.text = @"搜索商品";
    [self.searchButton addSubview:self.searchLabel];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageButton.frame = CGRectMake(self.width - 44 - 5, 20, 44, 44);
    [self addSubview:self.messageButton];
 
    if (_navigationType == NavigationTypeHome) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.searchButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        
        [self.scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
        [self.scanButton setImage:[UIImage imageNamed:@"JDMainPage_icon_scan_18x18_"] forState:UIControlStateNormal];
        [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.scanButton.titleLabel.font = YBLFont(11);
        [self.scanButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 10, 0, 0)];
        [self.scanButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
        
        [self.messageButton setTitle:@"消息" forState:UIControlStateNormal];
        [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.messageButton setImage:[UIImage imageNamed:@"JDMainPage_icon_message_18x18_"] forState:UIControlStateNormal];
        self.messageButton.titleLabel.font = YBLFont(11);
        [self.messageButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 10, 0, 0)];
        [self.messageButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
        
        self.searchImageView.image = [UIImage imageNamed:@"JDMainPage_icon_search_15x15_"];
        
        self.searchLabel.textColor = [UIColor whiteColor];
        
//        self.layer.shadowPath = [self getShadowPath].CGPath;
        
    } else if(_navigationType == NavigationTypeCatgory){
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.searchButton.backgroundColor = YBLColor(240, 242, 245, 1);
        
        [self.scanButton setImage:[UIImage imageNamed:@"NewFinderNaviScannerIcon_20x20_"] forState:UIControlStateNormal];
        [self.messageButton setImage:[UIImage imageNamed:@"NewFinderNaviMessageIcon_20x20_"] forState:UIControlStateNormal];
     
        self.searchLabel.textColor = YBLColor(170, 172, 179, 1);
        
        self.searchImageView.image = [UIImage imageNamed:@"JDMainPage_icon_search02_15x15_"];
    }
    
    
}

- (UIBezierPath *)getShadowPath{
    //添加阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 4;//阴影半径，默认3
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.height-1)];
    [path addLineToPoint:CGPointMake(self.width, self.height-1)];
    [path addLineToPoint:CGPointMake(self.width, self.height+2)];
    [path addLineToPoint:CGPointMake(0, self.height+2)];
    [path addLineToPoint:CGPointMake(0, self.height-1)];
    return path;
}

- (void)transFormMassageButtonOrgin{
    
    self.messageButton.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    
    [UIView animateWithDuration:.5
                     animations:^{
                        self.messageButton.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

@end
