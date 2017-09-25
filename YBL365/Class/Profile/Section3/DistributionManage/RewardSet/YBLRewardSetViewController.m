//
//  YBLRewardSetViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRewardSetViewController.h"
#import "YBLEditPurchaseCell.h"
#import "YBLDistributionManageVC.h"

static NSInteger tag_reward_cell = 1564;

@interface YBLRewardSetViewController ()

@end

@implementation YBLRewardSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"赏金设置";
    
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    
    [self createUI];
}

- (void)saveClick:(UIBarButtonItem *)btn{
    
    YBLEditPurchaseCell *cell1 = [self.view viewWithTag:tag_reward_cell+0];
    YBLEditPurchaseCell *cell2 = [self.view viewWithTag:tag_reward_cell+1];
    NSString *money1 = cell1.valueTextFeild.text;
    NSString *money2 = cell2.valueTextFeild.text;
    if (money1.length==0||money2.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入完整金额~"];
        return;
    }
    [SVProgressHUD showWithStatus:@"设置中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *app_ids = [YBLMethodTools getAppendingStringWithArray:self.selectGoodsArray appendingKey:@","];
    para[@"ids"] = app_ids;
    para[@"total"] = money1;
    para[@"per"] = money2;
    
    [YBLRequstTools HTTPPostWithUrl:url_products_share_money
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  for (UIViewController *vc in self.navigationController.viewControllers) {
                                      if ([vc isKindOfClass:[YBLDistributionManageVC class]]) {
                                          [self.navigationController popToViewController:vc animated:YES];
                                      }
                                  }
                              });
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                
                            }];
}

- (void)createUI {

    NSInteger index = 0;
    NSArray *modelArray = @[[YBLEditItemGoodParaModel getModelWith:@"佣金总额 :"
                                                              type:EditTypeCellOnlyWrite
                                                      keyboardType:UIKeyboardTypeDecimalPad
                                                       placeholder:@"请输入佣金云币总额"],
                            [YBLEditItemGoodParaModel getModelWith:@"分享佣金 :"
                                                              type:EditTypeCellOnlyWrite
                                                      keyboardType:UIKeyboardTypeDecimalPad
                                                       placeholder:@"请输入分享云币佣金"],
                           ];
    CGFloat itemHi = 50;
    for (YBLEditItemGoodParaModel *model in modelArray) {
        
        YBLEditPurchaseCell *cell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.frame = CGRectMake(0, space+index*itemHi, YBLWindowWidth, itemHi);
        cell.tag = tag_reward_cell+index;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell updateItemCellModel:model];
        [self.view addSubview:cell];
        index++;
    }
    
}

@end
