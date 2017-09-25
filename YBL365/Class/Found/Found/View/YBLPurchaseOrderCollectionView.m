//
//  YBLPurchaseOrderCollectionView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOrderCollectionView.h"
#import "YBLPurchaseOrderMMCell.h"
#import "YBLPurchaseTradeHeaderView.h"
#import "YBLPatResultHeaderView.h"
#import "YBLPayResultViewController.h"

@interface YBLPurchaseOrderCollectionView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) MMType type;

@end

@implementation YBLPurchaseOrderCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout MMType:(MMType)type{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _type = type;
        
        self.backgroundColor = YBLViewBGColor;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        [self registerClass:NSClassFromString(@"YBLPurchaseOrderMMCell") forCellWithReuseIdentifier:@"YBLPurchaseOrderMMCell"];
        if (_type == MMTypeHeaderMM) {
            [self registerClass:NSClassFromString(@"YBLPurchaseTradeHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLPurchaseTradeHeaderView"];
        }
    }
    return self;
}

#pragma mark - 

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLPurchaseOrderMMCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLPurchaseOrderMMCell" forIndexPath:indexPath];
    
    YBLPurchaseOrderModel *model = self.dataArray[indexPath.row];
    
    [cell updateItemCellModel:model];

    BOOL isSatisfy = [YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:indexPath.row];
    if (isSatisfy) {
        BLOCK_EXEC(self.viewPrestrainBlock,)
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader ) {
        if (_type == MMTypeHeaderMM) {
            YBLPurchaseTradeHeaderView *orderHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"YBLPurchaseTradeHeaderView" forIndexPath:indexPath];
            return orderHeader;
        } 
    }
    return 0;
}

#pragma mark
#pragma mark - UICollectionViewDelegateFlowLayout
//
///**
// *  代理方法计算每一个item的大小
// */
////定义每个UICollectionViewCell 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((YBLWindowWidth-15)/2, [YBLPurchaseOrderMMCell getItemCellHeightWithModel:nil]-4);
//}
////定义每个Section 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 0, 5);
//}
////返回头headerView的大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (_type == MMTypeHeaderMM) {
//        return CGSizeMake(YBLWindowWidth, [YBLPurchaseTradeHeaderView getMMTradeHeaderViewHeight]);
//    } 
//    return CGSizeZero;
//}
////返回头footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeZero;
//}
////每个section中不同的行之间的行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}
////每个item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBLPurchaseOrderModel *model = self.dataArray[indexPath.row];
    BLOCK_EXEC(self.orderMMCollectionViewRowSelectblock,model);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    BLOCK_EXEC(self.orderMMCollectionViewScrollBlock,scrollView);
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据,请稍后再试~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return kNavigationbarHeight;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end
