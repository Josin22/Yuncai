//
//  YBLIwantMoenyViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRewardViewController.h"
#import "YBLSingleTextSegment.h"
#import "YBLRewardViewModel.h"
#import "YBLStoreTableView.h"
#import "YBLNormalGoodTableView.h"
#import "YBLProductShareModel.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLShareView.h"

@interface YBLRewardViewController ()<YBLSingleTextSegmentDelegate,YBLTableViewDelegate>

//@property (nonatomic, strong) YBLSingleTextSegment *textSegment;

@property (nonatomic, strong) YBLRewardViewModel *viewModel;

//@property (nonatomic, strong) UIScrollView *conetntScrollView;

//@property (nonatomic, strong) YBLStoreTableView *storeTableView;

@property (nonatomic, strong) YBLNormalGoodTableView *goodTableView;

@end

@implementation YBLRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"赏金达人";
    
//    [self.view addSubview:self.textSegment];
//    [self.view addSubview:self.conetntScrollView];
    
    self.viewModel = [YBLRewardViewModel new];
    self.viewModel.rewardType = RewardTypeShare;
    
    [self requestRewardIsReload:YES];
    
}


- (void)requestRewardIsReload:(BOOL)isReload{
    
    WEAK
    [[self.viewModel singalForShareMoenyIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.goodTableView.dataArray = self.viewModel.singleDataArray;
        [self.goodTableView jsInsertRowIndexps:self.viewModel.fin_indexps];
        [self.goodTableView.mj_header endRefreshing];
        
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (YBLNormalGoodTableView *)goodTableView{
    if (!_goodTableView) {
        _goodTableView = [[YBLNormalGoodTableView alloc] initWithFrame:[self.view bounds]
                                                                 style:UITableViewStylePlain
                                                         tableViewType:NormalTableViewTypeRewardToShareGood];
        //        _goodTableView.left = 0;
        _goodTableView.ybl_delegate = self;
        _goodTableView.showsVerticalScrollIndicator = NO;
        _goodTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_goodTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_goodTableView completion:^{
            STRONG
            [self requestRewardIsReload:YES];
        }];
        _goodTableView.prestrainBlock = ^{
            STRONG
            [self requestRewardIsReload:NO];
        };
    }
    return _goodTableView;
}


- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLProductShareModel *model = (YBLProductShareModel *)selectValue;
    if (!model) {
        return;
    }
    if (![YBLMethodTools checkLoginWithVc:self]) {
        return;
    }
    NSString *title = model.product.title;
    NSString *imageUrl = model.product.avatar_url;
    NSString *share_url = [NSString stringWithFormat:@"https://api.kuaiyiyuncai.cn/product_fronts?id=%@",model.product.id];;
    NSString *userid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
    share_url = [NSString stringWithFormat:@"%@&userid=%@",share_url,userid];
    WEAK
    [YBLShareView shareViewWithPublishContentText:@"这家店铺的商品非常不错,推荐给你了解一下"
                                            title:title
                                        imagePath:imageUrl
                                              url:share_url
                                           Result:^(ShareType type, BOOL isSuccess) {
                                                STRONG
                                               if (type == ShareTypeSocial&&isSuccess) {
                                                   [self.viewModel singalForAddShareCountWithRewardID:model.id];
                                               }
                                           }
                          ShareADGoodsClickHandle:nil];

}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLProductShareModel *model = (YBLProductShareModel *)selectValue;
    NSString *url_id = model.product.id;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = url_id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
}

/*
- (YBLSingleTextSegment *)textSegment{
    
    if (!_textSegment) {
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)];
        topLabel.text = @"   转发悬赏任务,好友浏览/我要赚云币";
        topLabel.textColor = BlackTextColor;
        topLabel.backgroundColor = YBLColor(229, 197, 197, 1);
        topLabel.font = YBLFont(13);
        [self.view addSubview:topLabel];
        _textSegment = [[YBLSingleTextSegment alloc] initWithFrame:CGRectMake(0, topLabel.bottom, YBLWindowWidth, 45)
                                                        TitleArray:@[@"商品任务",
                                                                     @"店铺任务"]];
        _textSegment.backgroundColor = [UIColor whiteColor];
        _textSegment.delegate = self;
        _textSegment.enableSegment = YES;
    }
    return _textSegment;
}

- (UIScrollView *)conetntScrollView{
    if (!_conetntScrollView) {
        _conetntScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegment.bottom, YBLWindowWidth, YBLWindowHeight-self.textSegment.bottom)];
        _conetntScrollView.pagingEnabled = YES;
        _conetntScrollView.contentSize = CGSizeMake(_conetntScrollView.width*2, _conetntScrollView.height);
        _conetntScrollView.backgroundColor = [UIColor whiteColor];
        _conetntScrollView.showsVerticalScrollIndicator = NO;
        _conetntScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _conetntScrollView;
}


- (YBLStoreTableView *)storeTableView{
    
    if (!_storeTableView) {
        _storeTableView = [[YBLStoreTableView alloc] initWithFrame:[self.view bounds]
                                                             style:UITableViewStyleGrouped
                                                          listType:StoreListTypeSearch];
        _storeTableView.ybl_delegate = self;
//        _storeTableView.left = self.conetntScrollView.width;
        [self.view addSubview:_storeTableView];
        
    }
    return _storeTableView;
}
 
 - (void)CurrentSegIndex:(NSInteger)index{
 
 }
 
 */


@end
