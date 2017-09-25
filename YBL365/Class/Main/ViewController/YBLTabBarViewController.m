//
//  YBLTabBarViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLTabBarViewController.h"
#import "YBLTabBar.h"
#import "YBLHomeViewController.h"
#import "YBLCategoryViewController.h"
#import "YBLShopCarViewController.h"
#import "YBLProfileViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLFoundViewController.h"
#import "UITabBar+BageValue.h"
#import "YBLFoundTabBarViewController.h"

@interface YBLTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation YBLTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建自定义tabbar
    [self addCustomTabBar];
    // 添加所有的子控制器
    [self addAllChildVcs];
    //观察购物车角标
    [self notifiCarNumber];
}

- (void)notifiCarNumber {
    WEAK
    [RACObserve([YBLUserManageCenter shareInstance], cartsCount) subscribeNext:^(id x) {
        STRONG
        [self.tabBar setBadgeValue:[YBLUserManageCenter shareInstance].cartsCount AtIndex:3];
    }];
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

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs
{
    YBLHomeViewController *home = [[YBLHomeViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"tabBar_home_normal" selectedImageName:@"tabBar_home_press"];
    
    YBLCategoryViewModel *category_viewModel = [YBLCategoryViewModel new];
    category_viewModel.goodCategoryType = GoodCategoryTypeForHomeCategory;
    YBLCategoryViewController *category = [[YBLCategoryViewController alloc] init];
    category.viewModel = category_viewModel;
    [self addOneChlildVc:category title:@"分类" imageName:@"tabBar_category_normal" selectedImageName:@"tabBar_category_press"];
    
    UIViewController *found = [[UIViewController alloc] init];
    found.tabBarItem.tag = Tab_bar_Tag;
    [self addOneChlildVc:found title:@"发现" imageName:@"tabBar_find_normal" selectedImageName:@"tabBar_find_press"];
    
    YBLShopCarViewModel *viewModel = [[YBLShopCarViewModel alloc] init];
    viewModel.carVCType = CarVCTypeNormal;
    YBLShopCarViewController *shop = [[YBLShopCarViewController alloc] init];
    shop.viewModel = viewModel;
    [self addOneChlildVc:shop title:@"购物车" imageName:@"tabBar_cart_normal" selectedImageName:@"tabBar_cart_press"];
    [shop.tabBarController.tabBar showBadgeOnItemIndex:3];
    
    YBLProfileViewController *me = [[YBLProfileViewController alloc] init];
    [self addOneChlildVc:me title:@"我的" imageName:@"tabBar_my_normal" selectedImageName:@"tabBar_my_press"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithOriginal:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithOriginal:selectedImageName];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //调整tabbarItem  图片的位置
    [childVc.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    // 添加为tabbar控制器的子控制器
    YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

//禁止tab多次点击
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //这里我判断的是当前点击的tabBarItem的标题
    if (viewController.tabBarItem.tag == Tab_bar_Tag) {

        YBLFoundTabBarViewController *foundTabBarVC = [YBLFoundTabBarViewController new];
        [((UINavigationController *)tabBarController.selectedViewController) pushViewController:foundTabBarVC animated:YES];
        
        return NO;

    } else {
        return YES;
    }
    
}


@end
