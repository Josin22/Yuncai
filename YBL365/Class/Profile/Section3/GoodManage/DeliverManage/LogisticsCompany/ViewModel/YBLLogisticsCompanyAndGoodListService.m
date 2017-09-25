//
//  YBLLogisticsCompanyAndGoodListService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLogisticsCompanyAndGoodListService.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLExpressGoodListAndCompanyCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"
#import "YBLWriteTextView.h"
#import "YBLRewardSetViewController.h"

@interface YBLLogisticsCompanyAndGoodListService ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak  ) YBLLogisticsCompanyAndGoodListViewController *Vc;

@property (nonatomic, weak  ) YBLLogisticsCompanyAndGoodListViewModel *viewModel;

@property (nonatomic, strong) UITableView *undefineTableView;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation YBLLogisticsCompanyAndGoodListService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLLogisticsCompanyAndGoodListViewController *)VC;
        _viewModel = (YBLLogisticsCompanyAndGoodListViewModel *)viewModel;
        
        if (self.viewModel.listVCType != ListVCTypeStoreGoodSingleSelect) {
            self.Vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveExpressCompany)];
        }
        WEAK
        if([self.viewModel isGoodsType]){
            /**
             *  店铺商品
             */
            [self requestStoreListIsreload:YES];
        } else {
            /* rac */
            [[self.viewModel expressCompanyGoodListSiganl] subscribeError:^(NSError * _Nullable error) {
            } completed:^{
                STRONG
                [self.undefineTableView.mj_header endRefreshing];
                [self.undefineTableView jsReloadData];
                if (self.viewModel.listVCType == ListVCTypeSingleExpressCompany) {
                    [[self.viewModel siganlForVaildExpressCompany] subscribeNext:^(id  _Nullable x) {
                        [self.undefineTableView jsReloadData];
                    } error:^(NSError * _Nullable error) {
                        
                    }];
                }
            }];
        }
    }
    return self;
}

- (void)requestStoreListIsreload:(BOOL)isReload{
    WEAK
    [[self.viewModel storeGoodListSiganlIsReload:isReload] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        [self.undefineTableView.mj_header endRefreshing];
//        [self.undefineTableView jsReloadData];
        if (isReload) {
            [self.undefineTableView.mj_header endRefreshing];
            [self.undefineTableView jsReloadData];
        } else {
            [self.undefineTableView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } error:^(NSError * _Nullable error) {
        if (isReload) {
            [self.undefineTableView.mj_header endRefreshing];
        }
    }];
}

//保存物流 商品
- (void)saveExpressCompany{
    
    [self.Vc.view endEditing:YES];
    
    if (self.viewModel.listVCType == ListVCTypeRewardToSetMoeny) {
        if (self.viewModel.selectCompanyGoodListDataArray.count==0) {
            [SVProgressHUD showWithStatus:@"你还没有选择商品哟~"];
            return;
        }
        YBLRewardSetViewController *rewardSetVc = [YBLRewardSetViewController new];
        rewardSetVc.selectGoodsArray = self.viewModel.selectCompanyGoodListDataArray;
        [self.Vc.navigationController pushViewController:rewardSetVc animated:YES];
        return;
    }
    
    if (self.viewModel.listVCType == ListVCTypeGood||self.viewModel.listVCType == ListVCTypeStoreGood||self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect) {
        //
        BLOCK_EXEC(self.viewModel.logisticsCompanyAndGoodListBlock,self.viewModel.selectCompanyGoodListDataArray);
        [self.Vc.navigationController popViewControllerAnimated:YES];
        
    } else {
        WEAK
        [self.viewModel.settingExpressCompanyGoodListSiganl subscribeError:^(NSError * _Nullable error) {
            
        } completed:^{
            STRONG
            BLOCK_EXEC(self.viewModel.logisticsCompanyAndGoodListBlock,self.viewModel.selectCompanyGoodListDataArray);
            [self.Vc.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (UITableView *)undefineTableView{
    if (!_undefineTableView) {
        _undefineTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        _undefineTableView.dataSource = self;
        _undefineTableView.delegate = self;
        _undefineTableView.emptyDataSetSource = self;
        _undefineTableView.emptyDataSetDelegate = self;
        _undefineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _undefineTableView.showsVerticalScrollIndicator = YES;
        [_undefineTableView registerClass:NSClassFromString(@"YBLExpressGoodListAndCompanyCell") forCellReuseIdentifier:@"YBLExpressGoodListAndCompanyCell"];
        _undefineTableView.rowHeight = [YBLExpressGoodListAndCompanyCell getItemCellHeightWithModel:nil];
        [self.Vc.view addSubview:_undefineTableView];
        if (self.viewModel.listVCType != ListVCTypeStoreGoodSingleSelect) {
            [self.Vc.view addSubview:self.saveButton];
            _undefineTableView.height -= buttonHeight+space*2;
        } else {
            _undefineTableView.height -= space*2;
        }
    }
    return _undefineTableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-2*space, buttonHeight)];
        if (self.viewModel.listVCType == ListVCTypeGood||self.viewModel.listVCType == ListVCTypeStoreGood||self.viewModel.listVCType == ListVCTypeRewardToSetMoeny) {
            [saveButton setTitle:@"全选" forState:UIControlStateNormal];
            [saveButton setTitle:@"取消全选" forState:UIControlStateSelected];
        } else {
            [saveButton setTitle:@"添加物流快递" forState:UIControlStateNormal];
        }
        WEAK
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if([self.viewModel isGoodsType]){
                //
                x.selected = !x.selected;
                for (id model in self.viewModel.dataArray) {
                    [model setValue:@(x.selected) forKey:@"is_select"];
                }
                [self.undefineTableView jsReloadData];
                
            } else {
                //添加物流
                [YBLWriteTextView showWriteTextViewOnView:self.Vc
                                              currentText:@""
                                         LimmitTextLength:50
                                             completetion:^(NSString *text) {
                                                 STRONG
                                                 [[self.viewModel siganlForAddExpressCompanyWithIds:nil Name:text] subscribeError:^(NSError * _Nullable error) {
                                                 } completed:^{
                                                     STRONG
                                                     [self.undefineTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                                                     [self undefineTableView ];
                                                     NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                                                     [self.undefineTableView jsInsertRowIndexps:@[indexpath].mutableCopy];
                                                 }];
                                             }];
            }
        }];
        _saveButton = saveButton;
    }
    return _saveButton;
}
//
//- (BOOL)isGoodSelectEvent{
//    
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLExpressGoodListAndCompanyCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"YBLExpressGoodListAndCompanyCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLExpressGoodListAndCompanyCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    id model = self.viewModel.dataArray[row];
    [cell updateItemCellModel:model];
    WEAK
    if (self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect) {
        cell.circleButton.enabled = NO;
    }
    [[[cell.circleButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [model setValue:@(!x.selected) forKey:@"is_select"];
        [self.undefineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    /**
     *  店铺商品预加载
     */
    if (self.viewModel.listVCType == ListVCTypeStoreGood||self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect||self.viewModel.listVCType == ListVCTypeRewardToSetMoeny) {
        if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.viewModel.dataArray.count currentRow:row]) {
            [self requestStoreListIsreload:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect) {
        for (id model in self.viewModel.dataArray) {
            [model setValue:@(NO) forKey:@"is_select"];
        }
    }
    id model = self.viewModel.dataArray[row];
    NSNumber *number_is_select = [model valueForKey:@"is_select"];
    [model setValue:@(!number_is_select.boolValue) forKey:@"is_select"];
    [self.undefineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect) {
        [self saveExpressCompany];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.viewModel isGoodsType]){
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger row = indexPath.row;
        id model = self.viewModel.dataArray[row];
        NSString *_id = [model valueForKey:@"id"];
        WEAK
        [[self.viewModel siganlForDeleteAddExpressCompanyWithIds:_id index:row] subscribeError:^(NSError * _Nullable error) {
            
        } completed:^{
            STRONG
            [self.undefineTableView beginUpdates];
            [self.undefineTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.undefineTableView endUpdates];
        }];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.viewModel.dataArray.count == 0) {
        return;
    }
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if (distanceFromBottom < height) {
        if (self.viewModel.listVCType == ListVCTypeStoreGood||self.viewModel.listVCType == ListVCTypeStoreGoodSingleSelect||self.viewModel.listVCType == ListVCTypeRewardToSetMoeny) {
            [self requestStoreListIsreload:NO];
        }
    }
}


#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_express";
    if([self.viewModel isGoodsType]){
        imageName = @"null_data_good";
    }
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无物流公司";
    if([self.viewModel isGoodsType]){
        text = @"暂无可选商品";
    }
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self.Vc.navigationController popViewControllerAnimated:YES];
}

@end
