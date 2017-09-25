//
//  YBLChooseGoodLogisticsCompanyCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseGoodLogisticsCompanyCollectionView.h"
#import "YBlImageItemCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"

@interface YBLChooseGoodLogisticsCompanyCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YBLChooseGoodLogisticsCompanyCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:NSClassFromString(@"YBlImageItemCell") forCellWithReuseIdentifier:@"YBlImageItemCell"];
        
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
    
    NSInteger row = indexPath.row;
    id model = _dataArray[row];
    
    YBlImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBlImageItemCell" forIndexPath:indexPath];
    
    if ([model isKindOfClass:[YBLExpressCompanyItemModel class]]) {
        YBLExpressCompanyItemModel *new_model = (YBLExpressCompanyItemModel *)model;
        [cell.picImageView js_alpha_setImageWithURL:[NSURL URLWithString:new_model.avatar] placeholderImage:smallImagePlaceholder];
        cell.itemButton.selected = new_model.is_select;
        
    } else if ([model isKindOfClass:[YBLGoodModel class]]) {
        YBLGoodModel *new_model = (YBLGoodModel *)model;
        [cell.picImageView js_alpha_setImageWithURL:[NSURL URLWithString:new_model.avatar_url] placeholderImage:smallImagePlaceholder];
        cell.itemButton.selected = new_model.is_select;
    }
    WEAK
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([model isKindOfClass:[YBLExpressCompanyItemModel class]]) {
            YBLExpressCompanyItemModel *new_model = (YBLExpressCompanyItemModel *)model;
            [new_model setValue:@(!new_model.is_select) forKey:@"is_select"];
        } else if ([model isKindOfClass:[YBLGoodModel class]]) {
            YBLGoodModel *new_model = (YBLGoodModel *)model;
            [new_model setValue:@(!new_model.is_select) forKey:@"is_select"];
        }
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        BLOCK_EXEC(self.chooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock,model);
        [self reloadItemsAtIndexPaths:@[indexPath]];
    }];
    
    return cell;
}


@end
