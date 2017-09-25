//
//  YBLMarketGoodSettingViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMarketGoodSettingViewController.h"
#import "YBLMarketGoodSettingService.h"
#import "YBLEditPicItemModel.h"

@interface YBLMarketGoodSettingViewController ()

@property (nonatomic, strong) YBLMarketGoodSettingService *service;

@end

@implementation YBLMarketGoodSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.service = [[YBLMarketGoodSettingService alloc] initWithVC:self ViewModel:self.viewModel];
    
    if (self.viewModel.marketGoodVcType == MarketGoodVCTypeChoose) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage newImageWithNamed:@"login_close" size:CGSizeMake(26, 26)] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
        backItem.tintColor = YBLTextColor;
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = self.nextButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    }
}

- (void)goback{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextClick:(UIBarButtonItem *)btn{

    NSMutableArray *urlArray = @[].mutableCopy;
    for (YBLEditPicItemModel *itemModel in self.viewModel.picDataArray) {
        if (itemModel.isSelect) {
            [urlArray addObject:itemModel.good_pure_url];
        }
    }
    if (urlArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"你需要选择至少一张图片哟~"];
        if (self.service.titleViewSegment.currentIndex == 1) {
            self.service.titleViewSegment.currentIndex = 0;
        }
        return;
    }
    YBLWMarketGoodModel *model = [YBLWMarketGoodModel new];
    model.selectImageArray = urlArray;
    BLOCK_EXEC(self.viewModel.changeBlock,model);
    [self goback];

}

- (void)saveClick:(UIBarButtonItem *)btn{

    if (self.viewModel.picDataArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有添加图片哟~"];
        return;
    }
    //        if (self.viewModel.marketGoodModel.copywritings.count==0) {
    //            [SVProgressHUD showErrorWithStatus:@"您还没有添加文案哟~"];
    //            return;
    //        }
    WEAK
    [[self.viewModel siganlForSetWMarket] subscribeNext:^(YBLWMarketGoodModel *changeModel) {
        STRONG
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.viewModel.changeBlock,changeModel);
            [self.navigationController popViewControllerAnimated:YES];
        });
    } error:^(NSError * _Nullable error) {
        
    }];

}

- (void)goback1{
    
    [YBLOrderActionView showTitle:@"您正在编辑商品文案,确定要离开编辑吗?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                      cancelBlock:^{
                          
                      }];
}

@end
