//
//  YBLSeckillViewController.m
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillViewController.h"
#import "YBLSeckillSegmentControl.h"
#import "YBLSeckillTableView.h"
#import "YBLSeckillViewModel.h"
#import "YBLSeckillCategoryView.h"
#import "YBLSeckillCategoryViewController.h"
#import "YBLPopView.h"


@interface YBLSeckillViewController ()<YBLSeckillSegmentControlDelegate,UIScrollViewDelegate>
{
    BOOL isShowCategoryView;
}
@property (nonatomic, strong) YBLSeckillSegmentControl *segment;

@property (nonatomic, strong) YBLSeckillViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *seckillScrollView;

@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, strong) YBLSeckillCategoryView *categoryView;

@end

@implementation YBLSeckillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_seckill"]];
    
//    self.navigationItem.rightBarButtonItems = @[self.moreBarButtonItem,self.categoryButtonItem];
    
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar hiddenLineView];
    [self setMyTranslucent:NO];
    
    isShowCategoryView = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar showLineView];
}


#pragma mark -  bar click method


#pragma mark - add view

- (void)addSubViews{
    
    [self.view addSubview:self.segment];
    [self.view addSubview:self.seckillScrollView];
}


#pragma mark - lazy load view

- (YBLSeckillViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[YBLSeckillViewModel alloc] init];
    }
    return _viewModel;
}

- (YBLSeckillSegmentControl *)segment{
    
    if (!_segment) {
        _segment = [[YBLSeckillSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 50)];
        _segment.delegate = self;
        _segment.backgroundColor = [UIColor whiteColor];
        _segment.timesArray = [@[@"10:00",@"12:00",@"14:00",@"16:00",@"18:00"] mutableCopy];
    }
    return _segment;
}

- (UIScrollView *)seckillScrollView{
    
    if (!_seckillScrollView) {
        _seckillScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), self.segment.width, YBLWindowHeight-CGRectGetMaxY(self.segment.frame))];
        _seckillScrollView.pagingEnabled = YES;
        _seckillScrollView.showsHorizontalScrollIndicator = NO;
        _seckillScrollView.alwaysBounceHorizontal = YES;
        _seckillScrollView.delegate = self;
        _seckillScrollView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<5; i++) {
     
            YBLSeckillTableView *seckillTableView = [[YBLSeckillTableView alloc] initWithFrame:CGRectMake(_seckillScrollView.width* i, 0, _seckillScrollView.width, _seckillScrollView.height) style:UITableViewStyleGrouped Type:SeckillTableViewTypeDefault];
            seckillTableView.test = [self.viewModel.testArray[i] integerValue];
            seckillTableView.seckillVC = self;
            [_seckillScrollView addSubview:seckillTableView];
   
        }
        _seckillScrollView.contentSize = CGSizeMake(YBLWindowWidth*5, _seckillScrollView.height);
    }
    return _seckillScrollView;
}



#pragma mark -  seg delegate

- (void)seckillSegmentControlIndex:(NSInteger)index{
    
    self.currentTime = index;
    [self.seckillScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    self.currentTime = index;
    [self.segment setCurrentIndex:index];
}

- (void)moreClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                                                         titles:@[@"搜索",@"首页"]
                                                         images:@[@"xn_more_search",@"xn_more_home"]];
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        switch (index) {
            case 0:
            {//搜索
                
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
