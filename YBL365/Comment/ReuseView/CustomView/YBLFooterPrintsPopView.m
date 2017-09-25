//
//  YBLFooterPrintsPopView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterPrintsPopView.h"
#import "YBLFootePrintsCollectionView.h"

static YBLFooterPrintsPopView *popView = nil;

@interface YBLFooterPrintsPopView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, retain) UILabel *footLabel;

@property (nonatomic, strong) UIVisualEffectView *contentView;

@property (nonatomic, strong) YBLFootePrintsCollectionView *footerPrintsCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) FooterPrintsPopViewDidSelectItemBlock completionBlock;

@property (nonatomic, copy  ) FooterPrintsPopViewCancelBlock cancelBlock;

@end

@implementation YBLFooterPrintsPopView

+ (void)showFooterPrintsPopViewWithDataArray:(NSMutableArray *)dataArray
                             completionBlock:(FooterPrintsPopViewDidSelectItemBlock)completionBlock
                                 cancelBlock:(FooterPrintsPopViewCancelBlock)cancelBlock{
    if (!popView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        popView = [[YBLFooterPrintsPopView alloc] initWithFrame:[keyWindow bounds]
                                                      dataArray:dataArray
                                                completionBlock:completionBlock
                                                    cancelBlock:cancelBlock];
        [keyWindow addSubview:popView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSMutableArray *)dataArray
              completionBlock:(FooterPrintsPopViewDidSelectItemBlock)completionBlock
                  cancelBlock:(FooterPrintsPopViewCancelBlock)cancelBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArray = dataArray;
        _completionBlock = completionBlock;
        _cancelBlock = cancelBlock;
        
        [self createIU];
    }
    return self;
}

- (void)createIU {

    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
   
    CGFloat labelHei = 70;
    CGFloat contentHi = ItemHeight+labelHei;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.contentView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.contentView.frame = CGRectMake(0, -contentHi, self.width, contentHi);
    [self addSubview:self.contentView];
    
    
    self.footerPrintsCollectionView = [[YBLFootePrintsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height-labelHei)];
    self.footerPrintsCollectionView.bottom = self.contentView.height-space;
    self.footerPrintsCollectionView.dataArray = self.dataArray;
    WEAK
    self.footerPrintsCollectionView.footerPrintsScollToIndexBlock = ^(NSInteger index) {
        STRONG
        [self resetFooterInfoWithIndex:index];
    };
    self.footerPrintsCollectionView.didSelectItemBlock = ^(id model,NSIndexPath *selectIndexPath) {
        STRONG
        [self dismissWithSelectModel:model];
    };
    [self.contentView addSubview:self.footerPrintsCollectionView];
    self.footerPrintsCollectionView.backgroundColor = [UIColor clearColor];
    [self.footerPrintsCollectionView reloadData];
    [self.footerPrintsCollectionView checkNull];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.contentView.width, labelHei-space-20)];
    footLabel.textColor = YBLColor(70, 70, 70, 1);
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = YBLFont(15);
    [self.contentView addSubview:footLabel];
    self.footLabel = footLabel;
    
    [self resetFooterInfoWithIndex:0];
    
    [UIView animateWithDuration:.4
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
                         self.contentView.top = 0;
                     }];
}

- (void)resetFooterInfoWithIndex:(NSInteger)index{
    NSInteger number = self.dataArray.count;
    if (number == 0) {
        self.footLabel.text  = @"浏览足迹";
    }else {
        self.footLabel.text  = [NSString stringWithFormat:@"浏览足迹(%ld/%ld)",index+1,number];
    }
}

- (void)dismiss{
    
    [self dismissWithSelectModel:nil];
}

- (void)dismissWithSelectModel:(YBLGoodModel *)selectGoodModel{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top = -self.contentView.height;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }completion:^(BOOL finished) {
        if (selectGoodModel) {
            BLOCK_EXEC(self.completionBlock,selectGoodModel);
        } else {
            BLOCK_EXEC(self.cancelBlock,);
        }
        [popView removeFromSuperview];
        popView = nil;
    }];
}

@end
