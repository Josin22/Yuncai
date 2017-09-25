//
//  YBLCategoryListService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryListService.h"
#import "YBLCategoryListViewController.h"
#import "YBLCategoryItemCell.h"
#import "YBLCategoryListICell.h"
#import "YBLUpButton.h"
#import "YBLCategoryListHeadView.h"
#import "YBLFilterBottomView.h"
#import "YBLBrandView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLFoucsStoreView.h"

@interface YBLCategoryListService ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) YBLCategoryListHeadView *headView;

@property (nonatomic, assign) CGFloat contentY;
@property (nonatomic, strong) YBLFilterBottomView *filterBottomView;
@property (nonatomic, assign) CategoryFilterType filterType;


@property (nonatomic, assign) BOOL isShowBottomFilterView;

@end

@implementation YBLCategoryListService

- (instancetype)init {
    if (self = [super init]) {
        self.contentY = -kNavigationbarHeight;
    }
    return self;
}


- (void)setIsList:(BOOL)isList {
    _isList = isList;
    [self.collectionView reloadData];
}

- (void)clearButtonState{
    self.headView.lastFilterButton.selected = NO;
    self.headView.isPrice = NO;
    self.headView.isSynthesis = NO;
    if (self.headView.lastFilterButton == self.headView.priceButton) {
        self.headView.priceButton.upImageView.image = [UIImage imageNamed:@"Mystow_up_normal_4x2_"];
        self.headView.priceButton.bottomImageView.image = [UIImage imageNamed:@"Mystow_down_normal_4x2_"];
    }
    self.isShowBottomFilterView = NO;
    [self.filterBottomView dismiss];
    [self clearSubButtonState];
}

- (void)clearSubButtonState {
    self.headView.bgView2.height = 29;
    self.headView.bgView2.backgroundColor = YBLColor(240, 240, 240, 1.0);
    self.headView.bgView2.layer.borderWidth = 0;
    self.headView.bgView3.height = 29;
    self.headView.bgView3.backgroundColor = YBLColor(240, 240, 240, 1.0);
    self.headView.bgView3.layer.borderWidth = 0;
    self.headView.bgView4.height = 29;
    self.headView.bgView4.backgroundColor = YBLColor(240, 240, 240, 1.0);
    self.headView.bgView4.layer.borderWidth = 0;
}


- (YBLFilterBottomView *)filterBottomView {
    if (!_filterBottomView) {
        _filterBottomView = [[YBLFilterBottomView alloc] initWithFrame:CGRectMake(0,self.headView.bottom,   YBLWindowWidth, YBLWindowHeight)];
        __weak typeof (self)weakSelf = self;
        _filterBottomView.filterDismissBlock = ^(){
            weakSelf.isShowBottomFilterView = NO;
            [weakSelf clearSubButtonState];
        };
    }
    return _filterBottomView;
}



- (YBLCategoryListHeadView *)headView {
    if (!_headView) {
        _headView = [[YBLCategoryListHeadView alloc] initWithFrame:CGRectMake(0, kNavigationbarHeight, YBLWindowWidth, 90)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.synthesisButton.selected = YES;
        __weak typeof (self)weakSelf = self;
        [[_headView.synthesisButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.headView.lastFilterButton == weakSelf.headView.synthesisButton) {
                weakSelf.headView.isSynthesis = !weakSelf.headView.isSynthesis;
                if (weakSelf.headView.isSynthesis) {
                    
                }else {
                    
                }
            }else {
                [weakSelf clearButtonState];
                weakSelf.headView.synthesisButton.selected = YES;
                weakSelf.headView.lastFilterButton = weakSelf.headView.synthesisButton;
            }
        }];
        [[_headView.salesButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.headView.lastFilterButton != weakSelf.headView.salesButton) {
                [weakSelf clearButtonState];
                weakSelf.headView.salesButton.selected = YES;
                weakSelf.headView.lastFilterButton = weakSelf.headView.salesButton;
            }
        }];
        
        [[_headView.priceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.headView.lastFilterButton != weakSelf.headView.priceButton) {
                [weakSelf clearButtonState];
                weakSelf.headView.priceButton.selected = YES;
                weakSelf.headView.priceButton.bottomImageView.image = [UIImage imageNamed:@"Mystow_down_selected_4x2_"];
                weakSelf.headView.lastFilterButton = weakSelf.headView.priceButton;
            }else {
                weakSelf.headView.isPrice = !weakSelf.headView.isPrice;
                if (weakSelf.headView.isPrice) {
                    weakSelf.headView.priceButton.bottomImageView.image = [UIImage imageNamed:@"Mystow_down_normal_4x2_"];
                    weakSelf.headView.priceButton.upImageView.image = [UIImage imageNamed:@"Mystow_up_selected_4x2_"];
                }else {
                    weakSelf.headView.priceButton.upImageView.image = [UIImage imageNamed:@"Mystow_up_normal_4x2_"];
                    weakSelf.headView.priceButton.bottomImageView.image = [UIImage imageNamed:@"Mystow_down_selected_4x2_"];
                }
            }
        }];
        [[_headView.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [YBLBrandView showBrandViewWithData:nil BrandSureHandle:^{
                
            }];
        }];
        [[_headView.descButtton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.headView.descButtton1.selected = !weakSelf.headView.descButtton1.selected;
            if (weakSelf.headView.descButtton1.selected) {
                weakSelf.headView.bgView1.layer.borderColor = [UIColor redColor].CGColor;
                weakSelf.headView.bgView1.layer.borderWidth = 0.5;
                weakSelf.headView.bgView1.backgroundColor = [UIColor whiteColor];
            }else {
                weakSelf.headView.bgView1.layer.borderWidth = 0;
                weakSelf.headView.bgView1.layer.borderColor = [UIColor clearColor].CGColor;
                weakSelf.headView.bgView1.backgroundColor = YBLColor(240, 240, 240, 1.0);
            }
        }];
        [[_headView.descButtton2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf clearSubButtonState];
            weakSelf.headView.bgView2.layer.borderWidth = 0.5;
            weakSelf.headView.bgView2.layer.borderColor = YBLColor(230, 230, 230, 1.0).CGColor;
            weakSelf.headView.bgView2.layer.backgroundColor = YBLColor(250, 250, 250, 1.0).CGColor;
            weakSelf.headView.bgView2.height = 45;
            if (weakSelf.isShowBottomFilterView) {
               [weakSelf.filterBottomView showWithFilterArray:@[@"酒鬼",@"五粮液",@"剑南春",@"茅台",@"二锅头",@"洋河蓝色经典",@"仰韶"] animation:NO];
            }else {
                 [weakSelf.filterBottomView showWithFilterArray:@[@"酒鬼",@"五粮液",@"剑南春",@"茅台",@"二锅头",@"洋河蓝色经典",@"仰韶"] animation:YES];
                [weakSelf.categoryListVC.view insertSubview:weakSelf.filterBottomView belowSubview:weakSelf.headView];
            }
            weakSelf.isShowBottomFilterView = YES;
           
        }];
        [[_headView.descButtton3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf clearSubButtonState];
            weakSelf.headView.bgView3.layer.borderWidth = 0.5;
            weakSelf.headView.bgView3.layer.borderColor = YBLColor(230, 230, 230, 1.0).CGColor;
            weakSelf.headView.bgView3.layer.backgroundColor = YBLColor(250, 250, 250, 1.0).CGColor;
            weakSelf.headView.bgView3.height = 45;
            if (weakSelf.isShowBottomFilterView) {
                [weakSelf.filterBottomView showWithFilterArray:@[@"红色",@"白色",@"蓝色",@"黄色",@"紫色",@"花白",@"青色",@"红色",@"白色",@"蓝色",@"黄色",@"紫色",@"花白",@"青色"] animation:NO];
            }else {
                [weakSelf.filterBottomView showWithFilterArray:@[@"红色",@"白色",@"蓝色",@"黄色",@"紫色",@"花白",@"青色",@"红色",@"白色",@"蓝色",@"黄色",@"紫色",@"花白",@"青色"] animation:YES];
                [weakSelf.categoryListVC.view insertSubview:weakSelf.filterBottomView belowSubview:weakSelf.headView];
            }
            weakSelf.isShowBottomFilterView = YES;
            
        }];
        [[_headView.descButtton4 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf clearSubButtonState];
            weakSelf.headView.bgView4.layer.borderWidth = 0.5;
            weakSelf.headView.bgView4.layer.borderColor = YBLColor(230, 230, 230, 1.0).CGColor;
            weakSelf.headView.bgView4.layer.backgroundColor = YBLColor(250, 250, 250, 1.0).CGColor;
            weakSelf.headView.bgView4.height = 45;
            if (weakSelf.isShowBottomFilterView) {
                [weakSelf.filterBottomView showWithFilterArray:@[@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml"] animation:NO];
            }else {
                [weakSelf.filterBottomView showWithFilterArray:@[@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml",@"500ml",@"666ml",@"234ml",@"kNavigationbarHeight5ml",@"123ml",@"333ml",@"3423ml"] animation:YES];
                [weakSelf.categoryListVC.view insertSubview:weakSelf.filterBottomView belowSubview:weakSelf.headView];
            }
            weakSelf.isShowBottomFilterView = YES;
            
        }];
        
        
    }
    return _headView;
}

- (void)dismissSubFilterView {
    
}




- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 90, YBLWindowWidth, self.categoryListVC.view.height-90) collectionViewLayout:layout];
        _collectionView.backgroundColor = VIEW_BASE_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YBLCategoryItemCell class] forCellWithReuseIdentifier:@"itemCell"];
        [_collectionView registerClass:[YBLCategoryListICell class] forCellWithReuseIdentifier:@"listCell"];
    }
    return _collectionView;
}

- (void)setCategoryListVC:(YBLCategoryListViewController *)categoryListVC {
    _categoryListVC = categoryListVC;
    [categoryListVC.view addSubview:self.collectionView];
    
    [categoryListVC.view addSubview:self.headView];
    
    [YBLUpButton showInView:self.categoryListVC.view center:CGPointMake(self.categoryListVC.view.width - 30, self.categoryListVC.view.height - 30) scrollView:self.collectionView zeroTop:-kNavigationbarHeight];
    [YBLUpButton showInView:self.categoryListVC.view center:CGPointMake(self.categoryListVC.view.width - 30, self.categoryListVC.view.height - 30 - 50) block:^{
        
    }];
}

- (void)updateWithGoodArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    [self.collectionView reloadData];
}


#pragma mark 
#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isList) {
        YBLCategoryListICell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
        id good = self.dataArray[indexPath.item];
        
        
        cell.goodImageView.image = [UIImage imageNamed:good[@"image"]];
        cell.goodNameLabel.text = good[@"name"];
        NSDictionary *type = [good[@"types"] firstObject];
        NSMutableAttributedString *attStr = [NSString stringPrice:type[@"price"] color:[UIColor redColor] font:16 isBoldFont:NO appendingString:nil];
        cell.priceLabel.attributedText = attStr;
        return cell;
    }else {
        YBLCategoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
        id good = self.dataArray[indexPath.item];
        [cell updateWithGood:good];
        
        return cell;
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isList) {
        return CGSizeMake(YBLWindowWidth, 120);
    }else {
        CGFloat width = (YBLWindowWidth-15)/2;
        CGFloat hi = (YBLWindowHeight-kNavigationbarHeight-2*space)/2;
        return CGSizeMake(width,hi);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (self.isList) {
        return 0;
    }
    return 5;
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.isList) {
        return 0;
    }
    return 5;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    if (self.isList) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5, 5, 0, 5);
    
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if (self.isList) {
//        return 0;
//    }else {
//        return 2.5;
//    }
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentY = scrollView.contentOffset.y;
    
    [YBLFoucsStoreView dismissFoucsView];
    
    if (contentY < -kNavigationbarHeight) {
        return;
    }
    
    if (contentY+scrollView.height >= scrollView.contentSize.height) {
        return;
    }
    
    if (contentY - self.contentY >= 30) {
        self.contentY = contentY;
        if (self.headView.top == kNavigationbarHeight) {
            [UIView animateWithDuration:.5f delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.headView.top = -90;
                                 self.collectionView.frame = self.categoryListVC.view.bounds;

            } completion:^(BOOL finished) {
                
            }];
//            [UIView animateWithDuration:.5f animations:^{
//                self.headView.top = -90;
//                self.collectionView.frame = self.categoryListVC.view.bounds;
//            }];
        }
    }else if (self.contentY - contentY >= 30){
        self.contentY = contentY;
        if (self.headView.top == -90) {
            [UIView animateWithDuration:.5f delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.headView.top = kNavigationbarHeight;
                                 self.collectionView.frame = CGRectMake(0, 90, YBLWindowWidth, self.categoryListVC.view.height-90);

                             } completion:^(BOOL finished) {
                                 
                             }];
//            [UIView animateWithDuration:.5f animations:^{
//                self.headView.top = kNavigationbarHeight;
//                self.collectionView.frame = CGRectMake(0, 90, YBLWindowWidth, self.categoryListVC.view.height-90);
//            }];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    [self.categoryListVC.navigationController pushViewController:goodsDetailVC animated:YES];
    
}


@end
