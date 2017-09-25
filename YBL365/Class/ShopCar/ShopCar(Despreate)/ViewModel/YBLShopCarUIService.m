//
//  YBLShopCarUIService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarUIService.h"
#import "YBLShopCarLoginHeadView.h"
#import "YBLLoginViewController.h"
#import "YBLShopCarHeaderView.h"
#import "YBLShopCarGoodCell.h"
#import "YBLShopCarFootView.h"
#import "YBLHomeRecommendGoodCell.h"
#import "YBLShopCarRecommendGoodsCell.h"
#import "YBLShopCarTempGoodModel.h"
#import "YBLUpButton.h"
#import "YBLShopCarExpressCell.h"
#import "YBLShopCarItemTotalCell.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLNavigationViewController.h"

@interface YBLShopCarUIService ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLogin;

//推荐数组
@property (nonatomic, strong) NSArray *recommendArray;
//购物车数据
@property (nonatomic, strong) NSArray *carGoodArray;

@property (nonatomic, assign) ShopCarType carType;


@property (nonatomic, strong) YBLUpButton *upButton;

@end

@implementation YBLShopCarUIService



- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.shopCarVC.view.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YBLShopCarHeaderView class] forHeaderFooterViewReuseIdentifier:@"headId"];
        [_tableView registerClass:[YBLShopCarGoodCell class] forCellReuseIdentifier:@"cellId1"];
        [_tableView registerClass:[YBLShopCarRecommendGoodsCell class] forCellReuseIdentifier:@"cellId2"];
        [_tableView registerClass:[YBLShopCarExpressCell class] forCellReuseIdentifier:@"expressCellId"];
        [_tableView registerClass:[YBLShopCarItemTotalCell class] forCellReuseIdentifier:@"totalCellId"];
    }
    return _tableView;
}

//修改tableView的高度
- (void)changeTableViewHeight:(CGFloat)height {
    self.tableView.height = height;
    NSArray *VSs = self.shopCarVC.navigationController.childViewControllers;
    if (VSs[0] == self.shopCarVC) {
        self.upButton.top = height - 50 - 49;
    }else{
        self.upButton.top = height - 50;
    }
    
}

//根据是否是编辑状态修改tableView
- (void)updateWithCarType:(ShopCarType )carType {
    self.carType = carType;
    if (carType == ShopCarTypeEdite) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
    }else{
        [self changeUIWithIslogin:self.isLogin];
    }
    
    [self.tableView reloadData];
}


//根据是否登录购物车是否有数据改变UI
- (void)changeUIWithIslogin:(BOOL )isLogin {
    self.isLogin = isLogin;
    if (isLogin) {
        if([YBLShopCarModel shareInstance].carNumber == 0) {
            YBLShopCarLoginHeadView *headView = [[YBLShopCarLoginHeadView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 70+10)];
            [headView showNoGoodView];
            self.tableView.tableHeaderView = headView;
            __weak typeof (self)weakSelf = self;
            [[headView.homeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [weakSelf.shopCarVC.tabBarController setSelectedIndex:0];
            }];
        }else{
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
        }
    }else {
        NSInteger height = 32 + 10;
        if([YBLShopCarModel shareInstance].carNumber == 0) height = 102 + 10;
        YBLShopCarLoginHeadView *headView = [[YBLShopCarLoginHeadView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, height)];
        [headView showLoginView];
        if([YBLShopCarModel shareInstance].carNumber == 0) [headView showNoGoodView];
        self.tableView.tableHeaderView = headView;
        WEAK
        //登录
        [[headView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            YBLLoginViewController *loginVC = [[YBLLoginViewController alloc] init];
            YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:loginVC];
            [self.shopCarVC presentViewController:nav animated:YES completion:^{
                
            }];
           
        }];
        //去首页逛逛
        [[headView.homeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self.shopCarVC.tabBarController setSelectedIndex:0];
            [self.shopCarVC.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
}


- (void)setShopCarVC:(YBLShopCarViewController *)shopCarVC {
    _shopCarVC = shopCarVC;
    [self.shopCarVC.view addSubview:self.tableView];
    
    self.upButton = [YBLUpButton showInView:self.shopCarVC.view center:CGPointMake(self.shopCarVC.view.width - 30, self.shopCarVC.view.height-49 - 30) scrollView:self.tableView zeroTop:-64];
}


/**
 *  更新购物车数据
 *
 *  @param carGoodArray   商品数据
 *  @param recommendArray 推荐数据
 */
- (void)updateWithCarGoodArray:(NSArray *)carGoodArray recommendArray:(NSArray *)recommendArray {
    //先更新头视图
    [self changeUIWithIslogin:self.isLogin];
    self.carGoodArray = carGoodArray;
    self.recommendArray = recommendArray;
    [self.tableView reloadData];
}

//更新某一行数据
- (void)updateCellForIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



//更新所有
- (void)updateAllSections {
    [self.tableView reloadData];
}

//更新某一区
- (void)updateCellInSection:(NSInteger)section {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.carType == ShopCarTypeEdite) {
        return self.carGoodArray.count;
    }
    
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.carType == ShopCarTypeEdite) {
        NSInteger count = [[self.carGoodArray[section] objectForKey:@"items"] count] + 2;
        return count;
    }
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    if (section == sections-1) {
        return self.recommendArray.count/2;
    }else {
        NSInteger count = [[self.carGoodArray[section] objectForKey:@"items"] count] + 2;
        return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    if (indexPath.section == sections-1 && self.carType == ShopCarTypeNormal) {
        YBLShopCarRecommendGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId2" forIndexPath:indexPath];
        [cell updateWithLeftGood:[self.recommendArray objectAtIndex:indexPath.row*2] rightGood:[self.recommendArray objectAtIndex:indexPath.row*2+1]];
        
        return cell;
    }else {
        NSInteger count = [[self.carGoodArray[indexPath.section] objectForKey:@"items"] count]+2;
        if (indexPath.row == 0 || indexPath.row == count -1) {
            if (indexPath.row == 0) {
                YBLShopCarExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expressCellId" forIndexPath:indexPath];
                NSArray *goods = [self.carGoodArray[indexPath.section] objectForKey:@"items"];
                YBLShopCarTempGoodModel *good = goods[indexPath.row];
                cell.expressLabel.text = good.express;
                return cell;
            }else {
                YBLShopCarItemTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalCellId" forIndexPath:indexPath];
                
                return cell;
            }
        }else {
            YBLShopCarGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId1" forIndexPath:indexPath];
            [cell reloadBgView];
            NSArray *goods = [self.carGoodArray[indexPath.section] objectForKey:@"items"];
            YBLShopCarTempGoodModel *good = goods[indexPath.row-1];
            cell.goodImageView.image = [UIImage imageNamed:good.image];
            cell.goodNameLabel.text = good.name;
            cell.descLabel.text = good.desc;
            cell.priceLabel.attributedText = [NSString stringPrice:good.price color:[UIColor redColor] font:16 isBoldFont:NO appendingString:nil];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld", good.num];
            if (self.carType == ShopCarTypeNormal) {
                cell.checkAllButton.selected = good.isCheck;
            }else if (self.carType == ShopCarTypeEdite){
                cell.checkAllButton.selected = good.isDelete;
            }
            __weak typeof (self)weakSelf = self;
            __weak typeof (cell)weakCell = cell;
            [[[cell.checkAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                if (weakSelf.checkGoodBlock) {
                    weakSelf.checkGoodBlock(good,!weakCell.checkAllButton.selected,indexPath);
                }
            }];
            [[[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                if (weakSelf.deleteGoodBlock) {
                    weakSelf.deleteGoodBlock(good,indexPath.section);
                }
            }];
            [[[cell.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                good.num++;
                weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld", good.num];
                if (weakSelf.changeGoodNumberBlock) {
                    weakSelf.changeGoodNumberBlock();
                }
            }];
            
            [[[cell.subtractButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                if (good.num == 1) {
                    return;
                }
                good.num--;
                weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld", good.num];
                if (weakSelf.changeGoodNumberBlock) {
                    weakSelf.changeGoodNumberBlock();
                }
            }];
            
            return cell;
        
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.carType == ShopCarTypeEdite) {
        NSInteger count = [[self.carGoodArray[indexPath.section] objectForKey:@"items"] count] + 2;
        if (indexPath.row == 0 || indexPath.row == count -1) {
            return 50;
        }
        return 100;
    }
    
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    if (indexPath.section == sections-1) {
        
        return [YBLShopCarRecommendGoodsCell getCellHi];
//        return [YBLHomeRecommendGoodCell getRecommendGoodHeight]+2;
    }else {
        NSInteger count = [[self.carGoodArray[indexPath.section] objectForKey:@"items"] count] + 2;
        if (indexPath.row == 0 || indexPath.row == count -1) {
            return 50;
        }
        
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.carType == ShopCarTypeEdite) {
        return 10;
    }
    
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    if (section == sections-2 || section == sections-1) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.carType == ShopCarTypeEdite) {
        return [self renderSectionHeadViewInSection:section tableView:tableView];
    }
    
    
    NSInteger sections = self.carGoodArray.count + (self.recommendArray.count>0?1:0);
    if (section == sections-1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)];
        headView.backgroundColor = VIEW_BASE_COLOR;
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uniformRecommend_head_image_"]];
        [headView addSubview:image];
        image.frame = CGRectMake((YBLWindowWidth-376)/2, 0, 376, 40);
        return headView;
    }else {
        return [self renderSectionHeadViewInSection:section tableView:tableView];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YBLShopCarFootView *footerView = [[YBLShopCarFootView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
    footerView.backgroundColor = VIEW_BASE_COLOR;
    footerView.tableView = tableView;
    footerView.section = section;
    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    [self.shopCarVC.navigationController pushViewController:goodsDetailVC animated:YES];
}


- (UIView *)renderSectionHeadViewInSection:(NSInteger)section tableView:(UITableView *)tableView {
    YBLShopCarHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headId"];
    headView.shopNameLabel.text = [self.carGoodArray[section] objectForKey:@"shop"];
    NSArray *goods = [self.carGoodArray[section] objectForKey:@"items"];
    YBLShopCarTempGoodModel *good = [goods firstObject];
    NSString *expstr = good.expressMoney == 0 ? @"已免运费":[NSString stringWithFormat:@"物流费%ld元",good.expressMoney];
    headView.expressMoneyLabel.text = expstr;
    if (good.expressMoney == 0) {
        headView.expressMoneyLabel.textColor = YBLColor(80, 80, 80, 1.0);
    }else {
        headView.expressMoneyLabel.textColor = YBL_RED;
    }
    
    headView.contentView.backgroundColor = YBLColor(250, 250, 250, 1.0);
    BOOL isCheckAll = YES;
    for (YBLShopCarTempGoodModel *good in [self.carGoodArray[section] objectForKey:@"items"]) {
        if (self.carType == ShopCarTypeNormal) {
            if (good.isCheck == NO) {
                isCheckAll = NO;
                break;
            }
        }
        if (self.carType == ShopCarTypeEdite) {
            if (good.isDelete == NO) {
                isCheckAll = NO;
                break;
            }
        }
    }
    headView.checkAllButton.selected = isCheckAll;
    __weak typeof (self)weakSelf = self;
    __weak typeof (headView)weakHeadView = headView;
    [[[headView.checkAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        if (weakSelf.checkShopBlock) {
            weakSelf.checkShopBlock(weakSelf.carGoodArray[section],!weakHeadView.checkAllButton.selected,section);
        }
    }];
    return headView;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSArray *array = [self.tableView visibleCells];
    for (UITableViewCell *cell in array) {
        if ([cell isKindOfClass:[YBLShopCarGoodCell class]]) {
            [(YBLShopCarGoodCell *)cell reloadBgView];
        }
    }
}


- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end
