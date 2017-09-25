//
//  YBLChooseAreaService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseAreaService.h"
#import "YBLChooseAreaViewController.h"
#import "YBLChooseAreaViewModel.h"
#import "YBLShengTableView.h"
#import "YBLAddressAreaModel.h"
#import "YBLSXTableView.h"

static NSInteger const table_tag = 444;

@interface YBLChooseAreaService ()

@property  (nonatomic, weak) YBLChooseAreaViewController *Vc;

@property  (nonatomic, strong) YBLShengTableView *shengTableView;

@property  (nonatomic, strong) YBLChooseAreaViewModel *viewModel;

@end

@implementation YBLChooseAreaService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLChooseAreaViewController *)VC;
        _viewModel = (YBLChooseAreaViewModel *)viewModel;
        
        self.Vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(saveAreaData)];
        
        [self checkDataIsExsitWithId:0 Index:0];
        
        if (self.viewModel.chooseAreaVCType == ChooseAreaVCTypeGetPart){
            self.shengTableView.userInteractionEnabled = NO;
            NSArray *dataArray = self.viewModel.sxAreaDataDict[@(0)];
            YBLAddressAreaModel *model = dataArray[0];
            [self checkDataIsExsitWithId:model.id.integerValue Index:1];
        }

    
    }
    return self;
}

///省级列表
- (YBLShengTableView *)shengTableView{
    if (!_shengTableView) {
        _shengTableView = [[YBLShengTableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth/self.viewModel.countByAreaType, YBLWindowHeight-kNavigationbarHeight)
                                                             style:UITableViewStylePlain];
        ///省级列表
        [self.Vc.view addSubview:_shengTableView];
        ///省级点击事件
        WEAK
        _shengTableView.shengTableViewCellDidSelectBlock = ^(BOOL arrowOrNot,BOOL buttonSelect,YBLAddressAreaModel *model){
            STRONG
            [self handleDataModel:model arrowOrNot:arrowOrNot buttonSelect:buttonSelect Index:1];
        };
    }
    return _shengTableView;
}

#pragma mark - method

- (void)saveAreaData{
    
    if (self.viewModel.selectAreaDataDict.allKeys.count==0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择地区哟~"];
        return;
    }
    if (self.viewModel.chooseAreaVCType == ChooseAreaVCTypeGetAll||self.viewModel.chooseAreaVCType == ChooseAreaVCTypeGetPart) {
        
        BLOCK_EXEC(self.viewModel.chooseAreaSaveBlock,self.viewModel.selectAreaDataDict);
        [self.Vc.navigationController popViewControllerAnimated:YES];
        
        return;
    }

    [[self.viewModel signalForSaveAreaSetting] subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败~"];
        }
    } error:^(NSError *error) {
        
    }];
    
}

///数据update
- (void)checkDataIsExsitWithId:(NSInteger)Id Index:(NSInteger)index{

    NSArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
    if (!dataArray) {
        ///请求数据
        [[self.viewModel areaListSignalWithId:Id Index:index] subscribeError:^(NSError *error) {
            
        } completed:^{
            NSArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
            if (index == 0) {
                [self.shengTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
            } else {
                NSArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
                YBLSXTableView *sxTableView = (YBLSXTableView *)[self.Vc.view viewWithTag:table_tag+index];
                if (!sxTableView) {
                    YBLSXTableView *sxTableView = [self getSXTableViewWithIndex:index];
                    [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
                    [self.Vc.view addSubview:sxTableView];
                } else {
                    [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
                }
            }
        }];
    } else {
        ///取已储存数据
        if (index == 0) {
            [self.shengTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
        } else {
            YBLSXTableView *sxTableView = (YBLSXTableView *)[self.Vc.view viewWithTag:table_tag+index];
            [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
        }
    }

}

///获取tableview
- (YBLSXTableView *)getSXTableViewWithIndex:(NSInteger)index{
    
    TableType type = tableTypeSXArrow;
    if (index == self.viewModel.countByAreaType-1) {
        type = tableTypeSXNoneArrow;
    }
    YBLSXTableView *tableView = [[YBLSXTableView alloc] initWithFrame:CGRectMake(index*self.shengTableView.width, 0, self.shengTableView.width, self.shengTableView.height)
                                                                style:UITableViewStylePlain
                                                            tableType:type];
    tableView.tag = table_tag+index;
    WEAK
    tableView.sxTableViewCellDidSelectBlock = ^(BOOL arrowOrNot, BOOL buttonSelect,YBLAddressAreaModel *model){
        STRONG
        [self handleDataModel:model arrowOrNot:arrowOrNot buttonSelect:buttonSelect Index:index+1];
    };
    return tableView;
}

///处理数据
- (void)handleDataModel:(YBLAddressAreaModel *)model
             arrowOrNot:(BOOL)arrowOrNot
           buttonSelect:(BOOL)buttonSelect
                  Index:(NSInteger)index{
    
    if (arrowOrNot) {
        for (NSInteger i = index; i<self.viewModel.countByAreaType; i++) {
            YBLSXTableView *sxTableView = (YBLSXTableView *)[self.Vc.view viewWithTag:table_tag+i];
            [sxTableView updateArray:nil Dict:self.viewModel.selectAreaDataDict];
        }
        if (buttonSelect) {
            [self checkDataIsExsitWithId:model.id.integerValue Index:index];
        }
    } else {
        for (NSInteger i = index; i<self.viewModel.countByAreaType; i++) {
            YBLSXTableView *sxTableView = (YBLSXTableView *)[self.Vc.view viewWithTag:table_tag+i];
            [sxTableView updateArray:nil Dict:self.viewModel.selectAreaDataDict];
        }
        if (buttonSelect) {
            //储存
            [self.viewModel saveModel:model];
        } else {
            //删除
            [self.viewModel deleteModel:model];
        }
    }

}

@end
