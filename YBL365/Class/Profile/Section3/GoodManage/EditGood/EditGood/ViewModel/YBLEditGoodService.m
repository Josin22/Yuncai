//
//  YBLEditGoodService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodService.h"
#import "YBLEditGoodViewController.h"
#import "YBLTextSegmentControl.h"
#import "YBLEditPurchaseCell.h"
#import "YBLEditPurchaseHeaderView.h"
#import "YBLEditGoodTableView.h"
#import "YBLManageGoodTableView.h"
#import "YBLGoodDetailTableView.h"
#import "YBLPicTableView.h"
#import "YBLGoodModel.h"
#import "YBLEditGoodPicViewController.h"
#import "YBLGoodsManageViewModel.h"

@interface YBLEditGoodService ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate,YBLGoodsBannerDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic, weak  ) YBLEditGoodViewModel      *viewModel;

@property (nonatomic, weak  ) YBLEditGoodViewController *Vc;

@property (nonatomic, strong) YBLTextSegmentControl     *segmentControl;

@property (nonatomic, strong) UIScrollView              *scrollView;

@property (nonatomic, strong) UIButton                  *saveButton;

@property (nonatomic, strong) YBLEditGoodTableView      *editTableView;

@property (nonatomic, strong) YBLManageGoodTableView    *manageGoodTableView;

@property (nonatomic, strong) YBLPicTableView           *goodDetailView;

@property (nonatomic, strong) UIButton                  *deleteButton;

@end

@implementation YBLEditGoodService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLEditGoodViewController *)VC;
        _viewModel = (YBLEditGoodViewModel *)viewModel; 
        
        _Vc.navigationItem.titleView = self.segmentControl;
        
        [_Vc.view addSubview:self.scrollView];
        
        WEAK
        [RACObserve(self.viewModel, productModel) subscribeNext:^(YBLGoodModel *  _Nullable x) {
            STRONG
            if (!x) {
                return ;
            }
            BOOL goodStatus = NO;
            if ([x.state.value isEqualToString:@"online"]) {
                goodStatus = YES;
            }
            YBLEditItemGoodParaModel *firModel = self.viewModel.cellManageGoodDataArray[0];
            firModel.value = [NSString stringWithFormat:@"%@",@(goodStatus)];
            NSIndexPath *pp = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.manageGoodTableView reloadRowsAtIndexPaths:@[pp] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.deleteButton.enabled = !goodStatus;
        }];
    }
    return self;
}

- (void)requestRackGood{
    
    WEAK
    [self.viewModel.rackProductSingal subscribeError:^(NSError *error) {
    } completed:^{
        STRONG
        self.scrollView.userInteractionEnabled = YES;
        self.saveButton.enabled = YES;
        YBLEditItemGoodParaModel *firModel = self.viewModel.cellManageGoodDataArray[0];
        self.deleteButton.enabled = !firModel.value.boolValue;
        
        [self.editTableView jsReloadData];

        [self reloadPic];
    }];
       
}

- (void)reloadPic{
 
    if (currentIndex==0&&self.viewModel.productModel.mains.count>0) {
        self.goodDetailView.imageURLsArray = [self.viewModel.productModel.descs mutableCopy];
        self.goodDetailView.goodBannerView.imageURLArray = self.viewModel.productModel.mains;
        self.goodDetailView.goodBannerView.currentPageIndex = 0;
    }
}

#pragma mark - loazyview

- (YBLTextSegmentControl *)segmentControl{
    
    if (!_segmentControl) {
        _segmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, 200, 44) TextSegmentType:TextSegmentTypeGoodsDetail];
        _segmentControl.delegate = self;
        [_segmentControl updateTitleData:[@[@"详情",@"编辑",@"设置"] mutableCopy]];
        _segmentControl.currentIndex = 1;
        currentIndex = 1;
    }
    return _segmentControl;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.userInteractionEnabled = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(YBLWindowWidth*3, YBLWindowHeight);
        [_scrollView addSubview:self.goodDetailView];
        [_scrollView addSubview:self.editTableView];
        [_scrollView addSubview:self.saveButton];
        [_scrollView addSubview:self.manageGoodTableView];
        [_scrollView addSubview:self.deleteButton];
    }
    return _scrollView;
}

- (YBLPicTableView *)goodDetailView{
    if (!_goodDetailView) {
        _goodDetailView = [[YBLPicTableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)
                                                           style:UITableViewStyleGrouped
                                                picTableViewType:PicTableViewTypeHasCustomHeader];

        _goodDetailView.goodBannerView.delegate = self;
        WEAK
        _goodDetailView.itemButton.goodsManageItemButtonClickBlock = ^(NSInteger index) {
            STRONG
            if (index == 2) {
                [SVProgressHUD showInfoWithStatus:@"此功能即将上线 \n 敬请期待!"];
                return ;
            }
            EditPicType type = index;
            YBLEditGoodPicViewModel *viewModel = [YBLEditGoodPicViewModel new];
            viewModel.editPicType = type;
            viewModel.editGoodModel = self.viewModel.productModel;
            YBLEditGoodPicViewController *editPicVC = [YBLEditGoodPicViewController new];
            editPicVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:editPicVC animated:YES];
        };
        
    }
    return _goodDetailView;
}

- (YBLEditGoodTableView *)editTableView{
    
    if (!_editTableView) {
        _editTableView = [[YBLEditGoodTableView alloc] initWithFrame:CGRectMake(YBLWindowWidth, 0, YBLWindowWidth, YBLWindowHeight-space) style:UITableViewStylePlain];
        _editTableView.viewModel = self.viewModel;
        _editTableView.Vc = self.Vc;
    }
    return _editTableView;
}

- (YBLManageGoodTableView *)manageGoodTableView{
    
    if (!_manageGoodTableView) {
        _manageGoodTableView = [[YBLManageGoodTableView alloc] initWithFrame:CGRectMake(self.editTableView.right, self.editTableView.top, self.editTableView.width, self.editTableView.height) style:UITableViewStylePlain];
        _manageGoodTableView.viewModel = self.viewModel;
        _manageGoodTableView.Vc = self.Vc;
        
    }
    return _manageGoodTableView;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(YBLWindowWidth+space, YBLWindowHeight-buttonHeight-kNavigationbarHeight-space, YBLWindowWidth-space*2, buttonHeight)];
        [_saveButton setTitle:@"保存编辑" forState:UIControlStateDisabled];
        [_saveButton setTitle:@"保存编辑" forState:UIControlStateNormal];
        WEAK
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            BOOL isDone = YES;
            for (YBLEditItemGoodParaModel *paraModel in self.viewModel.cellDataArray) {
                if (paraModel.required.boolValue&&paraModel.value.length==0) {
                    isDone = NO;
                }
            }
            if (isDone) {
                //编辑
                [[self.viewModel SingalForSaveProduct] subscribeError:^(NSError *error) {
                } completed:^{
                    [SVProgressHUD showSuccessWithStatus:@"商品信息保存成功~"];
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"您还没有填写完整哟~"];
            }
        }];

    }
    return _saveButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(self.saveButton.right+2*space,self.saveButton.top,self.saveButton.width,self.saveButton.height)];
        [_deleteButton setTitle:@"删除商品" forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除商品" forState:UIControlStateDisabled];
        WEAK
        [[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [YBLOrderActionView showTitle:@"确定要删除此商品吗?"
                                   cancle:@"我再想想"
                                     sure:@"确定"
                          WithSubmitBlock:^{
                              STRONG
                              [[YBLGoodsManageViewModel siganlForDeleteGoodWithId:self.viewModel._id] subscribeNext:^(id  _Nullable x) {
                                  STRONG
                                  [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      BLOCK_EXEC(self.viewModel.deleteBlock,self.viewModel.productModel);
                                      [self.Vc.navigationController popViewControllerAnimated:YES];
                                  });
                              } error:^(NSError * _Nullable error) {
                                  
                              }];
                          }
                              cancelBlock:^{
                              }];
        }];
    }
    return _deleteButton;
}

#pragma mark - method



#pragma mark - delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.Vc.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![scrollView isKindOfClass:[UITableView class]]) {
        NSInteger index = scrollView.contentOffset.x/YBLWindowWidth;
        self.segmentControl.currentIndex = index;
        currentIndex = index;
    }
}

- (void)textSegmentControlIndex:(NSInteger)index{
    currentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    if (self.viewModel.cellManageGoodDataArray.count==0&&index==2) {
        [self.manageGoodTableView jsReloadData];
    }
    if (self.goodDetailView.imageURLsArray.count==0) {
        [self reloadPic];
    }
}

- (void)banner:(YBLGoodsBannerView *)bannerView scrollToLastItem:(NSInteger)lastIndex{
    self.segmentControl.currentIndex = 1;
}

@end
