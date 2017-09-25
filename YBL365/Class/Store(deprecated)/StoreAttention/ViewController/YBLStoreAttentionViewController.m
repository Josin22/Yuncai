//
//  YBLStoreAttentionViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreAttentionViewController.h"
#import "YBLStoreAttentionUIService.h"

@interface YBLStoreAttentionViewController ()
@property (nonatomic, strong) YBLStoreAttentionUIService * storeAttentionUIService;
@property (nonatomic, strong) UITableView * storeAttentionTab;
@end

@implementation YBLStoreAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
    // Do any additional setup after loading the view.
}

- (void)startUIService {
    self.storeAttentionUIService = [[YBLStoreAttentionUIService alloc]init];
}

- (void)addSubViews {
    [self.view addSubview:self.storeAttentionTab];
}

- (UITableView *)storeAttentionTab {
    if (!_storeAttentionTab) {
        _storeAttentionTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStylePlain];
        _storeAttentionTab.dataSource = self.storeAttentionUIService;
        _storeAttentionTab.delegate = self.storeAttentionUIService;
        _storeAttentionTab.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _storeAttentionTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_storeAttentionTab registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _storeAttentionTab;
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
