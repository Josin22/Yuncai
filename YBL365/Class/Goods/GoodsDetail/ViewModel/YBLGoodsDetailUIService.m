//
//  YBLGoodsDetailUIService.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDetailUIService.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreViewController.h"
#import "YBLGoodsDetailBar.h"
#import "YBLGoodsDetailUIService.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLStoreViewController.h"
#import "YBLGoodDetailTitleView.h"
#import "YBLShopCarViewController.h"
#import "YBLTakeOrderViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLPromotionView.h"
#import "YBLGoodEvaluateViewController.h"
#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLReferenceTableView.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLSaveManyImageTools.h"
#import "YBLSelectAddressView.h"
#import "YBLGoodDetailTableView.h"
#import "YBLGoodsSpecView.h"
#import "YBLSpecInfoView.h"
#import "YBLGoodParameterView.h"
#import "YBLEditAddressViewController.h"
#import "YBLPicTableView.h"
#import "YBLGoodEvaluateService.h"
#import "YBLDBManage.h"
#import "YBLFooterPrintsPopView.h"
#import "YBLShowCouponsView.h"

static NSInteger scrollViewTagTop = 8863;
static NSInteger scrollViewTagBase = 863;

@interface YBLGoodsDetailUIService ()<UIScrollViewDelegate,YBLTextSegmentControlDelegate>

{
    NSInteger imageIndex;
    NSInteger currentIIndex;
}
@property (nonatomic, weak  ) YBLGoodsDetailViewModel      *viewModel;
@property (nonatomic, weak  ) YBLGoodsDetailViewController *goodsDetailVC;
@property (nonatomic, strong) NSMutableArray               *listOfImages;
@property (nonatomic, strong) YBLGoodsDetailBar            *bar;
@property (nonatomic, strong) YBLGoodDetailTitleView       *detailTitleView;
@property (nonatomic, strong) UIScrollView                 *baseScrollView;
@property (nonatomic, strong) UIScrollView                 *topScrollView;
@property (nonatomic, strong) YBLGoodDetailTableView       *goodsTableView;
@property (nonatomic, strong) YBLPicTableView              *picDetailView;
@property (nonatomic, strong) YBLPicTableView              *BottonPicDetailView;
@property (nonatomic, strong) YBLReferenceTableView        *referenceTableView;
@property (nonatomic, strong) YBLGoodEvaluateService       *evaluateService;
@property (nonatomic, strong) UIView                       *evaluateView;
@property (nonatomic, strong) YBLGoodEvaluateViewModel     *evaleuViewModel;

@end

@implementation YBLGoodsDetailUIService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _goodsDetailVC = (YBLGoodsDetailViewController *)VC;
        _viewModel = (YBLGoodsDetailViewModel *)viewModel;
        
        self.baseScrollView.userInteractionEnabled = NO;
        
        /* Set Up View */
        _goodsDetailVC.navigationItem.titleView = self.detailTitleView;
        [_goodsDetailVC.view addSubview:self.baseScrollView];
        [_goodsDetailVC.view addSubview:self.bar];
        
        WEAK
        /* Rac观察是否能购买 */
        [RACObserve(self.viewModel, carBarEnable) subscribeNext:^(NSNumber*  _Nullable x) {
            STRONG
            self.bar.isBarEnable = x.boolValue;
        }];
        /**
         *  商品请求
         */
        [self requestGoodData];
    }
    return self;
}

- (void)requestGoodData{
    
    /* Good Detail Request */
    WEAK
    [[self.viewModel goodDetailSignal] subscribeError:^(NSError *error) {
        STRONG
        self.baseScrollView.userInteractionEnabled = NO;
        self.bar.isBarEnable = NO;
        self.bar.storeButton.enabled = NO;
        self.bar.foucsButton.enabled = NO;
        
    } completed:^{
        STRONG
        self.bar.foucsButton.selected = self.viewModel.isFollowed;
        self.baseScrollView.userInteractionEnabled = YES;
        [self.goodsTableView updateCellIDArray:self.viewModel.cellIDArray goodDetailModel:self.viewModel.goodDetailModel];
        [self requestAddressData];
        //储存到数据库
        [[YBLDBManage shareDB] saveRecordsGoodDetailModel:self.viewModel.goodDetailModel];
    }];
}

- (void)requestAddressData{
    /**
     *  1.登录状态请求用户地址
     *  2.非空地址请求物流价格
     */
    if (!self.viewModel.goodDetailModel) {
        return;
    }
    WEAK
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        /* Address */
        [[self.viewModel siganlForAddress] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            [self reloadAddressAndShippingPrice];
        }];
    }
}

- (void)reloadAddressAndShippingPrice{
    WEAK
    [self.goodsTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    //根据地址并请求物流价格
    if (self.viewModel.goodDetailModel.selectAddressModel) {
        [[self.viewModel siganlForShippingPrice] subscribeNext:^(id  _Nullable x) {
            STRONG
//            NSIndexPath *infoIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//            [self.goodsTableView reloadRowsAtIndexPaths:@[infoIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.goodsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } error:^(NSError * _Nullable error) {
        }];
    }

}

- (void)gobackVC{
    
    if (self.baseScrollView.contentOffset.x>=YBLWindowWidth) {
        self.detailTitleView.goodsDetailSegment.currentIndex = 0;
    } else {
        [self.goodsDetailVC.navigationController popViewControllerAnimated:YES];
    }
}

- (void)gotoTakeOrder {
    
    YBLTakeOrderViewModel *viewModel = [[YBLTakeOrderViewModel alloc] init];
    YBLTakeOrderViewController *takeOrderVC = [[YBLTakeOrderViewController alloc] init];
    takeOrderVC.viewModel = viewModel;
    [YBLMethodTools pushVc:takeOrderVC withNavigationVc:self.goodsDetailVC.navigationController];
    
}

- (UIView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView = [[UIView alloc] initWithFrame:CGRectMake(self.picDetailView.right, 0, self.picDetailView.width, self.picDetailView.height)];
    }
    return _evaluateView;
}

- (YBLGoodEvaluateService *)evaluateService{
    if (!_evaluateService) {
        YBLGoodEvaluateViewModel *evaleuView = [YBLGoodEvaluateViewModel new];
        evaleuView.product_id  = self.viewModel.goodDetailModel.id;
        self.evaleuViewModel = evaleuView;
        _evaluateService = [[YBLGoodEvaluateService alloc] initWithVC:self.goodsDetailVC ViewModel:self.evaleuViewModel superView:self.evaluateView];
    }
    return _evaluateService;
}

#pragma mark - lazy load view
- (YBLGoodDetailTitleView *)detailTitleView{
    if (!_detailTitleView) {
        _detailTitleView = [[YBLGoodDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
        _detailTitleView.goodsDetailSegment.delegate = self;
    }
    return _detailTitleView;
}
- (YBLGoodsDetailBar *)bar{
    
    if (!_bar) {
        _bar = [[YBLGoodsDetailBar alloc] initWithFrame:CGRectMake(0, self.goodsDetailVC.view.height-45-kNavigationbarHeight, YBLWindowWidth, 45)];
        WEAK
        _bar.goodsDetailBarItemClickBlock = ^(BarItemType type,YBLButton *clickBtn){
            STRONG
            switch (type) {
                case BarItemTypeStore:
                {
                    [self goStoreVC];
                }
                    break;
                case BarItemTypeFoucs:
                {
                    [[self.viewModel signalForGoodFollow:!clickBtn.selected] subscribeNext:^(id  _Nullable x) {
                        if (!clickBtn.selected) {
                            [YBLMethodTools popAnimationWithView:clickBtn.imageView];
                        }
                        clickBtn.selected = !clickBtn.selected;
                        
                    } error:^(NSError * _Nullable error) {
                        
                    }];
                }
                    break;
                case BarItemTypeCart:
                {
                    if ([YBLMethodTools checkLoginWithVc:self.goodsDetailVC]) {
                        YBLShopCarViewModel *viewModel = [[YBLShopCarViewModel alloc] init];
                        viewModel.carVCType = CarVCTypeSpecial;
                        YBLShopCarViewController *shopCarVC = [[YBLShopCarViewController alloc] init];
                        shopCarVC.viewModel = viewModel;
                        [self.goodsDetailVC.navigationController pushViewController:shopCarVC animated:YES];
                    }
                }
                    break;
                case BarItemTypeAddToCart:
                {
                    [self pushSpecView];
                }
                    break;
                case BarItemTypeDaoHuoNotification:
                {
                    [self showNoStock];
                }
                    break;
                    
                default:
                    break;
            }
            
        };
    }
    return _bar;
}

- (void)showNoStock{
    [SVProgressHUD showSuccessWithStatus:@"如果30天到货,会通过消息中心提醒您"];
}

- (void)showFooterPrintsView{

    NSMutableArray *footerDataArray = [YBLDBManage shareDB].getTenRecordsGoodDataArray;
    WEAK
    [YBLFooterPrintsPopView showFooterPrintsPopViewWithDataArray:footerDataArray
                                                 completionBlock:^(YBLGoodModel *selectGoodModel) {
                                                     STRONG
                                                     YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
                                                     viewModel.goodID = selectGoodModel.id;
                                                     viewModel.goodDetailModel = selectGoodModel;
                                                     YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
                                                     goodDetailVC.viewModel = viewModel;
                                                     [self.goodsDetailVC.navigationController pushViewController:goodDetailVC animated:YES];
                                                 }
                                                     cancelBlock:^{
                                                         
                                                     }];
}

/*基本scroll*/
- (UIScrollView *)baseScrollView{
    
    if (!_baseScrollView) {
        CGRect frsam1 = CGRectMake(0, 0, YBLWindowWidth, self.goodsDetailVC.view.height-self.bar.height-kNavigationbarHeight);
        _baseScrollView = [[UIScrollView alloc] initWithFrame:frsam1];
        _baseScrollView.directionalLockEnabled = YES;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.delegate = self;
        _baseScrollView.tag = scrollViewTagBase;
        _baseScrollView.contentSize = CGSizeMake(_baseScrollView.width*3, _baseScrollView.height);
        [_baseScrollView addSubview:self.topScrollView];
        [_baseScrollView addSubview:self.picDetailView];
        [_baseScrollView addSubview:self.evaluateView];
        [_baseScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.goodsDetailVC.navigationController.interactivePopGestureRecognizer];
    }
    return _baseScrollView;
}
/*第一页scroll*/
- (UIScrollView *)topScrollView{
    
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:[self.baseScrollView frame]];
        _topScrollView.pagingEnabled = YES;
        _topScrollView.directionalLockEnabled = YES;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
        _topScrollView.bounces = NO;
        _topScrollView.delegate = self;
        _topScrollView.contentSize = CGSizeMake(self.baseScrollView.width, self.baseScrollView.height*2);
        _topScrollView.tag = scrollViewTagTop;
        [_topScrollView addSubview:self.goodsTableView];
        [_topScrollView addSubview:self.BottonPicDetailView];
    }
    return _topScrollView;
}

/*中部详情*/
- (YBLPicTableView *)picDetailView{
    
    if (!_picDetailView) {
        _picDetailView = [[YBLPicTableView alloc] initWithFrame:CGRectMake(YBLWindowWidth, 0, YBLWindowWidth, self.baseScrollView.height)];
        _picDetailView.backgroundColor = [UIColor whiteColor];
    }
    return _picDetailView;
}
/* 底部详情 */
- (YBLPicTableView *)BottonPicDetailView{
    
    if (!_BottonPicDetailView) {
        _BottonPicDetailView = [[YBLPicTableView alloc] initWithFrame:CGRectMake(0, self.baseScrollView.height, self.baseScrollView.width, self.baseScrollView.height)];
        _BottonPicDetailView.backgroundColor = [UIColor whiteColor];
        WEAK
        _BottonPicDetailView.picDetailScrollPullBlock = ^{
            STRONG
            [self.detailTitleView sliderTop];
            [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.baseScrollView.scrollEnabled = YES;
        };
        
    }
    return _BottonPicDetailView;
}

/* 商品详情 */
- (YBLGoodDetailTableView *)goodsTableView{
    if (!_goodsTableView) {
        WEAK
        _goodsTableView = [[YBLGoodDetailTableView alloc] initWithFrame:CGRectMake(0, 0, self.baseScrollView.width, self.baseScrollView.height)
                                                                  style:UITableViewStyleGrouped];
        [_goodsTableView updateCellIDArray:self.viewModel.cellIDArray goodDetailModel:nil];
        _goodsTableView.goodsDetailVC = self.goodsDetailVC;
        /**
         *  评论
         */
        _goodsTableView.goodDetailTableViewScrollToCommentsBlock = ^{
            STRONG
            self.detailTitleView.goodsDetailSegment.currentIndex = 2;
            currentIIndex = 2;
        };
        /**
         *  banner滑到图文详情
         */
        _goodsTableView.goodDetailTableViewBannerScrollToLastItemBlock = ^{
            STRONG
            self.detailTitleView.goodsDetailSegment.currentIndex = 1;
            currentIIndex = 1;
        };
        _goodsTableView.footerPrintsBlock = ^{
            STRONG
            [self showFooterPrintsView];
        };
        /**
         *  滚到底部详情
         */
        _goodsTableView.goodDetailTableViewScrollToImageTextBlock = ^{
            STRONG
            [self turnToIamgeTextView];
        };
        /**
         *  tableview点击
         */
        _goodsTableView.goodDetailTableViewDidSelectBlock = ^(NSIndexPath *indexPath, NSString *cellName) {
            STRONG
            if ([cellName isEqualToString:@"YBLSpecInfoCell"]){
                /**
                 *  规格信息
                 */
                [YBLGoodParameterView showGoodParameterViewInViewController:self.goodsDetailVC.navigationController
                                                               paraViewType:ParaViewTypePara
                                                                   withData:self.viewModel.paraDataArray
                                                               completetion:^{}];
                
            }else if ([cellName isEqualToString:@"YBLGoodsPromotionCell"]){
                /**
                 *  促销
                 */
                [YBLPromotionView showPromotionViewFromVC:self.goodsDetailVC.navigationController];
                
            }else if ([cellName isEqualToString:@"YBLGoodsSpecCell"]){
                /**
                 *  商品规格
                 */
                [self pushSpecView];
                
            }else if ([cellName isEqualToString:@"YBLGoodsDeliverToCell"]){
                /**
                 *  送至
                 */
                if (![YBLMethodTools checkLoginWithVc:self.goodsDetailVC]) {
                    return;
                }
                if (self.viewModel.addressArray.count==0) {
                    
                    YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
                    viewModel.addressType = AddressTypeOrderAdd;
                    YBLEditAddressViewController *editAddressVC = [[YBLEditAddressViewController alloc] init];
                    editAddressVC.viewModel = viewModel;
                    [self.goodsDetailVC.navigationController pushViewController:editAddressVC animated:YES];
                    
                    return;
                }
                    
                [YBLSelectAddressView showSelectAddressViewFromVC:self.goodsDetailVC.navigationController
                                                      addressData:self.viewModel.addressArray
                                                     addressGenre:AddressGenreGoodDetailShipping
                                                       doneHandle:^(YBLAddressModel *selectAddressModel){
                                                           STRONG
                                                           self.viewModel.goodDetailModel.selectAddressModel = selectAddressModel;
                                                           [self reloadAddressAndShippingPrice];
                                                       }];
                
            }   else if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]){
                /**
                 *  商品评价
                 */
                YBLGoodEvaluateViewController *goodEvaluateVC = [YBLGoodEvaluateViewController new];
                [self.goodsDetailVC.navigationController pushViewController:goodEvaluateVC animated:YES];
                
            } else if ([cellName isEqualToString:@"YBLGoodsDetailInfoCell"]){
                self.detailTitleView.goodsDetailSegment.currentIndex = 1;
                currentIIndex = 1;
            } else if ([cellName isEqualToString:@"YBLCouponsLabelsCell"]){
                if (!self.viewModel.goodDetailModel.id) {
                    return;
                }
                [YBLShowCouponsView showCouponsViewFromVc:self.goodsDetailVC.navigationController productID:self.viewModel.goodDetailModel.id];
            }
            
        };
    }
    return _goodsTableView;
}

- (YBLReferenceTableView *)referenceTableView{
    
    if (!_referenceTableView) {
        _referenceTableView = [[YBLReferenceTableView alloc] initWithFrame:CGRectMake(YBLWindowWidth*2, 0, self.baseScrollView.width, self.baseScrollView.height) style:UITableViewStyleGrouped];
        
    }
    return _referenceTableView;
}

#pragma mark - method

- (void)turnToIamgeTextView{
    //设置动画效果
    WEAK
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.topScrollView setContentOffset:CGPointMake(0, self.baseScrollView.height) animated:YES];
        [self.detailTitleView sliderBottom];
    } completion:^(BOOL finished) {
        STRONG
        //结束加载
        self.baseScrollView.scrollEnabled = NO;
        [self.goodsTableView.mj_footer endRefreshing];
        if (self.viewModel.goodDetailModel.descs.count!=0 && !self.BottonPicDetailView.imageURLsArray) {
            self.BottonPicDetailView.imageURLsArray = [self.viewModel.goodDetailModel.descs mutableCopy];
        }
    }];
}

- (void)goStoreVC{
    
    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
    viewModel.shopid = self.viewModel.goodDetailModel.shop_id;
    YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
    storeVC.viewModel = viewModel;
    [self.goodsDetailVC.navigationController pushViewController:storeVC animated:YES];
}

- (void)pushSpecView{
    
    if (!self.viewModel.carBarEnable) {
        [self showNoStock];
        return;
    }
    if (![YBLMethodTools checkLoginWithVc:self.goodsDetailVC]) {
        return;
    }
    WEAK
    //商品规格
    [YBLGoodsSpecView showGoodsSpecViewFormVC:self.goodsDetailVC.navigationController
                                     SpecType:GoodsSpecTypeDefault
                                    goodModel:self.viewModel.goodDetailModel
                     specViewOneBuyClickBlock:^{
                         STRONG
                         [self gotoTakeOrder];
                     }
                    specViewAddCartClickBlock:^{
                        STRONG
                        [[self.viewModel addCartWithQuantity:self.viewModel.goodDetailModel.quantity.integerValue goodID:self.viewModel.goodID] subscribeNext:^(NSNumber *x) {
                            STRONG
                            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~"];
                            [self requestCartNumber];
                        }];                        
                    }];

}

- (void)requestCartNumber{    
    WEAK
    [[YBLShopCarViewModel getCurrentCartsNumber] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.viewModel.isHasRequestCartNumber = YES;
        self.bar.bageLabel.bageValue = [YBLUserManageCenter shareInstance].cartsCount;
    } error:^(NSError * _Nullable error) {

    }];
}

- (void)textSegmentControlIndex:(NSInteger)index{
    currentIIndex = index;
    [self.baseScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    if (self.viewModel.goodDetailModel.descs.count == 0) {
        return;
    }
    if (!self.picDetailView.imageURLsArray.count &&index==1) {
        //                self.picDetailView.urlValue = self.viewModel.goodDetailModel.descs[0];
        self.picDetailView.imageURLsArray = self.viewModel.goodDetailModel.descs.mutableCopy;
    } else if (index == 2){
        if (self.evaluateService) {
            
        }
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    if (scrollView.tag == scrollViewTagBase) {
        currentIIndex = index;
        self.detailTitleView.goodsDetailSegment.currentIndex = index;
    }
}

#pragma mark - save image

- (void)saveQRCodeIamge{

    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.imagesArray = [self.viewModel.goodDetailModel.mains mutableCopy];
    model.imageType = SaveImageTypeNormalGoods;
    model.share_url = self.viewModel.goodDetailModel.share_url;
    [YBLSaveManyImageTools saveImageModel:model
                             Completetion:^(BOOL isSuccess) {}];
    
}

@end
