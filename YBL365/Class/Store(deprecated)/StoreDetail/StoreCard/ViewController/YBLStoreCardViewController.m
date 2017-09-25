//
//  YBLStoreCardViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreCardViewController.h"
#import "YBLStoreCardUIService.h"

@interface YBLStoreCardViewController ()
@property (nonatomic, strong) YBLStoreCardUIService * storeCardUIService;
@end

@implementation YBLStoreCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    // Do any additional setup after loading the view.
}

- (void)startUIService {
    self.title = @"店铺名片";
    self.storeCardUIService = [[YBLStoreCardUIService alloc]init];
    self.storeCardUIService.storeCardVC = self;
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
