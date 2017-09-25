//
//  YBLStoreNewUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreNewUIService.h"
#import "YBLStoreGoodsCell.h"
#import "YBLStoreNewCollectionHeader.h"

@implementation YBLStoreNewUIService

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentY = scrollView.contentOffset.y;
    
    if (self.scrollYBlock) {
        self.scrollYBlock(contentY,scrollView);
    }
}


#pragma mark -
#pragma mark  colleoction datasource/delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YBLStoreGoodsCell *cellStore = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsCell" forIndexPath:indexPath];
    
    return cellStore;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        YBLStoreNewCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"YBLStoreNewCollectionHeader"
                                                                                   forIndexPath:indexPath];
        
        reusableview =  [self getHeaderView:headerView indexPath:indexPath];
        
    } 
    return reusableview;
}

#pragma mark - header view

- (YBLStoreNewCollectionHeader *)getHeaderView:(YBLStoreNewCollectionHeader *)view indexPath:(NSIndexPath *)indexPath {
    
//    [view updateModuleTitleImageUrl:tempHeaderArray[indexPath.section-1]];
    
    return view;
}


#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((YBLWindowWidth-15)/2, YBLWindowWidth/2 + 52);
    
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(YBLWindowWidth, 30);

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 5);//分别为上、左、下、右
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
