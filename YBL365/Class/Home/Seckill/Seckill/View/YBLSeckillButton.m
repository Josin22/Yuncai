//
//  YBLSeckillButton.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillButton.h"

@implementation YBLSeckillButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSeckillType:(SeckillType)seckillType{
    _seckillType = seckillType;
    
    self.titleLabel.font = YBLFont(13);
    
    if (seckillType == SeckillTypeGoBuy) {
 
        self.enabled = YES;
        [self setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"去抢购" forState:UIControlStateNormal];

    } else if (seckillType == SeckillTypeNoCount){
        
        self.enabled = NO;
        [self setTitleColor:YBLTextColor forState:UIControlStateDisabled];
        [self setBackgroundColor:YBLColor(240, 240, 240, 1) forState:UIControlStateDisabled];
        [self setTitle:@"已抢完" forState:UIControlStateDisabled];

    } else {
        
        self.enabled = YES;
        [self setTitle:@"提醒我" forState:UIControlStateNormal];
        [self setTitle:@"取消提醒" forState:UIControlStateSelected];
        [self setBackgroundColor:YBLColor(43, 167, 19, 1) forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:YBLColor(43, 167, 19, 1) forState:UIControlStateSelected];
        if (seckillType == SeckillTypeRecomandSelect) {
            self.layer.borderWidth = 0.5f;
            self.layer.masksToBounds = YES;
            self.layer.borderColor = YBLColor(43, 167, 19, 1).CGColor;
//            self.selected = YES;
        } else {
//            self.selected = NO;
        }

    }

}

//- (SeckillType)type{
//    
//    return ;
//}

@end
