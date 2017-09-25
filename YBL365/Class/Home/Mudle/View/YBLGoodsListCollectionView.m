//
//  YBLGoodsListCollectionView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsListCollectionView.h"
#import "YBLCategoryItemCell.h"
#import "YBLTwotageMuduleViewController.h"
#import "YBLStoreTimeHeaderView.h"
#import "YBLStoreGoodsListCell.h"
#import "YBLStoreGoodsCell.h"
#import "YBLGoodListFlowLayout.h"

@interface YBLGoodsListCollectionView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) CollectionType collectionType;

@property (nonatomic, strong) YBLGoodGridFlowLayout *gridLayout;
@property (nonatomic, strong) YBLGoodListFlowLayout *rowLayout;

@end

@implementation YBLGoodsListCollectionView

- (instancetype)initWithFrame:(CGRect)frame
               collectionType:(CollectionType)type{
    
    return [self initWithFrame:frame
          collectionViewLayout:self.gridLayout
                CollectionType:type];
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
               CollectionType:(CollectionType)type{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _collectionType = type;
        
        [self setInit];
    }
    return self;
}

- (YBLGoodListFlowLayout *)rowLayout
{
    if (!_rowLayout) {
        YBLGoodListFlowLayout *flowLayout = [[YBLGoodListFlowLayout alloc] init];
        _rowLayout = flowLayout;
    }
    return _rowLayout;
}

- (YBLGoodGridFlowLayout *)gridLayout
{
    if (!_gridLayout) {
        YBLGoodGridFlowLayout *flowLayout = [[YBLGoodGridFlowLayout alloc] init];
        _gridLayout = flowLayout;
    }
    return _gridLayout;
}

- (void)setInit{
    
    self.backgroundColor = YBLViewBGColor;
    self.dataSource = self;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    [self registerClass:NSClassFromString(@"YBLCategoryItemCell") forCellWithReuseIdentifier:@"YBLCategoryItemCell"];
}

- (void)setIsListType:(BOOL)isListType{
    _isListType = isListType;
    
    if (_isListType) {
        self.collectionViewLayout = self.rowLayout;
//        [self setCollectionViewLayout:self.gridLayout animated:NO];
    } else {
        self.collectionViewLayout = self.gridLayout;
//        [self setCollectionViewLayout:self.rowLayout animated:NO];
    }
    
    [UIView performWithoutAnimation:^{
        [self reloadItemsAtIndexPaths:[self indexPathsForVisibleItems]];
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    for (YBLGoodModel *goodModel in _dataArray) {
        [goodModel handleAttPrice];
    }
//    [self jsReloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = indexPath.row;
    //普通商品
    YBLCategoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLCategoryItemCell" forIndexPath:indexPath];
    
    cell.isListType = _isListType;
    
    [cell updateItemCellModel:self.dataArray[row]];
    
    BOOL isSatisfy = [YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:row];
    if (isSatisfy) {
        BLOCK_EXEC(self.viewPrestrainBlock,)
    }
    
    
    return cell;
//    if (_collectionType == CollectionTypeNormalGood) {
//     
//        
//    }
    /*
    else if (_collectionType == CollectionTypeStoreGoodsHasHeader||_collectionType ==CollectionTypeStoreGoodsNoHeader){
        //店铺商品
        YBLStoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsCell" forIndexPath:indexPath];
        
        [cell updateGoodModel:self.dataArray[row]];
        
        return cell;
        
    }
    */
 
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = indexPath.row;
    id model = self.dataArray[row];
    BLOCK_EXEC(self.goodsListCollectionViewCellDidSelectBlock,indexPath,model)
    return;
    /*
        */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    BLOCK_EXEC(self.goodsListCollectionViewScrollWillBegainDrageBlock,scrollView)
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    BLOCK_EXEC(self.goodsListCollectionViewScrollBlock,scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    BLOCK_EXEC(self.goodsListCollectionViewScrollDidEndBlock,scrollView);
}

#pragma mark - empty

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_good";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉, 没有找到商品哦~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_collectionType == CollectionTypeNormalGood) {
        return -kNavigationbarHeight;
    } else {
        return kNavigationbarHeight;
    }
}


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}



@end
