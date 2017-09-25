//
//  YBLGoodDetailTitleView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodDetailTitleView.h"

@interface YBLGoodDetailTitleView ()


@end

@implementation YBLGoodDetailTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self addSubview:self.goodsDetailSegment];
        [self addSubview:self.picDetailLabel];
        
    }
    return self;
}

- (YBLTextSegmentControl *)goodsDetailSegment{
    
    if (!_goodsDetailSegment) {
        _goodsDetailSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                                           TextSegmentType:TextSegmentTypeGoodsDetail];
        [_goodsDetailSegment updateTitleData:[@[@"商品",@"详情",@"评价"] mutableCopy]];
    }
    return _goodsDetailSegment;
}

- (UILabel *)picDetailLabel{
    
    if (!_picDetailLabel) {
        _picDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsDetailSegment.bottom, self.width, self.height)];
        _picDetailLabel.textAlignment = NSTextAlignmentCenter;
        _picDetailLabel.text = @"图文详情";
        _picDetailLabel.textColor = YBLColor(40, 40, 40, 1);
        _picDetailLabel.font = YBLFont(18);
    }
    return _picDetailLabel;
}

- (void)sliderTop{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.goodsDetailSegment.top=0;
                         self.picDetailLabel.top = self.height;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];

}

- (void)sliderBottom{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.goodsDetailSegment.top=-self.height;
                         self.picDetailLabel.top = 0;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];

}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    
}

@end
