
//
//  YBLAreaRadiusService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAreaRadiusService.h"
#import "YBLAreaRadiusViewController.h"
#import "YBLExpressPriceTableView.h"
#import "YBLAreaRadiusItemModel.h"
#import "YBLShowSelectAreaRadiusView.h"

@interface YBLAreaRadiusService()

@property (nonatomic, weak) YBLAreaRadiusViewController *Vc;

@property (nonatomic, strong) YBLAreaRadiusViewModel *viewModel;

@property (nonatomic, strong) YBLExpressPriceTableView *areaRadiusTableView;

@end

@implementation YBLAreaRadiusService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {

        _Vc = (YBLAreaRadiusViewController *)VC;
        _viewModel = (YBLAreaRadiusViewModel *)viewModel;
        
        [self.Vc.view addSubview:self.areaRadiusTableView];
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage newImageWithNamed:@"banjing_add" size:CGSizeMake(23, 23)] style:UIBarButtonItemStyleDone target:self action:@selector(banjingAdd)];
        addItem.tintColor = YBLTextColor;
        self.Vc.navigationItem.rightBarButtonItem = addItem;
        
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-2*space, buttonHeight)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.Vc.view addSubview:saveButton];
        WEAK
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            NSMutableArray *selectArray = [NSMutableArray array];
            for (YBLAreaRadiusItemModel *radiusModel in self.viewModel.areaSelectDataArray) {
                [selectArray addObject:radiusModel];
            }
            BLOCK_EXEC(self.viewModel.areaRadiusViewModelBlock,selectArray);
            [self.Vc.navigationController popViewControllerAnimated:YES];
        }];
    }
    return self;
}

- (YBLExpressPriceTableView *)areaRadiusTableView{
    
    if (!_areaRadiusTableView) {
        _areaRadiusTableView = [[YBLExpressPriceTableView alloc] initWithFrame:[self.Vc.view bounds]
                                                                         style:UITableViewStylePlain
                                                            distanceRadiusType:DistanceRadiusTypeEdit];
        _areaRadiusTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+buttonHeight+space*2)];
        _areaRadiusTableView.dataArray = self.viewModel.areaSelectDataArray;
        _areaRadiusTableView.isCanDelete = YES;
    }
    return _areaRadiusTableView;
}


- (void)banjingAdd {
 
    for (YBLAreaRadiusItemModel *itemModel in self.viewModel.areaDataArray) {
        itemModel.is_select = NO;
    }
    for (YBLAreaRadiusItemModel *itemModel1 in self.viewModel.areaSelectDataArray) {
        [self.viewModel.areaDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YBLAreaRadiusItemModel *objModel = (YBLAreaRadiusItemModel *)obj;
            if ([objModel.radius isEqualToString:itemModel1.radius]) {
                objModel.is_select = YES;
                *stop = YES;
            }
        }];
    }
    [YBLShowSelectAreaRadiusView showselectAreaRadiusViewFromVC:self.Vc.navigationController
                                             distanceRadiusType:DistanceRadiusTypeChoose
                                            areaRadiusDataArray:self.viewModel.areaDataArray
                                                     doneHandle:^{
                                                         [self.viewModel handleData];
                                                         [self.areaRadiusTableView jsReloadData];
                                                     }];
}

@end
