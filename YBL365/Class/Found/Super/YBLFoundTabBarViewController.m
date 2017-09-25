//
//  YBLFoundTabBarViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundTabBarViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLFoundViewController.h"
//#import "YBLFoundPurchaseViewController.h"
#import "YBLAddGoodListViewController.h"
#import "YBLFoundMyPurchaseViewController.h"
#import "YBLShareView.h"
#import "YBLAddGoodViewController.h"
#import "YBLTabBar.h"

static NSString *const purchase_all_share_url = @"https://api.kuaiyiyuncai.cn/purchase_orders/all";

@interface YBLFoundTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation YBLFoundTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"back_bt_7h"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purchase_title_image"]];
    
    [self addCustomTabBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    explainButton.frame = CGRectMake(0, 0, 30, 30);
    [explainButton setImage:[UIImage imageNamed:@"explain_icon"] forState:UIControlStateNormal];
    [explainButton addTarget:self action:@selector(explainButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *explainButtonItem = [[UIBarButtonItem alloc] initWithCustomView:explainButton];

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 30, 30);
    [shareButton setImage:[UIImage imageNamed:@"bar_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.navigationItem.rightBarButtonItems = @[shareButtonItem,explainButtonItem];
    
    [self addAllChildVcs];
}

- (void)explainButtonItem:(UIBarButtonItem *)btn{
    
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_PurchaseReleaseEditDelegate_image title:@"采购订单操作说明"];
}

- (void)onHistory{
/*
    YBLFoundViewModel *viewModel = [YBLFoundViewModel new];
    viewModel.myPurchaseType  = MyPurchaseTypePurchaseRecords;
    YBLFoundMyPurchaseViewController *myVC = [YBLFoundMyPurchaseViewController new];
    myVC.viewModel = viewModel;
    [self.navigationController pushViewController:myVC animated:YES];
 */
    if ([YBLMethodTools checkLoginWithVc:self]) {
        YBLCategoryViewModel *wantPurchaseVC_viewModel = [YBLCategoryViewModel new];
        wantPurchaseVC_viewModel.goodCategoryType = GoodCategoryTypeForPurchaseWithOutTabbar;
        YBLAddGoodViewController *wantPurchaseVC = [[YBLAddGoodViewController alloc] init];
        wantPurchaseVC.viewModel = wantPurchaseVC_viewModel;
        [self.navigationController pushViewController:wantPurchaseVC animated:YES];
    }
}

- (void)shareClick{
    
    YBLFoundViewController *foundVc = self.viewControllers[1];
    if (!foundVc.viewModel.dataModel) {
        return;
    }
    NSInteger all_count = foundVc.viewModel.dataModel.all_quantity.integerValue;
    float all_price = foundVc.viewModel.dataModel.all_order_price.doubleValue/10000;
    [YBLShareView shareViewWithPublishContentText:[NSString stringWithFormat:@"今天有%ld件的采购总量订单,正在焦急的等着它的主人~~~",(long)all_count]
                                            title:[NSString stringWithFormat:@"云采商城%.1f万元采购总金额的订单在等着它的供应商、手慢无!",all_price]
                                        imagePath:@"yuncai_icon"
                                              url:purchase_all_share_url
                                           Result:^(ShareType type, BOOL isSuccess) {}
                          ShareADGoodsClickHandle:^(){}];
    
}

- (void)goback{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  创建自定义tabbar
 */
- (void)addCustomTabBar
{
    self.delegate=self;
    
    // 创建自定义tabbar
    YBLTabBar *customTabBar = [[YBLTabBar alloc] init];
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
}

- (void)addAllChildVcs{
 
    YBLMyPurchaseViewModel *myPurchaseVC_viewModel = [YBLMyPurchaseViewModel new];
    YBLFoundMyPurchaseViewController *myPurchaseVC = [[YBLFoundMyPurchaseViewController alloc] init];
    myPurchaseVC.viewModel = myPurchaseVC_viewModel;
    [self addOneChlildVc:myPurchaseVC title:@"我的采购" imageName:@"purchase_me_normal" selectedImageName:@"purchase_me_select"];
    
    YBLFoundViewController *foundVC = [[YBLFoundViewController alloc] init];
    [self addOneChlildVc:foundVC title:@"采购首页" imageName:@"purhcase_home_normal" selectedImageName:@"purhcase_home_select"];
    
    YBLCategoryViewModel *wantPurchaseVC_viewModel = [YBLCategoryViewModel new];
    wantPurchaseVC_viewModel.goodCategoryType = GoodCategoryTypeForPurchaseWithTabbar;
    YBLAddGoodViewController *wantPurchaseVC = [[YBLAddGoodViewController alloc] init];
    wantPurchaseVC.viewModel = wantPurchaseVC_viewModel;
    [self addOneChlildVc:wantPurchaseVC title:@"发布采购" imageName:@"purhcase_release_normal" selectedImageName:@"purhcase_release_select"];
    
    //    YBLMyPurchaseViewModel *viewModel = [YBLMyPurchaseViewModel new];
    //    viewModel.myPurchaseType  = MyPurchaseTypePurchaseAllRecords;
    //    YBLFoundMyPurchaseViewController *myVC = [YBLFoundMyPurchaseViewController new];
    //    myVC.viewModel = viewModel;
    //    [self addOneChlildVc:myVC title:@"发布采购" imageName:@"wantpurchase_normal" selectedImageName:@"wantpurchase_select"];
    self.selectedIndex = 1;
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName
selectedImageName:(NSString *)selectedImageName {
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithOriginal:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithOriginal:selectedImageName];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //调整tabbarItem  图片的位置
    [childVc.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    [self addChildViewController:childVc];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:0]||viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        return [YBLMethodTools checkLoginWithVc:viewController];
    }
    return YES;
}

@end
