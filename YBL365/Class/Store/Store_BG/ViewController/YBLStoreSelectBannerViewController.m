//
//  YBLStoreSelectBannerViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreSelectBannerViewController.h"
#import "YBLStoreBannerModel.h"
#import "YBLGoodsBannerView.h"
#import "YBLCustomNavgationBar.h"

@interface YBLStoreSelectBannerViewController ()<YBLGoodsBannerDelegate>

@property (nonatomic, strong) YBLGoodsBannerView    *bannerView;

@property (nonatomic, strong) YBLCustomNavgationBar *navBar;

@property (nonatomic, strong) UIView                *settingView;

@end

@implementation YBLStoreSelectBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.navBar];
    
    [self.view addSubview:self.bannerView];
    
    [self.view addSubview:self.settingView];
    
    [self requestData];
    
}


- (UIView *)settingView{
    
    if (!_settingView) {
        _settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
        _settingView.bottom = YBLWindowHeight;
        _settingView.backgroundColor = YBLColor(51, 51, 51, 1);
        UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [setButton setTitle:@"设置背景图" forState:UIControlStateNormal];
        setButton.frame = CGRectMake(0, 0, 80, _settingView.height*3/4);
        setButton.centerX = _settingView.width/2;
        setButton.centerY  =_settingView.height/2;
        setButton.layer.cornerRadius = 3;
        setButton.layer.masksToBounds = YES;
        [setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
        setButton.titleLabel.font = YBLFont(13);
        [_settingView addSubview:setButton];
        WEAK
        [[setButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self requestsetting];
        }];
        
    }
    return _settingView;
}

- (YBLCustomNavgationBar *)navBar{
    
    if (!_navBar) {
        _navBar = [[YBLCustomNavgationBar alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        WEAK
        [[_navBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl * _Nullable x) {
            STRONG
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _navBar.titleLabel.text = @"选择背景图";
    }
    return _navBar;
}

- (YBLGoodsBannerView *)bannerView{
    
    if (!_bannerView) {
        _bannerView = [[YBLGoodsBannerView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight*2-self.navBar.bottom)
                                                  imageURLArray:nil
                                            goodsBannerViewType:GoodsBannerViewTypeStoreBannerSetting];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (void)requestData {
    
    WEAK
    [[self.viewModel siganlForAllStoreBanner] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.bannerView.imageURLArray = self.viewModel.pureImageURLArray;
        
    } error:^(NSError * _Nullable error) {
        
    }];
}


- (void)hiddenView:(BOOL)isHidden{
    
    [UIView animateWithDuration:.3 animations:^{
        if (isHidden) {
            self.navBar.bottom = 0;
            self.settingView.top = YBLWindowHeight;
        } else {
            self.navBar.top = 0;
            self.settingView.bottom = YBLWindowHeight;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)requestsetting{
    
    [[self.viewModel siganlForSettingStoreBanner] subscribeNext:^(YBLStoreBannerModel*  _Nullable x) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.viewModel.storeSelectBannerViewModelChangeBlock,x.fixture_picture.picture)
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)banner:(YBLGoodsBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    
    self.viewModel.isShow = !self.viewModel.isShow;
    [self hiddenView:self.viewModel.isShow];
}

- (void)banner:(YBLGoodsBannerView *)bannerView currentItemAtIndex:(NSInteger)index{
    
    YBLStoreBannerModel *itemMdoel = self.viewModel.dataArray[index];
    self.viewModel.select_id = itemMdoel._id;
}

@end
