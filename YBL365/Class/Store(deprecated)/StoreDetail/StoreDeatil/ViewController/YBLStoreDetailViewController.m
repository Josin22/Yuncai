//
//  YBLStoreDetailViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDetailViewController.h"
#import "YBLStoreDetailUIService.h"
#import "YBLStoreDetailHeaderView.h"
#import "YBLStoreCardViewController.h"
#import "YBLStoreGoodsViewController.h"
#import "YBLStorePromotionViewController.h"
#import "YBLStoreNewViewController.h"

@interface YBLStoreDetailViewController ()
@property (nonatomic, strong) YBLStoreDetailUIService * storeDetailUIService;
@property (nonatomic, strong) UITableView * storeDetailTab;
@property (nonatomic, strong) YBLStoreDetailHeaderView * headerView;
@end

@implementation YBLStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    
    [self startUIService];
    
    [self addSubViews];
    // Do any additional setup after loading the view.
}

- (void)createNavigationBar {
    self.title = @"店铺详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"ybl_navgation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(YBLWindowWidth - 44 - 5, 20, 40, 44);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage newImageWithNamed:@"store_classify" size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = YBLFont(11);
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 13, 0, 0)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
//    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * shareBarBtn = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtn;

}

#pragma mark -  开启UI服务

- (void)startUIService {
    self.storeDetailUIService = [[YBLStoreDetailUIService alloc] init];
    WEAK
    self.storeDetailUIService.cellSelectBlock = ^(NSIndexPath * indexPath) {
        STRONG
        if (indexPath.section == 2 && indexPath.row == 1) {
            YBLStoreCardViewController * storeCardVC = [[YBLStoreCardViewController alloc]init];
            [self.navigationController pushViewController:storeCardVC animated:YES];
        }
    };
}

#pragma mark -  add view
- (void)addSubViews {
    [self.view addSubview:self.storeDetailTab];
    
}

- (UITableView *)storeDetailTab {
    if (!_storeDetailTab) {
        _storeDetailTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStyleGrouped];
        _storeDetailTab.dataSource = self.storeDetailUIService;
        _storeDetailTab.delegate = self.storeDetailUIService;
        _storeDetailTab.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _storeDetailTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_storeDetailTab registerClass:NSClassFromString(@"YBLStoreDetailCell") forCellReuseIdentifier:@"YBLStoreDetailCell"];
        [_storeDetailTab registerClass:NSClassFromString(@"YBLStoreCommentCell") forCellReuseIdentifier:@"YBLStoreCommentCell"];
        _storeDetailTab.tableHeaderView = self.headerView;
    }
    return _storeDetailTab;
}

- (YBLStoreDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YBLStoreDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 120)];
        _headerView.backgroundColor = [UIColor whiteColor];
        WEAK
        _headerView.buttonSelectBlock = ^(NSInteger selectIndex) {
            STRONG
            [self pushVCWithIndex:selectIndex];
        };
    }
    return _headerView;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushVCWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            //商品
            YBLStoreGoodsViewController * storeGoodsVC =[[YBLStoreGoodsViewController alloc]init];
            storeGoodsVC.isShowSelect = YES;
            [self.navigationController pushViewController:storeGoodsVC animated:YES];
        }
            break;
        case 1: {
            //热销
            YBLStorePromotionViewController * storePromotionVC =[[YBLStorePromotionViewController alloc]init];
            [self.navigationController pushViewController:storePromotionVC animated:YES];
        }
            break;
        case 2: {
            //上新
            YBLStoreNewViewController * storeNewVC =[[YBLStoreNewViewController alloc]init];
            [self.navigationController pushViewController:storeNewVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
