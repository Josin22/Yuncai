//
//  YBLStoreService.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreService.h"
#import "YBLStoreViewController.h"
#import "YBLShopModel.h"
#import "YBLStoreHeaderView.h"
#import "YBLGoodsListCollectionView.h"

#import "YBLGoodsDetailViewController.h"
#import "YBLSearchNavView.h"
#import "YBLGoodSearchView.h"
#import "YBLGoodListViewController.h"
#import "YBLStoreSelectBannerViewController.h"
#import "YBLStoreInfoViewController.h"
#import "YBLBriberyMoneyView.h"
#import "YBLBriberyHudToCertificatedView.h"
#import "YBLIndustryScaleViewController.h"
#import "YBLTheResultViewController.h"
#import "YBLPhotoHeplerViewController.h"
//static NSInteger const tag_collection_view = 3232;

@interface YBLStoreService ()<YBLScaleTextSegmentViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
    CGFloat bannerHi;
    CGFloat segHi;
}
@property (nonatomic, weak) YBLStoreViewController *VC;

@property (nonatomic, strong) YBLStoreViewModel *viewModel;

@property (nonatomic, strong) YBLStoreHeaderView *headerView;

@property (nonatomic, strong) YBLSearchNavView *searchView;;

@property (nonatomic, strong) YBLGoodsListCollectionView *storeCollectionView;

@property (nonatomic, strong) YBLBriberyMoneyView *briberyMoneyView;

@end

@implementation YBLStoreService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLStoreViewModel *)viewModel;
        _VC = (YBLStoreViewController *)VC;

        self.VC.navigationItem.titleView = self.searchView;
        
        [self requestStoreIsreload:YES];
       
    }
    return self;
}

- (void)requestStoreIsreload:(BOOL)isReload{
    WEAK
    [[self.viewModel signalForShopDataWithIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.storeCollectionView.mj_header endRefreshing];
        self.storeCollectionView.dataArray = self.viewModel.goodCategoryDataDict[@(currentIndex)];
        if (isReload||currentIndex!=0) {
            [self.storeCollectionView jsReloadData];
        } else {
            [self.storeCollectionView insertItemsAtIndexPaths:x];
        }
        [self updateHeaderView];
        //计算
        if ([self.viewModel isHasBriberyMoney]&&self.briberyMoneyView) {
        }
        
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)updateHeaderView{
    
    self.headerView.foucsAnimationView.fousButton.selected = self.viewModel.shopinfo.followed.boolValue;
    [self.headerView.foucsAnimationView showFoucsAnimationWithValue:self.viewModel.shopinfo.followers_count.integerValue];
    BOOL isCredit = [self.viewModel.shopinfo.credit isEqualToString:@"china"]?YES:NO;
    self.headerView.creaditStoreImageView.hidden = !isCredit;
    self.headerView.signalLabel.text = [NSString stringWithFormat:@"综合 %.1f",self.viewModel.shopinfo.comment_rate.doubleValue];
    self.headerView.signalLabel.left = isCredit?self.headerView.creaditStoreImageView.right+3:self.headerView.storeNameButton.left;
    [self.headerView.storeNameButton setTitle:self.viewModel.shopinfo.shopname forState:UIControlStateNormal];
    CGSize storeSize = [self.viewModel.shopinfo.shopname heightWithFont:YBLFont(15) MaxWidth:self.headerView.width-self.headerView.storeImageView.width];
    self.headerView.storeNameButton.titleRect = CGRectMake(0, 0, storeSize.width, self.headerView.storeNameButton.height);
    self.headerView.storeNameButton.imageRect = CGRectMake(storeSize.width+2, 0, self.headerView.storeNameButton.height, self.headerView.storeNameButton.height);
    self.headerView.scaleTextSegment.topValue = self.viewModel.nummberValueArray;
    self.headerView.scaleTextSegment.bottomsValue = [self.viewModel.titleArray mutableCopy];
    [self.headerView.storeImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.viewModel.shopinfo.logo_url] placeholderImage:smallImagePlaceholder];
    if (self.viewModel.shopinfo.banner_url) {
        [self.headerView.bgImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.viewModel.shopinfo.banner_url] placeholderImage:middleImagePlaceholder];
    }
}

- (void)briberyLean{
    
    if ([self.viewModel isHasBriberyMoney]) {
        [self.briberyMoneyView lean];
    }
}

- (YBLBriberyMoneyView *)briberyMoneyView{
    if (!_briberyMoneyView) {
        _briberyMoneyView = [[YBLBriberyMoneyView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _briberyMoneyView.top = self.headerView.bottom+space;
        _briberyMoneyView.right = YBLWindowWidth-space;
        [self.VC.view addSubview:_briberyMoneyView];
        [_briberyMoneyView shake];
        WEAK
        [[_briberyMoneyView.briberyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if ([YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
                if ([self.viewModel isHasBriberyMoney]) {
                    [self foucsStoreTotastWithButton:self.headerView.foucsAnimationView.fousButton];
                } else {
                    [self foucsStoreWithButton:self.headerView.foucsAnimationView.fousButton];
                }
            } else {
                //
                [YBLBriberyHudToCertificatedView showBriberyHudToCertificatedViewWithBlock:^(NSInteger clickIndex) {
                    id classVC;
                    if ([YBLUserManageCenter shareInstance].aasmState == AasmStateUnknown||[YBLUserManageCenter shareInstance].aasmState == AasmStateInitial) {
                        
                        YBLIndustryScaleViewController *indusVC = [YBLIndustryScaleViewController new];
                        if (clickIndex==0) {
                            indusVC.currentType = user_type_seller_key;
                        } else {
                            indusVC.currentType = user_type_buyer_key;
                        }
                        classVC = indusVC;
                        
                    } else {
                        
                        YBLTheResultViewController *resultVC = [YBLTheResultViewController new];
                        classVC = resultVC;
                    }
                    [self.VC.navigationController pushViewController:classVC animated:YES];
                }];
            }
//            [self.briberyMoneyView showAnimationOpenBriberyOnView:self.VC.view];
//            [self foucsStoreTotastWithButton:self.headerView.foucsAnimationView.fousButton];
        }];
    }
    return _briberyMoneyView;
}

- (void)destroyBriberyView{
    [self.briberyMoneyView removeFromSuperview];
    self.briberyMoneyView = nil;
}

- (YBLSearchNavView *)searchView{
    if (!_searchView) {
        WEAK
        _searchView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
        _searchView.titleLabel.text = @"搜索店铺内商品";
        _searchView.searchBlock = ^{
            [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNoView
                                                          SearchHandle:^(NSString *searchText,SearchType searchType){
                                                              STRONG
                                                              //重新搜索店铺
                                                              YBLGoodListViewModel *viewModel = [YBLGoodListViewModel new];
                                                              viewModel.userinfo_id = self.viewModel.shopid;
                                                              viewModel.keyWord = searchText;
                                                              YBLGoodListViewController *listVC = [[YBLGoodListViewController alloc] init];
                                                              listVC.viewModel = viewModel;
                                                              [self.VC.navigationController pushViewController:listVC animated:YES];
                                                          }
                                                          cancleHandle:^{
                                                          }
                                                    animationEndHandle:^{
                                                    }
                                                           currentText:nil];
            
        };
    }
    return _searchView;
}

- (void)pushStoreInfo{
    
    YBLStoreInfoViewModel *viewModel = [YBLStoreInfoViewModel new];
    viewModel.shopModel = self.viewModel.shopinfo;
    viewModel.allProductCount = [self.viewModel.nummberValueArray[0] integerValue];
    YBLStoreInfoViewController *storeInfoVC = [YBLStoreInfoViewController new];
    storeInfoVC.viewModel  =viewModel;
    [self.VC.navigationController pushViewController:storeInfoVC animated:YES];
}

- (YBLStoreHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[YBLStoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 90)];
        bannerHi = _headerView.height;
        segHi = _headerView.scaleTextSegment.height;
        _headerView.scaleTextSegment.delegate = self;
        WEAK
        /**
         *  店铺详情
         */
        [[_headerView.storeNameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self pushStoreInfo];
        }];
        /**
         *  店铺背景更换
         */
        UITapGestureRecognizer *storeBgTap = [UITapGestureRecognizer new];
        [_headerView.bgImageView addGestureRecognizer:storeBgTap];
        [storeBgTap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            STRONG
            if (![YBLMethodTools checkLoginWithVc:self.VC]) {
                return ;
            }
            if (![[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:self.viewModel.shopid]) {
                return;
            }
            YBLStoreSelectBannerViewModel *viewModel = [YBLStoreSelectBannerViewModel new];
            viewModel.storeSelectBannerViewModelChangeBlock = ^(NSString *url) {
                STRONG
                [self.headerView.bgImageView js_alpha_setImageWithURL:[NSURL URLWithString:url] placeholderImage:middleImagePlaceholder];
            };
            YBLStoreSelectBannerViewController *selectBannerVC = [YBLStoreSelectBannerViewController new];
            selectBannerVC.viewModel = viewModel;
            [self.VC.navigationController pushViewController:selectBannerVC animated:YES];
            
        }];
        /**
         *  店铺logo
         */
        UITapGestureRecognizer *storeTap = [UITapGestureRecognizer new];
        [_headerView.storeImageView addGestureRecognizer:storeTap];
        [storeTap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            STRONG
            if (![YBLMethodTools checkLoginWithVc:self.VC]) {
                return ;
            }
            if (![[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:self.viewModel.shopid]) {
                return;
            }
            WEAK
            [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
                if (image) {
                    STRONG
                    [[self.viewModel signalForUploadShopLogoWithImage:image] subscribeError:^(NSError * _Nullable error) {
                    } completed:^{
                        STRONG
                        self.headerView.storeImageView.image = image;
                    }];
                }
            }
                                                                                    isEdit:YES
                                                                               isJustPhoto:NO];
            /*
            [YBLTakePhotoSheetPhotoView showUserIconImagePickerWithVC:self.VC
                                                         PikerDoneHandle:^(UIImage *image) {
                                                             if (image) {
                                                                 STRONG
                                                                 [[self.viewModel signalForUploadShopLogoWithImage:image] subscribeError:^(NSError * _Nullable error) {
                                                                 } completed:^{
                                                                     STRONG
                                                                     self.headerView.storeImageView.image = image;
                                                                 }];
                                                             }
                                                         }];
             */
        }];
        /**
         *  关注
         */
        [[_headerView.foucsAnimationView.fousButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable clickBtn) {
            STRONG
            if ([self.viewModel isHasBriberyMoney]) {
                [self foucsStoreTotastWithButton:clickBtn];
            } else {
                [self foucsStoreWithButton:clickBtn ];
            }
        }];
    }
    return _headerView;
}

- (void)foucsStoreTotastWithButton:(UIButton *)clickBtn{
    WEAK
    
    if (![YBLMethodTools checkLoginWithVc:self.VC]) {
        return;
    }
    
    [YBLOrderActionView showTitle:[NSString stringWithFormat:@"感谢您关注我的店铺 \n 特赠送您一个红包 请笑纳~"]
                           cancle:@"红包太小"
                             sure:@"关注领取"
                  WithSubmitBlock:^{
                      STRONG
                      [self foucsStoreWithButton:clickBtn ];
                  }
                      cancelBlock:^{
                          
                      }];
}

- (void)foucsStoreWithButton:(UIButton *)clickBtn {
    WEAK
    [[self.viewModel signalForStoreFollow:!clickBtn.selected] subscribeNext:^(id  _Nullable x) {
        STRONG
        if (!clickBtn.selected) {
            [YBLMethodTools popAnimationWithView:clickBtn.imageView];
            self.headerView.foucsAnimationView.changevalue++;
        } else {
            self.headerView.foucsAnimationView.changevalue--;
        }
        clickBtn.selected = !clickBtn.selected;
        [self destroyBriberyView];
        self.viewModel.shopinfo.followed = @(!clickBtn.selected);
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    currentIndex = index;
    self.storeCollectionView.dataArray = self.viewModel.goodCategoryDataDict[@(currentIndex)];
    [self.storeCollectionView jsReloadData];
}


- (YBLGoodsListCollectionView *)storeCollectionView{
    if (!_storeCollectionView) {
        _storeCollectionView = [[YBLGoodsListCollectionView alloc] initWithFrame:[self.VC.view bounds]
                                                                  collectionType:CollectionTypeStoreGood];
        _storeCollectionView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
        WEAK
        _storeCollectionView.goodsListCollectionViewScrollWillBegainDrageBlock = ^(UIScrollView *scrollView) {
            STRONG
            [self briberyLean];
        };
        _storeCollectionView.goodsListCollectionViewCellDidSelectBlock = ^(NSIndexPath *selectIndexPath, id model) {
            STRONG
            YBLGoodModel *goodModel  = (YBLGoodModel *)model;
            YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
            viewModel.goodID = goodModel.id;
            YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
            goodDetailVC.viewModel = viewModel;
            [self.VC.navigationController pushViewController:goodDetailVC animated:YES];
        };
        _storeCollectionView.goodsListCollectionViewScrollBlock = ^(UIScrollView *scrollView){
            STRONG
            CGFloat contentY = scrollView.contentOffset.y;
            if (-contentY<bannerHi){
                if (-contentY>=segHi){
                    if (-contentY<=segHi+space) {
                        //scale
                        CGFloat ratio = -contentY-segHi;
                        self.headerView.scaleTextSegment.ratio = ratio;
                    } else {
                        self.headerView.scaleTextSegment.ratio = 10;
                    }
                    self.headerView.top = -(bannerHi+contentY);
                }else {
                    self.headerView.scaleTextSegment.ratio = 0;
                    self.headerView.top = -(bannerHi-segHi);
                }
            } else {
                self.headerView.scaleTextSegment.ratio = 10;
                self.headerView.top = 0;
            }

        };
        //load more
        _storeCollectionView.viewPrestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyLoadMoreRequest]) {
                [self requestStoreIsreload:NO];
            }
        };
        //pull request
        [YBLMethodTools headerRefreshWithTableView:_storeCollectionView completion:^{
            STRONG
            [self requestStoreIsreload:YES];
        }];
        [self.VC.view addSubview:_storeCollectionView];
        [self.VC.view addSubview:self.headerView];
    }
    return _storeCollectionView;
}

@end
