//
//  YBLStoreShopDynamicViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreShopDynamicViewController.h"
#import "YBLStoreDynamicUIService.h"

@interface YBLStoreShopDynamicViewController ()
@property (nonatomic, strong) YBLStoreDynamicUIService * storeDynamicUIService;
@property (nonatomic, strong) UITableView * storeDynamicTab;
@end

@implementation YBLStoreShopDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
}

- (void)startUIService {
    self.storeDynamicUIService = [[YBLStoreDynamicUIService alloc]init];
}

- (void)addSubViews {
    [self.view addSubview:self.storeDynamicTab];
}

- (UITableView *)storeDynamicTab {
    if (!_storeDynamicTab) {
        _storeDynamicTab = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _storeDynamicTab.backgroundColor = [UIColor redColor];
        _storeDynamicTab.dataSource = self.storeDynamicUIService;
        _storeDynamicTab.delegate = self.storeDynamicUIService;
        _storeDynamicTab.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _storeDynamicTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _storeDynamicTab.showsVerticalScrollIndicator = NO;
        [_storeDynamicTab registerNib:[UINib nibWithNibName:@"YBLStoreDynamicCell" bundle:nil] forCellReuseIdentifier:@"YBLStoreDynamicCell"];
        UILabel * headerLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 25)];
        headerLab.backgroundColor = [UIColor whiteColor];
        headerLab.textAlignment = NSTextAlignmentCenter;
        headerLab.text = [NSString stringWithFormat:@"\"%@\"",@"下面是我店铺的动态，欢迎查看！"];
        headerLab.textColor = [UIColor lightGrayColor];
        headerLab.font = YBLFont(14);
        _storeDynamicTab.tableHeaderView = headerLab;
    }
    return _storeDynamicTab;
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
