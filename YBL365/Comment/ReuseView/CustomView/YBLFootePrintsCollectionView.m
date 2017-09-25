
//
//  YBLFootePrintsCollectionView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFootePrintsCollectionView.h"
#import "HJCarouselViewLayout.h"
#import "YBLGoodModel.h"

@interface YBLFootPrintsGoodCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, strong) UIView *backView;

@end

@implementation YBLFootPrintsGoodCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHotListGoodUI];
    }
    return self;
}

- (void)createHotListGoodUI{
    
    CGFloat wi = self.width;
    self.backgroundColor = [UIColor whiteColor];

    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wi, wi)];
    [self.contentView addSubview:goodsImageView];
    self.goodsImageView = goodsImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.left+10, CGRectGetMaxY(goodsImageView.frame)+5, goodsImageView.width-10, (self.height-wi)/2)];
    nameLabel.numberOfLines = 2;
    nameLabel.font = YBLFont(13);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = YBLColor(40, 40, 40, 1);;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, goodsImageView.width, (self.height-wi)/2-10)];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    self.backView = [[UIView alloc] initWithFrame:[self bounds]];
    self.backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.contentView addSubview:self.backView];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLGoodModel *model = (YBLGoodModel *)itemModel;
    [self.goodsImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:smallImagePlaceholder];
    self.nameLabel.text = model.title;
    self.priceLabel.attributedText = [NSString price:[NSString stringWithFormat:@"%.2f",model.price.doubleValue] color:YBLThemeColor font:20];
}

@end;

@interface YBLFootePrintsCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger currentIndex;
    BOOL isNoFirst;
}
@property (nonatomic, strong) HJCarouselViewLayout *carouseLayout;

@end

@implementation YBLFootePrintsCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame collectionViewLayout:self.carouseLayout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[YBLFootPrintsGoodCell class] forCellWithReuseIdentifier:@"YBLFootPrintsGoodCell"];
        
    }
    return self;
}

- (HJCarouselViewLayout *)carouseLayout{
    if (!_carouseLayout) {
        _carouseLayout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
        _carouseLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat width = ItemWidth;
        CGFloat hi = ItemHeight;
        _carouseLayout.itemSize = CGSizeMake(width, hi);
        WEAK
        _carouseLayout.scrollToIndexBlock = ^(NSInteger index){
            STRONG
            currentIndex = index;
            BLOCK_EXEC(self.footerPrintsScollToIndexBlock,index);
        };
    }
    return _carouseLayout;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBLFootPrintsGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLFootPrintsGoodCell" forIndexPath:indexPath];
    YBLGoodModel *good = self.dataArray[indexPath.row];
    [cell updateItemCellModel:good];
    if (!isNoFirst) {
        cell.backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    isNoFirst = YES;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     YBLGoodModel *goodModel = self.dataArray[indexPath.row];
    BLOCK_EXEC(self.didSelectItemBlock,goodModel,indexPath);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *array = [self indexPathsForVisibleItems];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        YBLFootPrintsGoodCell *goodCell = (YBLFootPrintsGoodCell *)[self cellForItemAtIndexPath:indexPath];
        if(currentIndex == indexPath.row){
            goodCell.backView.backgroundColor = [UIColor clearColor];
        }else{
            goodCell.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        }
    }];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"footPrint";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有浏览足迹哟~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(17),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)checkNull {

    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")]) {
            subView.left = -self.width/4;
        }
    }
}

@end
