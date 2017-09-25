
//
//  YBLGoodsBannerView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsBannerView.h"
#import "YYWebImage.h"

@interface YBLGoodsBannerPageText : UIView

@property (nonatomic, copy)   NSString *PageText;

@property (nonatomic, strong) UILabel *fontBannerPageTextLabel;
 
@property (nonatomic, strong) UILabel *backBannerPageTextLabel;


@end

@implementation YBLGoodsBannerPageText

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect newFrame = [self frame];
        CGFloat hi = newFrame.size.height;
        CGFloat wi = newFrame.size.width;
        newFrame.size.width = hi>wi?hi:wi;
        self.frame = newFrame;
        
        self.backgroundColor = YBLColor(198, 198, 204, 0.8);
        self.layer.cornerRadius = self.width/2;
        self.layer.masksToBounds = YES;
        
        self.fontBannerPageTextLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        self.fontBannerPageTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.fontBannerPageTextLabel];
        
        self.backBannerPageTextLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        self.backBannerPageTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.backBannerPageTextLabel];
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0/500.0;
        self.backBannerPageTextLabel.layer.zPosition = self.width;
        transform = CATransform3DRotate(transform,DEGREES_TO_RADIANS(180), 0, 1, 0);
        [self.backBannerPageTextLabel.layer setTransform:transform];
        self.backBannerPageTextLabel.hidden = YES;
        
    }
    return self;
}
- (void)setPageText:(NSString *)PageText{
    _PageText = PageText;
    NSInteger gangLoc = [PageText rangeOfString:@"/"].location;
    BOOL isHas =  gangLoc == NSNotFound;
    NSAssert(isHas == NO, @"文字显示格式要带/");
    NSMutableAttributedString *muString = [[NSMutableAttributedString alloc] initWithString:PageText];
    [muString addAttributes:@{NSFontAttributeName:YBLFont(20),NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, gangLoc)];
    [muString addAttributes:@{NSFontAttributeName:YBLFont(12),NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(gangLoc, PageText.length-gangLoc)];
    self.fontBannerPageTextLabel.attributedText = muString;
    self.backBannerPageTextLabel.attributedText = muString;
}

@end

@interface GoodsBannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;

@end

@implementation GoodsBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.goodsImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    self.goodsImageView.backgroundColor = YBLViewBGColor;
    [self addSubview:self.goodsImageView];
}

@end


@interface YBLGoodsBannerView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray         *upDwonSiganlArray;
@property (nonatomic, strong) UICollectionView       *bannerCollectionView;
@property (nonatomic, strong) YBLGoodsBannerPageText *bannerPageText;
@property (nonatomic, assign) GoodsBannerViewType    goodsBannerViewType;

@end

@implementation YBLGoodsBannerView
 
- (instancetype)initWithFrame:(CGRect)frame
                imageURLArray:(NSArray *)imageURLArray
          goodsBannerViewType:(GoodsBannerViewType)goodsBannerViewType{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageURLArray = imageURLArray;
        _goodsBannerViewType = goodsBannerViewType;
        
        [self handleUpDownSignalArray];
        
        [self addSubview:self.bannerCollectionView];
        [self addSubview:self.bannerPageText];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame imageURLArray:nil];
}

- (instancetype)initWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray{
    
    return [self initWithFrame:frame
                 imageURLArray:imageURLArray
           goodsBannerViewType:GoodsBannerViewTypeGoodDetailBanner];
}

#pragma mark -

- (NSMutableArray *)upDwonSiganlArray{
    
    if (!_upDwonSiganlArray) {
        _upDwonSiganlArray = [NSMutableArray array];
    }
    return _upDwonSiganlArray;
}

- (void)handleUpDownSignalArray{
    
    if (self.upDwonSiganlArray.count>0) {
        [self.upDwonSiganlArray removeAllObjects];
    }
    for (int i = 0; i < self.imageURLArray.count; i++) {
        [self.upDwonSiganlArray addObject:i%2 == 0?@YES:@NO];
    }
    self.bannerPageText.PageText = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageURLArray.count];
    
    if ([self.delegate respondsToSelector:@selector(banner:currentItemAtIndex:)]) {
        [self.delegate banner:self currentItemAtIndex:0];
    }
}

- (void)setImageURLArray:(NSArray *)imageURLArray{
    _imageURLArray = imageURLArray;
    
    if (_imageURLArray.count==0) {
        return;
    }
    
    [self handleUpDownSignalArray];

    [self.bannerCollectionView jsReloadData];
    
}

- (YBLGoodsBannerPageText *)bannerPageText{
    
    if (!_bannerPageText) {
        CGFloat whi = 40;
        if (_goodsBannerViewType == GoodsBannerViewTypeStoreBannerSetting) {
            whi = 50;
        }
        _bannerPageText = [[YBLGoodsBannerPageText alloc] initWithFrame:CGRectMake(self.width-15-whi, self.height-15-whi, whi, whi)];
        _bannerPageText.PageText = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageURLArray.count];
    }
    return _bannerPageText;
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
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        _bannerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _bannerCollectionView.pagingEnabled = YES;
        _bannerCollectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _bannerCollectionView.showsHorizontalScrollIndicator = NO;
        _bannerCollectionView.scrollsToTop = NO;
        if (_goodsBannerViewType == GoodsBannerViewTypeGoodDetailBanner) {
            _bannerCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        _bannerCollectionView.delegate = self;
        _bannerCollectionView.bounces = YES;
        _bannerCollectionView.dataSource = self;
        // 注册cell
        [_bannerCollectionView registerClass:[GoodsBannerCell class] forCellWithReuseIdentifier:@"GoodsBannerCell"];
    }
    return _bannerCollectionView;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    _currentPageIndex = currentPageIndex;
    
    self.bannerPageText.PageText = [NSString stringWithFormat:@"%@/%@",@(_currentPageIndex+1),@(self.imageURLArray.count)];
    if (_currentPageIndex%2==0) {
        //如果是偶数
        self.bannerPageText.fontBannerPageTextLabel.hidden = NO;
        self.bannerPageText.backBannerPageTextLabel.hidden = YES;
    }else{
        //如果是奇数
        self.bannerPageText.fontBannerPageTextLabel.hidden = YES;
        self.bannerPageText.backBannerPageTextLabel.hidden = NO;
    }

    [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPageIndex inSection:0]
                                      atScrollPosition:UICollectionViewScrollPositionNone
                                              animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsBannerCell" forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    NSString *plachoder;
    if (_goodsBannerViewType == GoodsBannerViewTypeStoreBannerSetting) {
        cell.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.goodsImageView.backgroundColor = [UIColor blackColor];
    } else {
        plachoder = smallImagePlaceholder;
    }

//    [cell.goodsImageView yy_setImageWithURL:[NSURL URLWithString:self.imageURLArray[row]]
//                                placeholder:[UIImage imageNamed:plachoder]
//                                    options:YYWebImageOptionSetImageWithFadeAnimation
//                                 completion:nil];
    [cell.goodsImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.imageURLArray[row]] placeholderImage:smallImagePlaceholder];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    double scale = offsetX/scrollView.width;
    NSInteger indexCount = (int)(scale);
    CGFloat du = scale*180;
    CATransform3D transform = CATransform3DIdentity;
    self.bannerPageText.layer.zPosition = 40;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DRotate(transform,DEGREES_TO_RADIANS(du), 0, 1, 0);
    [self.bannerPageText.layer setTransform:transform];
    
    CGFloat smallDu  = indexCount*180;
    CGFloat middleDu = ((indexCount)*2+1)*90;
    CGFloat bigDu = middleDu+90;
    BOOL isB = [self.upDwonSiganlArray[indexCount] boolValue];;
    if (du>middleDu&&du<bigDu) {

        self.bannerPageText.fontBannerPageTextLabel.hidden = isB;
        self.bannerPageText.backBannerPageTextLabel.hidden = !isB;
        self.bannerPageText.PageText = [NSString stringWithFormat:@"%@/%@",@(indexCount+2),@(self.upDwonSiganlArray.count)];
    } else if (du<middleDu&&du>smallDu){

        self.bannerPageText.fontBannerPageTextLabel.hidden = !isB;
        self.bannerPageText.backBannerPageTextLabel.hidden = isB;
        self.bannerPageText.PageText = [NSString stringWithFormat:@"%@/%@",@(indexCount+1),@(self.upDwonSiganlArray.count)];
    }

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger count_for_image = self.imageURLArray.count;
    CGFloat total_value = (float)(count_for_image-1)*self.width+scrollLimitSpace;
    if (offsetX >= total_value) {
        if ([self.delegate respondsToSelector:@selector(banner:scrollToLastItem:)]) {
            [self.delegate banner:self scrollToLastItem:count_for_image];
        }
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;

//    GoodsBannerCell *currentCell = (GoodsBannerCell *)[self.bannerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    if ([self.delegate respondsToSelector:@selector(banner:currentItemAtIndex:)]) {
        [self.delegate banner:self currentItemAtIndex:index];
    }
}

@end
