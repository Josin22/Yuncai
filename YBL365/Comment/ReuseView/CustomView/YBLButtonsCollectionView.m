//
//  YBLButtonsCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLButtonsCollectionView.h"
#import "YBLCompanyTypesItemModel.h"

@interface YBLButtonsItemCell :UICollectionViewCell

@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation YBLButtonsItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = [self bounds];
    [itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    [itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    itemButton.titleLabel.numberOfLines = 0;
    itemButton.titleLabel.font = YBLFont(14);
    itemButton.layer.cornerRadius = 3;
    itemButton.layer.masksToBounds = YES;
    [self.contentView addSubview:itemButton];
    self.itemButton = itemButton;

}

@end

@interface YBLButtonsCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) ButtonsChooseStyle chooseStyle;

@property (nonatomic, assign) ButtonsHasAllSelect hasAllSelect;

@end

@implementation YBLButtonsCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                  chooseStyle:(ButtonsChooseStyle)chooseStyle
                 hasAllSelect:(ButtonsHasAllSelect)hasAllSelect{
    
    if (self == [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _hasAllSelect = hasAllSelect;
        _chooseStyle = chooseStyle;
        
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = YBLColor(245, 245, 245, 1);
        [self registerClass:NSClassFromString(@"YBLButtonsItemCell") forCellWithReuseIdentifier:@"YBLButtonsItemCell"];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    if (_hasAllSelect == ButtonsHasAllSelectYES) {
        YBLCompanyTypesItemModel *allModel = [YBLCompanyTypesItemModel new];
        allModel.title = @"全部";
        [_dataArray insertObject:allModel atIndex:0];
    }
    UICollectionViewFlowLayout *laayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat fin_hi = ceil((double)_dataArray.count/3)*(laayout.itemSize.height+space);
    self.height = fin_hi;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLButtonsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLButtonsItemCell"
                                                                         forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    YBLCompanyTypesItemModel *model = self.dataArray[row];
    cell.itemButton.selected = model.isSelect;
    [cell.itemButton setTitle:model.title forState:UIControlStateNormal];
    if (_hasAllSelect == ButtonsHasAllSelectYES&&row == 0) {
        [cell.itemButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    } else {
        [cell.itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    }
    WEAK
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (_hasAllSelect == ButtonsHasAllSelectYES&&row == 0) {
            model.isAllSelect = !model.isAllSelect;
            NSInteger index = 0;
            for (YBLCompanyTypesItemModel *item_model in self.dataArray) {
                if (index!=0) {
                    item_model.isSelect = model.isAllSelect;
                }
                index++;
            }
            [self jsReloadData];
        } else {
            model.isSelect = !model.isSelect;
            [UIView performWithoutAnimation:^{
                [self reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];

    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger row = indexPath.row;
//    YBLCompanyTypesItemModel *model = self.dataArray[row];
//    
//}

@end
