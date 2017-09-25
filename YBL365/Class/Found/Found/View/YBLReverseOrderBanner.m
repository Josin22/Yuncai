//
//  YBLReverseOrderBanner.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLReverseOrderBanner.h"
#import "YBLPurchaseDataCountModel.h"
#import "iCarousel.h"
#import "TAPageControl.h"

@implementation YBLReverseOrderBannerModel

@end

@interface ReverseBannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;

//@property (nonatomic, retain) UILabel *nummberLabel;

@property (nonatomic, strong) UILabel *animationNummberLabel;

@property (nonatomic, strong) UIButton *categoryButton;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ReverseBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    CGFloat hi = self.height/4;
    
    UIImageView *leftImageArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_left_arrow"]];
    leftImageArrowView.frame = CGRectMake(space, 0, 20, 41);
    leftImageArrowView.centerY = self.height/2-5;
    [self addSubview:leftImageArrowView];
    
    UIImageView *rightImageArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_right_arrow"]];
    rightImageArrowView.frame = CGRectMake(self.width-space-leftImageArrowView.width, leftImageArrowView.top, leftImageArrowView.width, leftImageArrowView.height);
    [self addSubview:rightImageArrowView];
    
    UILabel *animationNummberLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageArrowView.right, 0, self.width-leftImageArrowView.right*2, hi+10)];
    animationNummberLabel.centerY = leftImageArrowView.centerY;
    CGFloat couuu = 0;
    if (IS_IPHONE_6PLUS) {
        couuu = ValueNummber;
    }
    animationNummberLabel.font = YBLBFont(30+couuu);
    animationNummberLabel.textColor = [UIColor whiteColor];
    animationNummberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:animationNummberLabel];
    self.animationNummberLabel = animationNummberLabel;
   
    
    CGFloat buttonWi = hi;
    
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [categoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    categoryButton.titleLabel.font = YBLFont(15+couuu);
    categoryButton.frame = CGRectMake(0, 0, buttonWi, hi);
    categoryButton.center = CGPointMake(self.width/2, self.height-space-hi/2);
    categoryButton.layer.masksToBounds = YES;
    categoryButton.layer.borderColor = [UIColor whiteColor].CGColor;
    categoryButton.layer.borderWidth = 0.5;
    categoryButton.layer.cornerRadius = 3;
    [self addSubview:categoryButton];
    self.categoryButton = categoryButton;
}

- (void)updateModel:(YBLReverseOrderBannerModel *)model{
    
    NSString *value = model.money;
    NSArray *compenArray = [value componentsSeparatedByString:@" "];
    NSInteger nummber = [compenArray[0] integerValue];
    NSString *other = compenArray[1];
    NSNumber *num = @(nummber);
    
    [self.animationNummberLabel fn_setNumber:num format:[@"%@" stringByAppendingString:other] formatter:nil];
    
    NSString *category = model.title;
    CGFloat couuu = 0;
    if (IS_IPHONE_6PLUS) {
        couuu = ValueNummber;
    }
    CGSize textSize = [category heightWithFont:YBLFont(17+couuu) MaxWidth:self.width];
    self.categoryButton.width = textSize.width+2*space;
    [self.categoryButton setTitle:category forState:UIControlStateNormal];
    self.categoryButton.height = textSize.height+5;
    self.categoryButton.centerX = self.width/2;
    self.categoryButton.centerY = self.height-space-self.categoryButton.height/2;
    
    NSString *bgName = model.image_name;
    self.bgImageView.image = [UIImage imageNamed:bgName];

    
}

- (void)setData:(NSMutableArray *)data{
    
    NSString *value = data[0];
    NSArray *compenArray = [value componentsSeparatedByString:@" "];
    NSInteger nummber = [compenArray[0] integerValue];
    NSString *other = compenArray[1];
    NSNumber *num = @(nummber);
    
    [self.animationNummberLabel fn_setNumber:num format:[@"%@" stringByAppendingString:other] formatter:nil];
    
    NSString *category = data[1];
    CGFloat couuu = 0;
    if (IS_IPHONE_6PLUS) {
        couuu = ValueNummber;
    }
    CGSize textSize = [category heightWithFont:YBLFont(17+couuu) MaxWidth:self.width];
    self.categoryButton.width = textSize.width+2*space;
    [self.categoryButton setTitle:category forState:UIControlStateNormal];
    self.categoryButton.height = textSize.height+5;
    self.categoryButton.centerX = self.width/2;
    self.categoryButton.centerY = self.height-space-self.categoryButton.height/2;
    NSString *bgName = data[2];
    self.bgImageView.image = [UIImage imageNamed:bgName];
}

@end

@interface YBLReverseOrderBanner ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *bannerCollectionView;

@property (nonatomic, strong) TAPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YBLReverseOrderBanner

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{

    
    [self addSubview:self.bannerCollectionView];
    [self addSubview:self.pageControl];

}

- (void)setPurchaseDataCountModel:(YBLPurchaseDataCountModel *)purchaseDataCountModel{
    _purchaseDataCountModel = purchaseDataCountModel;
    
    if (!_purchaseDataCountModel) {
        return;
    }
    self.dataArray = [NSMutableArray array];

    /* 1 */
    [self.dataArray addObject:[self getBannarModelWithMoney:[NSString stringWithFormat:@"%ld 元",(long)_purchaseDataCountModel.all_order_price.integerValue]
                                                      title:@"采购总金额"
                                                  imageName:@"banner_bg4"]];
    /* 2 */
    [self.dataArray addObject:[self getBannarModelWithMoney:[NSString stringWithFormat:@"%ld 件",(long)_purchaseDataCountModel.all_quantity.integerValue]
                                                      title:@"采购总件数"
                                                  imageName:@"banner_bg3"]];
    /*3  */
    [self.dataArray addObject:[self getBannarModelWithMoney:[NSString stringWithFormat:@"%ld 元",(long)_purchaseDataCountModel.all_complete_order_price.integerValue]
                                                      title:@"成交总金额"
                                                  imageName:@"banner_bg1"]];

    /* 4 */
    [self.dataArray addObject:[self getBannarModelWithMoney:[NSString stringWithFormat:@"%ld 件",(long)_purchaseDataCountModel.all_complete_quantity.integerValue]
                                                      title:@"成交总件数"
                                                  imageName:@"banner_bg2"]];
    
    /* 5 */
    [self.dataArray addObject:[self getBannarModelWithMoney:[NSString stringWithFormat:@"%ld 天",(long)_purchaseDataCountModel.days.integerValue]
                                                      title:@"上线天数"
                                                  imageName:@"banner_bg5"]];
    
    
    self.pageControl.numberOfPages = self.dataArray.count;
    
    [self.bannerCollectionView jsReloadData];
    
    [self addTimer];
    
}

- (YBLReverseOrderBannerModel *)getBannarModelWithMoney:(NSString *)money title:(NSString *)title imageName:(NSString *)imageName{
    
    YBLReverseOrderBannerModel *model = [YBLReverseOrderBannerModel new];
    model.money = money;
    model.title = title;
    model.image_name = imageName;
    
    return model;
}

/*
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@[@"168168168168 元",@"成交总金额",@"banner_bg1"]];
        [_dataArray addObject:@[@"188888888888 件",@"成交总件数",@"banner_bg2"]];
        [_dataArray addObject:@[@"282828282828 件",@"采购总件数",@"banner_bg3"]];
        [_dataArray addObject:@[@"686868686868 元",@"采购总金额",@"banner_bg4"]];
        [_dataArray addObject:@[@"888 天",@"上线天数",@"banner_bg5"]];
    }
    return _dataArray;
}
*/
- (TAPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _pageControl.centerX = self.width/2;
        _pageControl.dotImage = [UIImage imageNamed:@"YCMainPage_Banner_Index"];
        _pageControl.currentDotImage = [UIImage imageNamed:@"YCMainPage_Banner_Index_Selected"];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = self.dataArray.count;
    }
    return _pageControl;
}

- (UICollectionView *)bannerCollectionView
{
    if (!_bannerCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.itemSize = self.bounds.size;
        _bannerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _bannerCollectionView.pagingEnabled = YES;
        _bannerCollectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _bannerCollectionView.showsHorizontalScrollIndicator = NO;
        _bannerCollectionView.scrollsToTop = NO;
        _bannerCollectionView.backgroundColor = [UIColor whiteColor];
        _bannerCollectionView.delegate = self;
        _bannerCollectionView.dataSource = self;
        // 注册cell
        [_bannerCollectionView registerClass:[ReverseBannerCell class] forCellWithReuseIdentifier:@"ReverseBannerCell"];
    }
    return _bannerCollectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReverseBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReverseBannerCell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    YBLReverseOrderBannerModel *model = self.dataArray[row];
    
    [cell updateModel:model];
    
    return cell;
}


//添加定时器
- (void)addTimer {
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//删除定时器
- (void)removeTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)nextImage {
    if (!self.timer) {
        return;
    }
    if (self.dataArray.count==0) {
        return;
    }
    NSInteger currentPage = self.pageControl.currentPage;
    currentPage += 1;
    if (currentPage == self.dataArray.count) {
        currentPage = 0;
        [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else {
        [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.dataArray.count;
    self.pageControl.currentPage =page;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /*
    CGFloat scrollW = self.bannerCollectionView.frame.size.width;
    NSInteger currentPage = self.bannerCollectionView.contentOffset.x / scrollW;

    self.pageControl.currentPage = currentPage;
    */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self addTimer];
}


@end
