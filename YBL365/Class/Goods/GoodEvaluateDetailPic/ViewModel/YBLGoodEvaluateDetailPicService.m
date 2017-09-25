//
//  YBLGoodEvaluateDetailPicService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateDetailPicService.h"
#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLGoodEvaluateDetailPicViewModel.h"

@interface YBLGoodEvaluateDetailPicService ()


@property (nonatomic, weak) YBLGoodEvaluateDetailPicVC *Vc;

@property (nonatomic, strong) YBLGoodEvaluateDetailPicViewModel *viewModel;


@end

@implementation YBLGoodEvaluateDetailPicService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLGoodEvaluateDetailPicVC *)VC;
        _viewModel = (YBLGoodEvaluateDetailPicViewModel *)viewModel;
        
    }
    return self;
}



@end
