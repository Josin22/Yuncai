//
//  YBLStoreHomeUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreHomeUIService.h"
#import "YBLHomeBannerCell.h"
#import "YBLStoreGoodsCell.h"

@interface YBLStoreHomeUIService ()
@property (nonatomic, strong) NSMutableArray * cellArray;
@end

@implementation YBLStoreHomeUIService

#pragma mark -
#pragma mark  colleoction datasource/delegate

- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        //1
        NSArray *sectionBanner = @[
                                 @{@"cell":@"YBLHomeBannerCell"},
                                 ];
        [_cellArray addObject:sectionBanner];
        NSArray *sectionGood = @[
                             @{@"cell":@"YBLStoreGoodsCell"},
                             ];
        [_cellArray addObject:sectionGood];
    }
    return _cellArray;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.cellArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.cellArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *cellName = self.cellArray[section][row][@"cell"];
    
    if ([cellName isEqualToString:@"YBLHomeBannerCell"]) {
        
        YBLHomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLHomeBannerCell" forIndexPath:indexPath];
        return [self getBannerCell:bannerCell indexPath:indexPath];
        
    } else if([cellName isEqualToString:@"YBLStoreGoodsCell"]){
        
        YBLStoreGoodsCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLStoreGoodsCell" forIndexPath:indexPath];
        return goodsCell;
        
    } else{
        return 0;
    }
    
}


#pragma mark - cell

- (YBLHomeBannerCell *)getBannerCell:(YBLHomeBannerCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section  = indexPath.section;
    
    UICollectionReusableView *reusableview = nil;
    
    NSString *cellName = self.cellArray[section][0][@"cell"];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]&&([cellName isEqualToString:@"YBLStoreGoodsCell"])) {
        
//        YBLModuleTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                            withReuseIdentifier:@"YBLModuleTitleView"
//                                                                                   forIndexPath:indexPath];
//        
//        reusableview =  [self getHeaderView:headerView indexPath:indexPath];
        
    }
    return reusableview;
}

#pragma mark - header view

//- (YBLModuleTitleView *)getHeaderView:(YBLModuleTitleView *)view indexPath:(NSIndexPath *)indexPath{
//    
//    [view updateModuleTitleImageUrl:tempHeaderArray[indexPath.section-1]];
//    
//    return view;
//}


#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *cellName = self.cellArray[section][row][@"cell"];
    
    if ([cellName isEqualToString:@"YBLHomeBannerCell"]) {
        
        return CGSizeMake(YBLWindowWidth, [YBLHomeBannerCell getBannerCellHeight]);
        
    } else if([cellName isEqualToString:@"YBLStoreGoodsCell"]){
        
        return CGSizeMake((YBLWindowWidth-15)/2, YBLWindowWidth/2 + 52);
        
    } else {
        return CGSizeZero;
    }
    
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    
    NSString *cellName = self.cellArray[section][@"cell"];
    
    if ([cellName isEqualToString:@"YBLStoreGoodsCell"]||[cellName isEqualToString:@"YBLStoreGoodsCell"]){
        return  CGSizeMake(YBLWindowWidth, 50);
    }
    return CGSizeZero;
}

@end
