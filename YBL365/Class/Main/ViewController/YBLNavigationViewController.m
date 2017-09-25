//
//  YBLNavigationViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLNavigationViewController.h"
#import "YBLShopCarViewModel.h"
#import "YBLNetWorkHudBar.h"

@interface YBLNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    BOOL isEnable;
}

@property (nonatomic, strong) NSArray *classNameArray;

@property (nonatomic, strong) NSArray *homeTopClassNameArray;

@end

@implementation YBLNavigationViewController

- (void)setIsPopGestureRecognizerEnable:(BOOL)isPopGestureRecognizerEnable{
    isEnable = isPopGestureRecognizerEnable;
}

/**
 * 定制UINavigationBar
 */
+ (void)initialize {
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    [navigationBar setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName:YBLColor(40, 40, 40, 1.0),
                                            NSFontAttributeName:[UIFont systemFontOfSize:17],
                                            NSShadowAttributeName:shadow
                                            }];
    [navigationBar setBackgroundImage:[UIImage createImageWithColor:YBLColor(255, 255, 255, 0.99) frame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    for (NSString *className in self.homeTopClassNameArray) {
        if ([self.visibleViewController isKindOfClass:NSClassFromString(className)]) {
            //
            [self requestCartNumber];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加一条线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    lineView.tag = 999;
    [self.navigationBar addSubview:lineView];
    
    __weak YBLNavigationViewController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
}

- (void)requestCartNumber{

    [YBLShopCarViewModel getCurrentCartsNumber];
}

- (NSArray *)classNameArray{
    if (!_classNameArray) {
        _classNameArray = @[@"YBLCategoryViewController",
                            @"YBLProfileViewController",
                            @"YBLHomeViewController",
                            @"YBLStoreSelectBannerViewController",
                            @"YBLOrderExpressImageBrowerVC",
                            @"YBLScanQRCodeViewController"];
    }
    return _classNameArray;
}

- (NSArray *)homeTopClassNameArray{
    if (!_homeTopClassNameArray) {
        _homeTopClassNameArray = @[
                                   @"YBLHomeViewController",
                                   @"YBLCategoryViewController",
                                   @"YBLShopCarViewController",
                                   @"YBLProfileViewController"
                                   ];
    }
    return _homeTopClassNameArray;
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated

{
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){
        
        self.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    return [super popToRootViewControllerAnimated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        
        self.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    return [super popToViewController:viewController animated:animated];
    
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        if (navigationController.childViewControllers.count == 1) {
            
            self.interactivePopGestureRecognizer.enabled = NO;
            
        }else
            
        self.interactivePopGestureRecognizer.enabled = isEnable;
        
    }
    
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = NO;
    for (NSString *className in self.classNameArray) {
        if ([viewController isKindOfClass:[NSClassFromString(className) class]]){
            isShowHomePage = YES;
        }
    }
    [viewController.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)dealloc
{
    NSLog(@"%@----dealloc",self.class);
    
}

@end
