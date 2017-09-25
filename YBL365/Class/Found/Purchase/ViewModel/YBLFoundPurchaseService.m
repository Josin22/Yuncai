//
//  YBLFoundPurchaseService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundPurchaseService.h"
#import "YBLTextSegmentControl.h"
#import "YBLFoundSegmentSPECView.h"
#import "YBLFoundPurchaseViewController.h"
#import "YBLChooseCityView.h"
#import "YBLFoundPurchaseTableView.h"
#import "YBLEditPurchaseViewController.h"

static NSInteger bgView_tag = 9897;

@interface YBLFoundPurchaseService ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate>
{
    NSInteger currentFoundIndex;
}
@property (nonatomic, strong) YBLTextSegmentControl *textSegmentControl;

@property (nonatomic, strong) YBLFoundSegmentSPECView *SPECView;

@property (nonatomic, strong) UIScrollView *purchaseScrollView;

@property (nonatomic, weak) YBLFoundPurchaseViewController *VC;

@end

@implementation YBLFoundPurchaseService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _VC = (YBLFoundPurchaseViewController *)VC;
        
        [_VC.view addSubview:self.textSegmentControl];
        [_VC.view addSubview:self.purchaseScrollView];

        [self createItem];
    }
    return self;
}

- (void)createItem{
    
    if (self.VC.purchaseType == PurchaseTypeTab) {
        
        UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addressButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
        addressButton.frame = CGRectMake(0, 0, 40, 40);
        [addressButton addTarget:self action:@selector(pushAddressView) forControlEvents:UIControlEventTouchUpInside];
        self.VC.tabBarController.navigationItem.rightBarButtonItems = @[self.VC.shareBarButtonItem,[[UIBarButtonItem alloc] initWithCustomView:addressButton]];
        
    } else {
        
        UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addressButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
        addressButton.frame = CGRectMake(0, 0, 40, 40);
        [addressButton addTarget:self action:@selector(pushAddressView) forControlEvents:UIControlEventTouchUpInside];
        self.VC.navigationItem.rightBarButtonItems = @[self.VC.shareBarButtonItem,[[UIBarButtonItem alloc] initWithCustomView:addressButton]];
    }
}

#pragma mark - lazy load view

- (YBLTextSegmentControl *)textSegmentControl{
    
    if (!_textSegmentControl) {
        _textSegmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textSegmentControl.frame), YBLWindowWidth, 40) TextSegmentType:TextSegmentTypeCategoryArrow];
        _textSegmentControl.delegate = self;
        WEAK
        _textSegmentControl.textSegmentControlShowAllBlock = ^(BOOL isShow){
            STRONG
            if (isShow) {
                
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textSegmentControl.frame)+64, YBLWindowWidth, YBLWindowHeight)];
                bgView.backgroundColor = [BlackTextColor colorWithAlphaComponent:0.5];
                bgView.alpha = 0;
                bgView.tag = bgView_tag;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textSegmentDefault)];
                [bgView addGestureRecognizer:tap];
                bgView.userInteractionEnabled = NO;
                [self.VC.tabBarController.view addSubview:bgView];
                
                [self.SPECView updateSPECArray1:[@[@"黄酒",@"白酒",@"泡酒",@"女儿红",@"泡酒",@"黄酒",@"白酒",@"泡酒",@"女儿红",@"泡酒"] mutableCopy]
                                         array2:[@[@"吸纳酒",@"老白酒",@"新新酒业",@"大大酒业",@"盼盼酒业",@"成建酒业",@"吸纳酒",@"老白酒",@"新新酒业",@"大大酒业",@"老白酒",@"新新酒业",@"大大酒业",@"盼盼酒业",@"成建酒业",@"吸纳酒",@"老白酒",@"新新酒业",@"大大酒业"] mutableCopy]];
                
                [self.VC.tabBarController.view addSubview:self.SPECView];
                [UIView animateWithDuration:.5f
                                      delay:0
                     usingSpringWithDamping:0.95
                      initialSpringVelocity:10
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     CGRect newFrame = [self.SPECView frame];
                                     newFrame.origin.y = CGRectGetMaxY(_textSegmentControl.frame)+64;
                                     self.SPECView.frame = newFrame;
                                     bgView.alpha = 1;
                                 }
                                 completion:^(BOOL finished) {
                                     bgView.userInteractionEnabled = YES;
                                 }];
                
            } else {
                
                [self dismissCategoryView];
            }
        };
        [self.textSegmentControl updateTitleData:[@[@"中外名酒",@"休闲食品",@"清洁日常",@"洗护用品",@"母婴",@"成人用品",@"日常",@"食品",@"零食",@"里来了"] mutableCopy]];
        self.textSegmentControl.currentIndex = 0;
    }
    return _textSegmentControl;
}

- (UIScrollView *)purchaseScrollView{
    
    if (!_purchaseScrollView) {
        
        NSInteger tempCount = 10;
        CGFloat tabCount = 49;
        if (self.VC.purchaseType == PurchaseTypeSingle) {
            tabCount = 0;
        }
        _purchaseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textSegmentControl.frame), self.textSegmentControl.width, YBLWindowHeight-self.textSegmentControl.height-tabCount)];
        _purchaseScrollView.pagingEnabled = YES;
        _purchaseScrollView.showsHorizontalScrollIndicator = NO;
        _purchaseScrollView.alwaysBounceHorizontal = YES;
        _purchaseScrollView.delegate = self;
        _purchaseScrollView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<tempCount; i++) {
            
            YBLFoundPurchaseTableView *purchaseTableView = [[YBLFoundPurchaseTableView alloc] initWithFrame:CGRectMake(_purchaseScrollView.width* i, 0, _purchaseScrollView.width, _purchaseScrollView.height-64) style:UITableViewStylePlain];
            WEAK
            purchaseTableView.foundPurchaseTableViewCellSelectBlock = ^(){
                STRONG
                YBLEditPurchaseViewController *edictpurchaseVC = [[YBLEditPurchaseViewController alloc] init];
                
                if (self.VC.purchaseType == PurchaseTypeTab) {
                    [self.VC.tabBarController.navigationController pushViewController:edictpurchaseVC animated:YES];
                } else {
                    [self.VC.navigationController pushViewController:edictpurchaseVC animated:YES];

                }
            };
            [_purchaseScrollView addSubview:purchaseTableView];
        }
        _purchaseScrollView.contentSize = CGSizeMake(YBLWindowWidth*tempCount, _purchaseScrollView.height);
    }
    return _purchaseScrollView;
}

- (YBLFoundSegmentSPECView *)SPECView{
    
    if (!_SPECView) {
        _SPECView = [[YBLFoundSegmentSPECView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
        WEAK
        _SPECView.foundSegmentSPECViewSureBlock = ^(NSArray *value){
            STRONG
            [self textSegmentDefault];
        };
    }
    return _SPECView;
}

#pragma mark - method

- (void)textSegmentDefault{
    
    [self dismissCategoryView];
    
    [self.textSegmentControl defaultView];
    
}


- (void)dismissCategoryView{
    
    UIView *bgView = (UIView *)[self.VC.tabBarController.view viewWithTag:bgView_tag];
    [UIView animateWithDuration:0.3
                     animations:^{
                         bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.SPECView.top = 0;
                         [bgView removeFromSuperview];
                     }];
    [self.SPECView removeFromSuperview];
    
    
}

- (void)pushAddressView{
    
    UIViewController *vc = nil;
    
    if (self.VC.purchaseType == PurchaseTypeTab) {
        vc = self.VC.tabBarController.navigationController;
    } else {
        vc = self.VC.navigationController;
    }
    [YBLChooseCityView chooseCityWithViewController:vc
                                       cityViewType:cityViewTypeTwo
                                       successBlock:^(YBLAddressAreaModel *model,NSMutableArray *selectArray){
                                           
                                       }];
}


#pragma mark -  seg delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    
    currentFoundIndex = index;
    [self.purchaseScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    currentFoundIndex = index;
    self.textSegmentControl.currentIndex = index;
    
}

@end
