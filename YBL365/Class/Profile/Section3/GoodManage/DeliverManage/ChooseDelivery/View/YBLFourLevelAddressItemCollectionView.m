//
//  YBLFourLevelAddressItemCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFourLevelAddressItemCollectionView.h"
#import "YBLFourLevelAddressItemCell.h"
#import "YBLAddressAreaModel.h"
#import "YBLAreaItemButton.h"

@interface YBLFourLevelAddressItemCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) TableType collectionType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation YBLFourLevelAddressItemCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout collectionType:(TableType)collectionType
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _collectionType = collectionType;
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:NSClassFromString(@"YBLFourLevelAddressItemCell") forCellWithReuseIdentifier:@"YBLFourLevelAddressItemCell"];
    }
    return self;
}

- (void)updateArray:(NSMutableArray *)dataArray Dict:(NSMutableDictionary *)dict{
    
    _dataArray = dataArray;
    _dataDict = dict;
    
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

    YBLFourLevelAddressItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLFourLevelAddressItemCell" forIndexPath:indexPath];
    
    [self configCell:cell path:indexPath];
    
    return cell;
}

- (void)configCell:(YBLFourLevelAddressItemCell *)cell path:(NSIndexPath *)path{
    
    NSInteger row = path.row;
    
    YBLAddressAreaModel *areaModel = _dataArray[row];
    [cell updateModel:areaModel];
    if ([[self.dataDict allKeys] containsObject:areaModel.id]) {
        cell.itemButton.selected = YES;
    } else {
        cell.itemButton.selected = NO;
    }
    if (_collectionType == tableTypeSXNoneArrow) {
        cell.itemButton.arrowButton.hidden = YES;
    }
    WEAK
    //选择
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        UIButton *itemButton = (UIButton *)x;
        itemButton.selected = !itemButton.selected;
        for (YBLAddressAreaModel *model in self.dataArray) {
            [model setValue:@(NO) forKey:@"isArrowSelect"];
        }
        [self updateWithIndex:row];
        [self jsReloadData];
        BLOCK_EXEC(self.fourLevelAddressItemCollectionViewCellDidSelectBlock,NO,itemButton.selected,areaModel);

    }];
    //箭头
    [[[cell.itemButton.arrowButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        UIButton *itemArrowButton = (UIButton *)x;
        itemArrowButton.selected = !itemArrowButton.selected;
        for (YBLAddressAreaModel *model in self.dataArray) {
            model.isArrowSelect = NO;
        }
        [areaModel setValue:@(itemArrowButton.selected) forKey:@"isArrowSelect"];
        [self updateWithIndex:row];
        [self jsReloadData];
        BLOCK_EXEC(self.fourLevelAddressItemCollectionViewCellDidSelectBlock,YES,itemArrowButton.selected,areaModel);
    }];
    
}

- (void)updateWithIndex:(NSInteger )index {
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    YBLAddressAreaModel *areaModel = _dataArray[row];
    CGSize areaSize = [areaModel.text heightWithFont:YBLFont(15) MaxWidth:200];
    CGFloat itemWi = areaSize.width+6+space+20;
    return CGSizeMake(itemWi, self.height);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end
