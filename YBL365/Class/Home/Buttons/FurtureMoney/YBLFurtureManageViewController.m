//
//  YBLFurtureManageViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFurtureManageViewController.h"
#import "YBLFurtureDetailViewController.h"

@interface YBLFurtureManageViewController ()

@end

@implementation YBLFurtureManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"收益管理";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self createUI];
}

- (void)createUI{
    
    UILabel *title1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, space*2, YBLWindowWidth, 20)];
    title1Label.text = @"今日收益";
    title1Label.textColor = YBLTextColor;
    title1Label.font = YBLFont(15);
    title1Label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title1Label];
    
    UILabel *todayMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(title1Label.left, title1Label.bottom+space, title1Label.width, 30)];
    todayMoneyLabel.text = @"00";
    todayMoneyLabel.textColor = YBLThemeColor;
    todayMoneyLabel.font = YBLBFont(25);
    todayMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:todayMoneyLabel];
    
    UILabel *title2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, todayMoneyLabel.bottom+space, title1Label.width, title1Label.height)];
    title2Label.text = @"累计收益";
    title2Label.textColor = YBLTextColor;
    title2Label.font = YBLFont(15);
    title2Label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title2Label];
    
    UILabel *allMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(title2Label.left, title2Label.bottom+space, title2Label.width, title2Label.height)];
    allMoneyLabel.text = @"13.00";
    allMoneyLabel.textColor = BlackTextColor;
    allMoneyLabel.font = YBLFont(15);
    allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allMoneyLabel];
    
    UIView *furtureView = [[UIView alloc] initWithFrame:CGRectMake(0, allMoneyLabel.bottom+space*2, allMoneyLabel.width, 40)];
    [self.view addSubview:furtureView];
    UILabel *furtureLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 60, furtureView.height)];
    [furtureView addSubview:furtureLabel];
    furtureLabel.text = @"未来收益";
    furtureLabel.textColor = BlackTextColor;
    furtureLabel.font = YBLFont(14);
    
    UIButton *furtureMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [furtureView addSubview:furtureMoneyButton];
    furtureMoneyButton.frame = CGRectMake(furtureLabel.right, 0, furtureView.width-furtureLabel.right-space*3-8, furtureView.height);
    furtureMoneyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [furtureMoneyButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [furtureMoneyButton setTitle:@"200.00" forState:UIControlStateNormal];
    furtureMoneyButton.titleLabel.font = YBLFont(14);
    WEAK
    [[furtureMoneyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLFurtureDetailViewController *furdetailVC = [YBLFurtureDetailViewController new];
        [self.navigationController pushViewController:furdetailVC animated:YES];
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.center = CGPointMake(furtureMoneyButton.right+20, furtureView.height/2);
    [furtureView addSubview:arrowImageView];
    [furtureView addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, furtureView.width, 0.5)]];
    [furtureView addSubview:[YBLMethodTools addLineView:CGRectMake(0, furtureView.height-0.5, furtureView.width, 0.5)]];
    
    
    UIButton *mywalletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mywalletButton.frame = CGRectMake(space, furtureView.bottom+2*space, YBLWindowWidth-2*space, 40);
    mywalletButton.layer.cornerRadius = 3;
    mywalletButton.layer.masksToBounds = YES;
    [mywalletButton setTitle:@"我的钱包" forState:UIControlStateNormal];
    mywalletButton.titleLabel.font = YBLFont(15);
    [mywalletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mywalletButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.view addSubview:mywalletButton];
}


@end
