//
//  YBLGoodsClassifyViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLGoodsClassifyViewController.h"
#import "YBLGoodsClassifyUIService.h"

@interface YBLGoodsClassifyViewController ()
@property (nonatomic, strong) YBLGoodsClassifyUIService * goodsClassifyUIService;
@property (nonatomic, strong) UITableView * goodsClassifyTab;
@end

@implementation YBLGoodsClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
    // Do any additional setup after loading the view.
}

- (void)startUIService {
    self.goodsClassifyUIService = [[YBLGoodsClassifyUIService alloc]init];
    
}

- (void)addSubViews {
    self.title = @"商品分类";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"ybl_navgation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    [self.view addSubview:self.goodsClassifyTab];
}

- (UITableView *)goodsClassifyTab {
    if (!_goodsClassifyTab) {
        _goodsClassifyTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStyleGrouped];
        _goodsClassifyTab.dataSource = self.goodsClassifyUIService;
        _goodsClassifyTab.delegate = self.goodsClassifyUIService;
        _goodsClassifyTab.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _goodsClassifyTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_goodsClassifyTab registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _goodsClassifyTab;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
