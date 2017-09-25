//
//  YBLTwotageMuduleViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTwotageMuduleViewController.h"
#import "YBLTwotageMuduleService.h"
#import "YBLPopView.h"
#import "YBLGoodSearchView.h"

@interface YBLTwotageMuduleViewController ()

@property (nonatomic, strong) YBLTwotageMuduleService *service;

@end

@implementation YBLTwotageMuduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.viewModel.titleText;
    
    self.service = [[YBLTwotageMuduleService alloc] initWithVC:self ViewModel:self.viewModel];
    
    self.navigationItem.rightBarButtonItem = self.moreBarButtonItem;
}

#pragma mark - bar item click

- (void)moreClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                               
                                                         titles:@[@"搜索",@"首页"]
                                                         images:@[@"xn_more_search",@"xn_more_home"]];
    WEAK
    
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        
        STRONG
        
        switch (index) {
            case 0:
            {//搜索
                //搜索
                [YBLGoodSearchView showGoodSearchViewWithVC:self
                                          RightItemViewType:rightItemViewTypeCatgeoryNews
                                               SearchHandle:^(NSString *searchText, SearchType searchType) {
                                                   
                                               }
                                               cancleHandle:^{
                                                   
                                               }
                                         animationEndHandle:^{
                                             
                                         }
                                                currentText:nil];
            }
                break;
            case 1:
            {//首页
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
           
            default:
                break;
        }
    };
    [morePopView show];
}



@end
