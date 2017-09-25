//
//  YBLStoreCollectView.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreCollectView.h"

@interface YBLStoreCollectView ()
//收藏图片
@property (nonatomic, strong) UIImageView * collectImg;
//收藏成功
@property (nonatomic, strong) UILabel * contenLab;
@end

@implementation YBLStoreCollectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BlackTextColor;
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
        self.alpha = 0.8;
        //收藏图片
        _collectImg = [[UIImageView alloc]init];
        [self addSubview:_collectImg];
        
        //收藏成功
        _contenLab = [[UILabel alloc]init];
        _contenLab.font = YBLFont(15);
        _contenLab.textColor = [UIColor whiteColor];
        _contenLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contenLab];
    }
    return self;
}


- (void)showWithCollect:(BOOL)collect {
    NSString * contentStr;
    UIImage * collectImg;
    if (collect) {
        contentStr = @"关注成功";
        collectImg = [UIImage imageNamed:@""];
        
    }else {
        contentStr = @"取消关注";
        collectImg = [UIImage imageNamed:@""];
    }
    self.contenLab.text = contentStr;
    self.collectImg.image = collectImg;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.frame = CGRectMake((YBLWindowWidth-150)/2, (YBLWindowHeight-110)/2, 150, 110);
//    } completion:^(BOOL finished) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.3 animations:^{
//                self.frame = CGRectMake(YBLWindowWidth/2,YBLWindowHeight/2 ,0, 0);
//            } completion:^(BOOL finished) {
//                if (self.dismissBlock) {
//                    self.dismissBlock();
//                }
//                [self removeFromSuperview];
//            }];
//        });
//    }];
}

@end
