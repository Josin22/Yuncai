//
//  YBLTheResultViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTheResultViewController.h"
#import "YBLIndustryScaleViewController.h"

@interface YBLTheResultViewController ()

@end

@implementation YBLTheResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开店成功";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

- (void)goback1{
    self.tabBarController.selectedIndex = 4;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI{
 
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*2/3)];
    bgView.backgroundColor = YBLColor(45, 166, 244, 1);
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_kaidain"]];
    imageView.frame = CGRectMake(0, 0, 80, 80);
    imageView.centerX = bgView.width/2;
    imageView.top = bgView.height/2-80;
    [bgView addSubview:imageView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 40)];
    topLabel.top = bgView.height/2;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = YBLFont(17);
    topLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:topLabel];
    
    UILabel *topInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, bgView.width-space, 40)];
    topInfoLabel.top = topLabel.bottom;
    topInfoLabel.textAlignment = NSTextAlignmentCenter;
    topInfoLabel.font = YBLFont(13);
    topInfoLabel.numberOfLines = 2;
    topInfoLabel.text = @"审核通过就可以信用连接世界,生意从此简单";
    topInfoLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:topInfoLabel];
    
    if ([YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
        
        topLabel.text = @"您开店申请已通过审核~";
        
    } else if ([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected && !self.isAgain) {
        
//        topLabel.text = @"很遗憾,您未通过开店申请";
        NSString *reject = [YBLUserManageCenter shareInstance].userInfoModel.audit_reason;
        NSString *type = [YBLUserManageCenter shareInstance].userInfoModel.user_type;
        topLabel.text = reject;
        UIButton *tryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tryButton.frame = CGRectMake(2*space, bgView.bottom+2*space, YBLWindowWidth-4*space, 40);
        tryButton.layer.cornerRadius = 3;
        tryButton.layer.masksToBounds = YES;
        [tryButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        tryButton.layer.borderColor = YBLThemeColor.CGColor;
        tryButton.layer.borderWidth = 0.6;
        [tryButton setTitle:@"再次申请" forState:UIControlStateNormal];
        WEAK
        [[tryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            YBLIndustryScaleViewController *inducVC = [YBLIndustryScaleViewController new];
            inducVC.currentType = type;
            [self.navigationController pushViewController:inducVC animated:YES];
        }];
        
        [self.view addSubview:tryButton];
    } else {
        topLabel.text = @"开店申请成功,等待审核中";
    }
}

@end
