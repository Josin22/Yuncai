//
//  YBLStoreViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreViewController.h"
#import "YBLStoreUIService.h"
#import "YBLGoodsClassifyViewController.h"

@interface YBLStoreViewController ()
@property (nonatomic, strong) YBLStoreUIService * storeUIService;//店铺UI服务
@property (nonatomic, strong) UIButton * moreButton;
@property (nonatomic, strong) UIButton * categoryBtn;

@end

@implementation YBLStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    
    [self startUIService];
    
    [self addSubViews];
    
}

- (void)createNavigationBar {
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"ybl_navgation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.frame = CGRectMake(YBLWindowWidth-98, 20, 40, 44);
    [self.moreButton setImage:[UIImage newImageWithNamed:@"store_more" size:CGSizeMake(27, 25)] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryBtn.frame = CGRectMake(YBLWindowWidth - 44 - 5, 20, 40, 44);
    [self.categoryBtn setTitle:@"分类" forState:UIControlStateNormal];
    [self.categoryBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self.categoryBtn setImage:[UIImage newImageWithNamed:@"store_classify" size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    self.categoryBtn.titleLabel.font = YBLFont(11);
    [self.categoryBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 13, 0, 0)];
    [self.categoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
    [self.categoryBtn addTarget:self action:@selector(categoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * categoryBtn = [[UIBarButtonItem alloc]initWithCustomView:self.categoryBtn];
    UIBarButtonItem * moreButton = [[UIBarButtonItem alloc]initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreButton,categoryBtn, nil] ;
}

#pragma mark -  开启UI服务

- (void)startUIService {
    self.storeUIService = [[YBLStoreUIService alloc] init];
    self.storeUIService.storeVC = self;
}

#pragma mark -  add view
- (void)addSubViews {
        
}

#pragma mark - 返回
//- (void)backButtonClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - 更多
- (void)moreButtonClick {
    //更多
}

#pragma mark - 分类
- (void)categoryBtnClick {
//    分类
    YBLGoodsClassifyViewController * goodsClassifyVC = [[YBLGoodsClassifyViewController alloc]init];
    [self.navigationController pushViewController:goodsClassifyVC animated:YES];
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
