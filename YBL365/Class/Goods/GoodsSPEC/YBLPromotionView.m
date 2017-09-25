
//
//  YBLPromotionView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPromotionView.h"
#import "YBLHotCollectionView.h"
#import "YBLCollectionViewFlowLayout.h"
#import "YBLGoodsDetailViewController.h"

static YBLPromotionView *promotionView = nil;

#define view_top YBLWindowHeight*2/5

@interface YBLPromotionView ()

@property (nonatomic, weak) UINavigationController *vc;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation YBLPromotionView

+ (void)showPromotionViewFromVC:(UINavigationController *)Vc{
 
    if (!promotionView) {
        promotionView = [[YBLPromotionView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        promotionView.vc = Vc;
        [UIView transformOpenView:promotionView.contentView SuperView:promotionView fromeVC:Vc Top:view_top];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [bg addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-view_top)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self.contentView addSubview:titleView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_bt_7h"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToFirstView:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backButton];
    backButton.hidden = YES;
    backButton.frame = CGRectMake(0, 0, 50, 50);
    self.backButton = backButton;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLable.text = @"促销";
    titleLable.textColor = YBLTextColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = YBLFont(16);
    titleLable.centerX = titleView.width/2;
    titleLable.centerY = titleView.height/2;
    [titleView addSubview:titleLable];
    self.titleLable = titleLable;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissButton];
    dismissButton.frame = CGRectMake(titleView.width - 50, 0, 50, 50);
    
    [titleView addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleView.height-0.5, titleView.width, 0.5)]];
    /*促销*/
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.bottom, self.contentView.width, self.contentView.height-titleView.bottom)];
    [self.contentView addSubview:view1];
    self.view1 = view1;
    
    NSArray *promotionValueArray = @[@"购买飞天茅台满100箱就赠10箱冰红茶",@"购买飞天茅台满100箱就赠10箱冰红茶",@"购买飞天茅台满100箱就赠100箱冰红茶",@"购买飞天茅台满100箱就赠1000箱冰红茶"];
    
    UIScrollView *promotionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view1.width, view1.height-50)];
    [view1 addSubview:promotionScrollView];
    NSInteger index = 0;
    CGFloat itemHi = 40;
    for (NSString *text in promotionValueArray) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, index*itemHi, promotionScrollView.width, itemHi)];
        [promotionScrollView addSubview:itemView];
        
        UILabel *singleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, 0, 50, 20)];
        singleLabel.layer.borderColor = YBLThemeColor.CGColor;
        singleLabel.layer.borderWidth = 0.5;
        singleLabel.layer.cornerRadius = 3;
        singleLabel.layer.masksToBounds = YES;
        singleLabel.textAlignment = NSTextAlignmentCenter;
        singleLabel.centerY = itemView.height/2;
        singleLabel.textColor = YBLThemeColor;
        singleLabel.text = @"赠品";
        singleLabel.font = YBLFont(13);
        [itemView addSubview:singleLabel];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(singleLabel.right+2*space, 0, itemView.width-5*space-singleLabel.right, 20)];
        textLabel.textColor = BlackTextColor;
        textLabel.font = YBLFont(13);
        textLabel.text = text;
        textLabel.centerY = singleLabel.centerY;
        [itemView addSubview:textLabel];
        
        [itemView addSubview:[YBLMethodTools addLineView:CGRectMake(0, itemView.height-0.5, itemView.width, 0.5)]];
        
        index++;
    }
    CGFloat contentHi = itemHi*promotionValueArray.count;
    promotionScrollView.contentSize = CGSizeMake(promotionScrollView.width,contentHi);
    
    //查看赠品
    UIButton *lookZView = [UIButton buttonWithType:UIButtonTypeCustom];
    lookZView.frame = CGRectMake(0, promotionScrollView.height, promotionScrollView.width, 50);
    [lookZView addTarget:self action:@selector(sliderToZView:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:lookZView];
    
    if (contentHi>=promotionScrollView.height) {
        lookZView.top = view1.height-50;
    } else {
        lookZView.top = contentHi;
    }
    UILabel *zLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, 0, 100, 20)];
    zLabel.font = YBLFont(14);
    zLabel.textColor = BlackTextColor;
    zLabel.centerY = lookZView.height/2;
    zLabel.text = @"查看赠品";
    [lookZView addSubview:zLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.center = CGPointMake(lookZView.width-20, zLabel.centerY);
    [lookZView addSubview:arrowImageView];
    [lookZView addSubview:[YBLMethodTools addLineView:CGRectMake(0, lookZView.height-0.5, lookZView.width, 0.5)]];
    
    
    /*赠品*/
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(view1.width, view1.top, view1.width, view1.height)];
    [self.contentView addSubview:view2];
    self.view2 = view2;
    
    CGFloat wi = (view2.width)/3;
    CGFloat hi = (view2.height-10)/2;
    
    YBLCollectionViewFlowLayout *layout = [YBLCollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(wi, hi);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    YBLHotCollectionView *hotListCollectionView = [[YBLHotCollectionView alloc] initWithFrame:CGRectMake(0, 5, view2.width, view2.height-10) collectionViewLayout:layout];
    WEAK
    hotListCollectionView.hotCollectionDidSelectBlock = ^(){
        STRONG
        [self dismissView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
            [self.vc pushViewController:goodDetailVC animated:YES];
        });

    };
    [self.view2 addSubview:hotListCollectionView];

    
}

- (void)backToFirstView:(UIButton *)btn{
    
    self.backButton.hidden = YES;
    self.titleLable.text = @"促销";
    [UIView animateWithDuration:.34f
                     animations:^{
                         self.view2.left = self.width;
                         self.view1.left = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)sliderToZView:(UIButton *)btn{
    
    self.backButton.hidden = NO;
    self.titleLable.text = @"赠品";
    [UIView animateWithDuration:.34f
                     animations:^{
                         self.view1.left = -self.width;
                         self.view2.left = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)dismissView{
    [UIView transformCloseView:promotionView.contentView SuperView:promotionView fromeVC:promotionView.vc Top:YBLWindowHeight completion:^(BOOL finished) {
        [promotionView removeFromSuperview];
        promotionView = nil;
    }];
}

@end
