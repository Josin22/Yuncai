//
//  YBLGoodsManageService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsManageService.h"
#import "YBLGoodsManageVC.h"
#import "YBLPopView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLAddGoodViewController.h"
#import "YBLAddNewGoodViewController.h"
#import "YBLVerifyGoodViewController.h"
#import "YBLGoodListManageTableView.h"
#import "YBLTextSegmentControl.h"
#import "YBLSeckillCategoryView.h"
#import "YBLEditGoodViewController.h"
#import "YBLGoodsManageItemButton.h"
#import "YBLGoodsManageViewModel.h"
#import "YBLChooseDeliveryViewController.h"
#import "YBLSettingPayShippingMentVC.h"

static NSInteger const tag_glTableView = 544;

@interface YBLGoodsManageService ()<UIScrollViewDelegate,YBLTextSegmentControlDelegate>

@property (nonatomic, strong) UIScrollView             *goodListScrollView;

@property (nonatomic, weak  ) YBLGoodsManageVC         *Vc;

@property (nonatomic, strong) YBLGoodsManageViewModel  *viewModel;

@property (nonatomic, strong) YBLTextSegmentControl    *textSegmentControl;

@property (nonatomic, strong) YBLGoodsManageItemButton *itemButton;

@property (nonatomic, strong) UIButton                 *saveButton;

@end

@implementation YBLGoodsManageService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel
{
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _Vc = (YBLGoodsManageVC *)VC;
        _viewModel = (YBLGoodsManageViewModel *)viewModel;
        
        _Vc.navigationItem.title = @"商品管理";
        
        [_Vc.view addSubview:self.textSegmentControl];
        [_Vc.view addSubview:self.goodListScrollView];
        [_Vc.view addSubview:self.itemButton];
        
        /**
         *  request
         */
        [self checkTableViewIsExsitWithIndex:0 isReload:YES];
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.textSegmentControl.enableSegment = !x.boolValue;
        }];
    }
    return self;
}

- (YBLGoodsManageItemButton *)itemButton{
    if (!_itemButton) {
        _itemButton = [[YBLGoodsManageItemButton alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-kNavigationbarHeight-buttonHeight, YBLWindowWidth, buttonHeight)
                                                           titleArray:@[@"批量设置商品物流",
                                                                        @"批量设置商品配送"]];
        WEAK
        _itemButton.goodsManageItemButtonClickBlock = ^(NSInteger index) {
            STRONG
            switch (index) {
                case 0:
                {//配送列表
                    YBLChooseDeliveryViewController *chooseDeliveryVC = [YBLChooseDeliveryViewController new];
                    [self.Vc.navigationController pushViewController:chooseDeliveryVC animated:YES];
                }
                    break;
                case 1:
                {//配送管理
                    YBLSettingPayShippingMentViewModel *viewModel = [YBLSettingPayShippingMentViewModel new];
                    viewModel.settingPayShippingMentVCType = SettingPayShippingMentVCTypeManyGoodChange;
                    YBLSettingPayShippingMentVC *payshippingVC = [YBLSettingPayShippingMentVC new];
                    payshippingVC.viewModel = viewModel;
                    [self.Vc.navigationController pushViewController:payshippingVC animated:YES];
                }
                    break;
                default:
                    break;
            }

        };
    }
    return _itemButton;
}

- (UIScrollView *)goodListScrollView{
    if (!_goodListScrollView) {
        _goodListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegmentControl.bottom, YBLWindowWidth, YBLWindowHeight-self.textSegmentControl.bottom)];
        _goodListScrollView.pagingEnabled = YES;
        _goodListScrollView.showsVerticalScrollIndicator = NO;
        _goodListScrollView.showsHorizontalScrollIndicator = NO;
        _goodListScrollView.backgroundColor = self.Vc.view.backgroundColor;
        _goodListScrollView.delegate = self;
        [_goodListScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.Vc.navigationController.interactivePopGestureRecognizer];
    }
    return _goodListScrollView;
}


- (YBLTextSegmentControl *)textSegmentControl{
    if (!_textSegmentControl) {
        _textSegmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)
                                                           TextSegmentType:TextSegmentTypeCategoryArrow];
        _textSegmentControl.delegate = self;
        WEAK
        _textSegmentControl.textSegmentControlShowAllBlock = ^(BOOL isShow){
            STRONG
            if (isShow && self.viewModel.all_title_data_array.count>1) {
               
                [YBLSeckillCategoryView showCategoryViewOnView:self.Vc.view
                                                     DataArray:self.viewModel.all_title_data_array
                                                   SelectIndex:self.viewModel.currentFoundIndex
                                                   SelectBlock:^(NSString *selectTitlte, NSInteger selectIndex) {
                                                       STRONG
                                                       self.viewModel.currentFoundIndex = selectIndex;
                                                       [self.textSegmentControl defaultView];
                                                       self.viewModel.selectTitle = selectTitlte;
                                                       self.textSegmentControl.currentIndex = self.viewModel.currentFoundIndex;
                                                   }
                                                  DismissBlock:^{
                                                      STRONG
                                                      [self.textSegmentControl defaultView];
                                                  }];
            } else {
                [YBLSeckillCategoryView dismissView];
            }
        };
    }
    return _textSegmentControl;
}


#pragma mark -  seg delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    
    self.viewModel.currentFoundIndex = index;
    self.viewModel.selectTitle = self.viewModel.all_title_data_array[index];
    [self.goodListScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    [self checkTableViewIsExsitWithIndex:index isReload:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    self.textSegmentControl.currentIndex = index;
}

#pragma mark - method

- (YBLGoodListManageTableView *)getCurrentTableViewWithIndex:(NSInteger)index{
    YBLGoodListManageTableView *tableView = (YBLGoodListManageTableView *)[self.Vc.view viewWithTag:tag_glTableView+index];
    return tableView;
}

- (void)checkTableViewIsExsitWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    
    NSMutableArray *current_data_array = [self.viewModel getCurrentDataArrayWithIndex:index];
//    YBLGoodListManageTableView *exsit_collectionView = [self getCurrentTableViewWithIndex:index];
    if (current_data_array.count==0) {
        //1.2请求数据
        [self requestDataWithIndex:index isReload:isReload];
    }
}
    
- (void)requestDataWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    WEAK
    __block YBLGoodListManageTableView *tableView = [self getCurrentTableViewWithIndex:index];
    [[self.viewModel siganlForStoreWithIndex:index isReload:isReload] subscribeNext:^(id  _Nullable x) {
       STRONG
        if (!tableView) {
            tableView = [self getGLTableViewWithIndex:index];
            [self.goodListScrollView addSubview:tableView];
            self.goodListScrollView.contentSize = CGSizeMake(self.goodListScrollView.width*self.viewModel.all_title_data_array.count, self.goodListScrollView.height);
        } else {
            [tableView.mj_header endRefreshing];
        }
        //赋值
        NSMutableArray *current_data_array = [self.viewModel getCurrentDataArrayWithIndex:index];
        tableView.dataArray = current_data_array;
//        [tableView jsReloadData];
        if (isReload||current_data_array.count==0) {
            [tableView jsReloadData];
        } else {
            [tableView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.textSegmentControl updateTitleData:self.viewModel.all_title_data_array];
        
    } error:^(NSError * _Nullable error) {
        [tableView.mj_header endRefreshing];
    }];
    
}

- (YBLGoodListManageTableView *)getGLTableViewWithIndex:(NSInteger)index{
    
    YBLGoodListManageTableView *listTableView = [[YBLGoodListManageTableView alloc] initWithFrame:CGRectMake(self.goodListScrollView.width*index, 0, self.goodListScrollView.width, self.goodListScrollView.height) style:UITableViewStylePlain];
    listTableView.tag = tag_glTableView+index;
    kWeakSelf(self)
    listTableView.goodListManageTableViewCellDidSelectBlock = ^(NSIndexPath *indexPath,YBLGoodModel *model){
        kStrongSelf(self)
        [self pushRackVCWithId:model indexp:indexPath];
    };
    listTableView.goodListManageTableViewButtonClickBlock = ^(NSIndexPath *indexPath, YBLGoodModel *model) {
        kStrongSelf(self)
        YBLGoodListManageTableView *listTableView = [self getCurrentTableViewWithIndex:index];
        if ([model.state.value isEqualToString:@"offline"]) {
            //上架
            [[self.viewModel siganlForOnlineGoodWithId:model.id] subscribeError:^(NSError * _Nullable error) {
                
            } completed:^{
                [SVProgressHUD showSuccessWithStatus:@"上架成功~"];
                [model.state setValue:@"online" forKey:@"value"];
                [listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        } else if ([model.state.value isEqualToString:@"online"]) {
            //下架
            [[self.viewModel siganlForOfflineGoodWithId:model.id] subscribeError:^(NSError * _Nullable error) {
            } completed:^{
                [SVProgressHUD showSuccessWithStatus:@"下架成功~"];
                [model.state setValue:@"offline" forKey:@"value"];
                [listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        } else if ([model.state.value isEqualToString:@"rack"]) {
            kStrongSelf(self)
            [self pushRackVCWithId:model indexp:indexPath];
        }
    };
    listTableView.prestrainBlock = ^{
        kStrongSelf(self)
        BOOL isNomoreData = [self.viewModel.all_is_nomore_data_dict[@(index)] boolValue];
        if (!self.viewModel.isReqesuting&&!isNomoreData) {
            [self requestDataWithIndex:index isReload:NO];
        }
    };
    [YBLMethodTools headerRefreshWithTableView:listTableView completion:^{
        kStrongSelf(self)
        [self requestDataWithIndex:index isReload:YES];
    }];
    
    return listTableView;
}

- (void)pushRackVCWithId:(YBLGoodModel *)model indexp:(NSIndexPath *)indexp{
    YBLEditGoodViewModel *viewModel = [YBLEditGoodViewModel new];
    viewModel._id = model.id;
    WEAK
    viewModel.goodModelBlock = ^(YBLGoodModel *changeModel) {
        STRONG
        model.state.value = changeModel.state.value;
        YBLGoodListManageTableView *manageTableView = [self getCurrentTableViewWithIndex:self.viewModel.currentFoundIndex];
        [manageTableView reloadRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    viewModel.deleteBlock = ^(YBLGoodModel *changeModel) {
        STRONG
        NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        [data removeObjectAtIndex:indexp.row];
        YBLGoodListManageTableView *manageTableView = [self getCurrentTableViewWithIndex:self.viewModel.currentFoundIndex];
        [manageTableView deleteRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    YBLEditGoodViewController *editVC = [[YBLEditGoodViewController alloc] init];
    editVC.viewModel = viewModel;
    [self.Vc.navigationController pushViewController:editVC animated:YES];
}

@end
