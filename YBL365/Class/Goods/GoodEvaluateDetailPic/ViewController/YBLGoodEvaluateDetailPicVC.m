//
//  YBLGoodEvaluateDetailPicVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLGoodEvaluateDetailPicService.h"
#import "YBLOrderCommentsItemModel.h"
#import "YBLGoodEvaluateDetailPicViewModel.h"

@interface YBLGoodEvaluateDetailPicVC ()

@property (nonatomic, strong) YBLGoodEvaluateDetailPicService *service;

@property (nonatomic, strong) YBLGoodEvaluateDetailPicViewModel *viewModel;

@end

@implementation YBLGoodEvaluateDetailPicVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    self.service = [[YBLGoodEvaluateDetailPicService alloc] initWithVC:self ViewModel:self.viewModel];
}

+ (void)pushFromVc:(UIViewController *)selfVc commentModel:(YBLOrderCommentsModel *)commentModel imageView:(UIImageView *)imageView{
    NSMutableArray *items = @[].mutableCopy;
    for (NSString *url in commentModel.pictures) {
        KSPhotoItem *itemModel = [[KSPhotoItem alloc] initWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
        [items addObject:itemModel];
    }
    YBLGoodEvaluateDetailPicViewModel *viewModel = [YBLGoodEvaluateDetailPicViewModel new];
    viewModel.commentModel = commentModel;
    YBLGoodEvaluateDetailPicVC *detailPicVc = [[YBLGoodEvaluateDetailPicVC alloc] initWithPhotoItems:items selectedIndex:commentModel.currentIndex];
    detailPicVc.viewModel = viewModel;
    detailPicVc.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    detailPicVc.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    detailPicVc.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    detailPicVc.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    detailPicVc.bounces = NO;
    [detailPicVc showFromViewController:selfVc];
}

@end
