
//
//  YBLStoreGoodsUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreGoodsUIService.h"
#import "YBLStoreGoodsCell.h"
#import "YBLStoreGoodsListCell.h"

@implementation YBLStoreGoodsUIService

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentY = scrollView.contentOffset.y;
    
    if (self.scrollYBlock) {
        self.scrollYBlock(contentY,scrollView);
    }
}

#pragma mark -
#pragma mark  colleoction datasource/delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isShop) {
        if (_isChangeList) {
            
            YBLStoreGoodsCell *cellStore = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsCell" forIndexPath:indexPath];
            
            return cellStore;
        }
        
        YBLStoreGoodsListCell *cellGoods = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsListCell" forIndexPath:indexPath];
        return cellGoods;
        
    }
    return 0;
    
}


#pragma mark - cell

#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_isShop) {
        if (_isChangeList) {
            return CGSizeMake((YBLWindowWidth-15)/2, YBLWindowWidth/2 + 52);
        }
        return CGSizeMake(YBLWindowWidth, 105);
    }
    return CGSizeZero;
    
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (!_isShop) {
        if (_isChangeList) {
            return 5;
        }
        return 0;
    }
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (!_isShop) {
        if (_isChangeList) {
            return UIEdgeInsetsMake(5, 5, 0, 5);
        }
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (!_isShop) {
        if (_isChangeList) {
            return 5;
        }
        return 0;
    }
    return 0;
}

@end
