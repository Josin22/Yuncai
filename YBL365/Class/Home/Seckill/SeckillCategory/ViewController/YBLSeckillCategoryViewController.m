//
//  YBLSeckillCategoryViewController.m
//  YBL365
//
//  Created by 乔同新 on 12/23/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillCategoryViewController.h"
#import "YBLSeckillTableView.h"
#import "YBLTextSegmentControl.h"
#import "YBLSeckillCategoryView.h"
#import "YBLSeckillRemandViewController.h"

static NSInteger bgView_tag = 199;

@interface YBLSeckillCategoryViewController ()<UIScrollViewDelegate,YBLTextSegmentControlDelegate>

@property (nonatomic, strong) UIScrollView *seckillScrollView;

@property (nonatomic, strong) YBLTextSegmentControl *textSegmentControl;

@property (nonatomic, strong) YBLSeckillCategoryView *categoryView;

@property (nonatomic, assign) NSInteger currentCategoryIndex;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *selectTitle;

@end

@implementation YBLSeckillCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setMyTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"云采秒杀";
    self.navigationItem.rightBarButtonItem = self.remandBarButtonItem;
    
    [self.view addSubview:self.textSegmentControl];
    [self.view addSubview:self.seckillScrollView];

}

- (void)updateTitleArray:(NSMutableArray *)data selectTitle:(NSString *)title{
    
    self.dataArray = data;
    self.selectTitle = title;
    
    [self.textSegmentControl updateTitleData:data];
    NSInteger index = [data indexOfObject:title];
    self.textSegmentControl.currentIndex = index;

}

#pragma mark - lazy load view
/*
- (YBLSeckillCategoryView *)categoryView{
    
    if (!_categoryView) {
        _categoryView = [[YBLSeckillCategoryView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 0)];
        WEAK
        _categoryView.seckillCategoryViewClickBlock = ^(NSString *title){
            STRONG
            [self textSegmentDefault];
    
            self.selectTitle = title;
            
            NSInteger index = [self.dataArray indexOfObject:title];
            self.categoryView.currentIndex = index;
            
            self.textSegmentControl.currentIndex = index;
            
            [self.seckillScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
            
        };
    }
    return _categoryView;
}

*/
- (YBLTextSegmentControl *)textSegmentControl{
    
    if (!_textSegmentControl) {
        _textSegmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textSegmentControl.frame), YBLWindowWidth, 40) TextSegmentType:TextSegmentTypeCategoryArrow];
        _textSegmentControl.delegate = self;
        WEAK
        _textSegmentControl.textSegmentControlShowAllBlock = ^(BOOL isShow){
            STRONG
            if (isShow) {
                /*
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textSegmentControl.frame), YBLWindowWidth, YBLWindowHeight)];
                bgView.backgroundColor = [BlackTextColor colorWithAlphaComponent:0.5];
                bgView.alpha = 0;
                bgView.tag = bgView_tag;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textSegmentDefault)];
                [bgView addGestureRecognizer:tap];
                bgView.userInteractionEnabled = NO;
                [self.view addSubview:bgView];
                
                [self.categoryView updateSeckillCategoryData:self.dataArray];
                NSInteger index = [self.dataArray indexOfObject:self.selectTitle];
                self.categoryView.currentIndex = index;
                
                [self.view addSubview:self.categoryView];
                [UIView animateWithDuration:.5f
                                      delay:0
                     usingSpringWithDamping:0.95
                      initialSpringVelocity:10
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     CGRect newFrame = [self.categoryView frame];
                                     newFrame.origin.y = CGRectGetMaxY(_textSegmentControl.frame);
                                     self.categoryView.frame = newFrame;
                                     bgView.alpha = 1;
                                 }
                                 completion:^(BOOL finished) {
                                     bgView.userInteractionEnabled = YES;
                                 }];
                 */
                
            } else {
                
                [self dismissCategoryView];
            }
                 
        };
                 
    }
    return _textSegmentControl;
}

- (UIScrollView *)seckillScrollView{
    
    if (!_seckillScrollView) {
        _seckillScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textSegmentControl.frame), self.textSegmentControl.width, YBLWindowHeight-self.textSegmentControl.height)];
        _seckillScrollView.pagingEnabled = YES;
        _seckillScrollView.showsHorizontalScrollIndicator = NO;
        _seckillScrollView.alwaysBounceHorizontal = YES;
        _seckillScrollView.delegate = self;
        _seckillScrollView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<20; i++) {
            
            YBLSeckillTableView *seckillTableView = [[YBLSeckillTableView alloc] initWithFrame:CGRectMake(_seckillScrollView.width* i, 0, _seckillScrollView.width, _seckillScrollView.height) style:UITableViewStylePlain Type:SeckillTableViewTypeCategoty];
            seckillTableView.test = 1;
            [_seckillScrollView addSubview:seckillTableView];
            
        }
        _seckillScrollView.contentSize = CGSizeMake(YBLWindowWidth*20, _seckillScrollView.height);
    }
    return _seckillScrollView;
}

#pragma mark - method 
- (void)dismissCategoryView{
    
    UIView *bgView = (UIView *)[self.view viewWithTag:bgView_tag];
    [UIView animateWithDuration:0.3
                     animations:^{
                         bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [bgView removeFromSuperview];
                     }];
    [self.categoryView removeFromSuperview];
}

- (void)textSegmentDefault{

    [self dismissCategoryView];
    
    [self.textSegmentControl defaultView];

}

#pragma mark -  seg delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    
    self.currentCategoryIndex = index;
    [self.seckillScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    self.selectTitle = self.dataArray[index];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    self.currentCategoryIndex = index;
    self.textSegmentControl.currentIndex = index;
    self.selectTitle = self.dataArray[index];
}

#pragma mark - 提醒

- (void)remandClick:(UIBarButtonItem *)btn{
    
    YBLSeckillRemandViewController *remandVC = [[YBLSeckillRemandViewController alloc] init];
    [self.navigationController pushViewController:remandVC animated:YES];
}

@end
