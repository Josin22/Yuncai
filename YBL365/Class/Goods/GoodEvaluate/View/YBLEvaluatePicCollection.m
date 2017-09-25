//
//  YBLEvaluatePicCollection.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEvaluatePicCollection.h"
#import "YBLGoodsEvaluateImageCell.h"

@interface YBLEvaluatePicCollection ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YBLEvaluatePicCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
     
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:NSClassFromString(@"YBLGoodsEvaluateImageCell") forCellWithReuseIdentifier:@"YBLGoodsEvaluateImageCell"];
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [self jsReloadData];
}

#pragma mark - collection data source / delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodsEvaluateImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLGoodsEvaluateImageCell" forIndexPath:indexPath];
    
    return [self getSeckillCell:cell indexPath:indexPath];
}


#pragma mark - cell

- (YBLGoodsEvaluateImageCell *)getSeckillCell:(YBLGoodsEvaluateImageCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    [cell.picImageView js_alpha_setImageWithURL:[NSURL URLWithString:_dataArray[row]] placeholderImage:smallImagePlaceholder];
    
    return cell;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodsEvaluateImageCell *yp_cell = (YBLGoodsEvaluateImageCell *)[self cellForItemAtIndexPath:indexPath];
    
    BLOCK_EXEC(self.evaluatePicCollectionDidSelectBlock,indexPath.row,yp_cell.picImageView);
    
}

@end
