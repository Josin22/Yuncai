//
//  YBLOrderBarrageView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderBarrageView.h"
#import "YBLOrderBulletModel.h"
#import "NSArray+YYAdd.h"

@interface YBLOrderBarrageItemView : UIButton

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *contentTextLabel;

@end

@implementation YBLOrderBarrageItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    self.iconImageView.userInteractionEnabled = YES;
    [self addSubview:self.iconImageView];
    
    self.contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right, 0, self.width-self.height, self.height)];
    self.contentTextLabel.textColor = [UIColor whiteColor];
    self.contentTextLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    self.contentTextLabel.numberOfLines = 0;
    self.contentTextLabel.font = YBLFont(12);
    [self addSubview:self.contentTextLabel];
    
}

@end


@interface YBLOrderBarrageView (){
    BOOL isAnimating;
    YBLOrderBulletModel *currentModel;
}
//头
@property (nonatomic, strong) YBLOrderBarrageItemView *firstItemView;

@end

@implementation YBLOrderBarrageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UITapGestureRecognizer *superGets = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewTap:)];
    [self addGestureRecognizer:superGets];
    
    //默认起始位置
    self.firstItemView = [[YBLOrderBarrageItemView alloc] initWithFrame:CGRectZero];
    self.firstItemView.layer.anchorPoint = CGPointMake(0, .5);
    [self addSubview:self.firstItemView];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count == 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        if (!isAnimating) {
            [self bullets];
            [self animationBullets];
        }
    }
}

- (void)bullets {
    currentModel = self.dataArray[0];
    [self reJustifyItemView:self.firstItemView itemModel:currentModel];
    
}

- (void)animationBullets{
    [self animationFirst];
    isAnimating = YES;
}

- (void)animationFirst{
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.firstItemView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         self.firstItemView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2
                                               delay:0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.firstItemView.top = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.3 animations:^{
                                                 [self toDefaultItemView:self.firstItemView];
                                              } completion:^(BOOL finished) {
                                                  if (self.isStopRunning) {
                                                      return ;
                                                  }
                                                  [self.dataArray removeFirstObject];
                                                  if (self.dataArray.count==0) {
                                                      return ;
                                                  }
                                                  [self animationFirst];
                                                  [self bullets];
                                              }];
                                          }];
                     }];
}


- (void)toDefaultItemView:(YBLOrderBarrageItemView *)itemView{
    itemView.alpha = 0.f;
    itemView.left = 0;
    itemView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
}

- (void)reJustifyItemView:(YBLOrderBarrageItemView *)itemView itemModel:(YBLOrderBulletModel *)model{
    itemView.width = model.iconWidth+model.contentSize.width;
    itemView.height = model.contentSize.height<model.iconWidth?model.iconWidth:model.contentSize.height;
    itemView.bottom = self.height;
    itemView.iconImageView.size =  CGSizeMake(model.iconWidth, model.iconWidth);
    itemView.contentTextLabel.left = itemView.iconImageView.right;
    itemView.contentTextLabel.size = CGSizeMake(model.contentSize.width, itemView.height);
    itemView.iconImageView.centerX = itemView.height/2;
    itemView.iconImageView.image = nil;
    [itemView.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    itemView.contentTextLabel.text = model.content;
}

- (void)superViewTap:(UITapGestureRecognizer*)sender
{
    CGPoint touchPoint = [sender locationInView:self.firstItemView];
    if ([self.firstItemView.layer.presentationLayer hitTest:touchPoint])
    {
        if ([self.delegate respondsToSelector:@selector(orderBarrageViewItemSelect:)]) {
            [self.delegate orderBarrageViewItemSelect:currentModel];
        }
    }
}


@end
