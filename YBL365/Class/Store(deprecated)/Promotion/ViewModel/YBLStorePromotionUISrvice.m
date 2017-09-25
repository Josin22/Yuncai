//
//  YBLStorePromotionUISrvice.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStorePromotionUISrvice.h"
#import "YBLStoreGoodsCell.h"

@implementation YBLStorePromotionUISrvice

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentY = scrollView.contentOffset.y;
    
    if (self.scrollYBlock) {
        self.scrollYBlock(contentY,scrollView);
    }
}

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if (self.scrollYBlock) {
//        self.scrollYBlock(velocity.y);
//    }
//    
//}



#pragma mark -
#pragma mark  colleoction datasource/delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLStoreGoodsCell *storeGoodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsCell" forIndexPath:indexPath];
    return storeGoodsCell;
}

#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((YBLWindowWidth-15)/2, YBLWindowWidth/2 + 52);
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

@end
