//
//  YBLBrandView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBrandView.h"

@interface BrandItemHeaderView : UICollectionReusableView

@end

@implementation BrandItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space+5, self.height-20, self.width/2, 20)];
    titleLabel.text = @"品牌";
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(16);
    [self addSubview:titleLabel];
}

@end

@interface brandItemCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation brandItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = [self bounds];
    itemButton.layer.cornerRadius = 3;
    itemButton.layer.masksToBounds = YES;
    [itemButton setBackgroundColor:YBLColor(226, 226, 226, 1) forState:UIControlStateNormal];
    [itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [itemButton setTitle:@"品牌" forState:UIControlStateNormal];
    itemButton.titleLabel.font = YBLFont(13);
    [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [itemButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:itemButton];
    self.itemButton = itemButton;
}

- (void)itemButtonClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    [self setButtonSelectStatue:btn.selected];
}

- (void)setButtonSelectStatue:(BOOL)isSelect{
    
    if (isSelect) {
        self.itemButton.layer.borderColor = YBLThemeColor.CGColor;
        self.itemButton.layer.borderWidth = 0.5;
    } else {
        self.itemButton.layer.borderColor = YBLColor(226, 226, 226, 1).CGColor;
        self.itemButton.layer.borderWidth = 0.5;
    }
}

@end


static YBLBrandView *brandView = nil;

static const CGFloat leftSpace = 70;

@interface YBLBrandView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UICollectionView *brandCollectionView;

@property (nonatomic, copy  ) BrandSureBlock sureBlock;

@property (nonatomic, strong) UIButton *dimissButton;
@property (nonatomic, strong) UIButton *submitBUtton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation YBLBrandView

+ (void)showBrandViewWithData:(NSMutableArray *)data
              BrandSureHandle:(BrandSureBlock)sureBlock{
    
    if (!brandView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        brandView = [[YBLBrandView alloc] initWithFrame:[keyWindow bounds]
                                                   Data:data
                                        BrandSureHandle:sureBlock];
        [keyWindow addSubview:brandView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                         Data:(NSMutableArray *)data
              BrandSureHandle:(BrandSureBlock)sureBlock{

    if (self = [super initWithFrame:frame]) {
        _data = data;
        _sureBlock = sureBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [bgView addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, 0, self.width-leftSpace, self.height)];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    CGFloat buttonWi = contentView.width/2;
    CGFloat buttonHi = 48;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    CGFloat width = (contentView.width-60)/3;
    CGFloat hi = 38;
    flowLayout.itemSize = CGSizeMake(width, hi);
    flowLayout.headerReferenceSize = CGSizeMake(contentView.width, 28);
    self.brandCollectionView = [[UICollectionView alloc] initWithFrame:[contentView bounds] collectionViewLayout:flowLayout];
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    self.brandCollectionView.height = self.height-buttonHi;
    self.brandCollectionView.backgroundColor = YBLColor(243, 243, 243, 1);
    [self.brandCollectionView registerClass:NSClassFromString(@"brandItemCell") forCellWithReuseIdentifier:@"brandItemCell"];
    [self.brandCollectionView registerClass:NSClassFromString(@"BrandItemHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BrandItemHeaderView"];
    [self.brandCollectionView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [contentView addSubview:self.brandCollectionView];
    
    self.dimissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dimissButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [self.dimissButton setTitle:@"重置" forState:UIControlStateNormal];
    self.dimissButton.backgroundColor = [UIColor whiteColor];
    self.dimissButton.titleLabel.font = YBLFont(17);
    [contentView addSubview:self.dimissButton];
    [self.dimissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.height.equalTo(@(buttonHi));
        make.width.equalTo(@(buttonWi));
    }];
    [[self.dimissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    self.submitBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBUtton.backgroundColor = YBLColor(240, 70, 73, 1.0);
    [self.submitBUtton setTitle:@"确定" forState:UIControlStateNormal];
    self.submitBUtton.titleLabel.font = YBLFont(17);
    [contentView addSubview:self.submitBUtton];
    [self.submitBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dimissButton.mas_right);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(buttonHi));
        make.width.equalTo(@(buttonWi));
    }];
    [[self.submitBUtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissView];
    }];
    
    self.contentView.left = self.width;
    [UIView animateWithDuration:.25f animations:^{
        
        self.contentView.left = leftSpace;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
    } completion:^(BOOL finished) {
        
    }];

}

- (void)dismissView{
    
    [UIView animateWithDuration:.25f animations:^{
        
        self.contentView.left = self.width;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        [brandView removeFromSuperview];
        brandView = nil;
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    brandItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandItemCell" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BrandItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BrandItemHeaderView" forIndexPath:indexPath];
        return headerView;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
