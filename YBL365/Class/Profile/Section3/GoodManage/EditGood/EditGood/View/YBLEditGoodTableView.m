//
//  YBLEditGoodTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodTableView.h"
#import "YBLOptionTypesModel.h"
#import "ZJUsefulPickerView.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLEditPurchaseSingleView.h"
#import "YBLWriteTextView.h"
#import "YBLEditPurchaseHeaderView.h"
#import "YBLEditGoodViewModel.h"
#import "YBLGoodModel.h"
#import "YBLEditGoodViewController.h"
#import "YBLFooterSignView.h"

@interface YBLEditGoodTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBLEditGoodTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate   = self;
        self.sectionHeaderHeight = [YBLEditPurchaseHeaderView getEditPurchaseHeadeHeight];
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+40)];
        [self registerClass:NSClassFromString(@"YBLEditPurchaseHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLEditPurchaseHeaderView"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cellDataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        YBLEditPurchaseHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLEditPurchaseHeaderView"];
        
        [headerView.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.viewModel.productModel.avatar_url] placeholderImage:smallImagePlaceholder];
        headerView.nameLabel.text = self.viewModel.productModel.title;
        
        return headerView;
        
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLEditPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLEditPurchaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    
    YBLEditItemGoodParaModel *paraModel = self.viewModel.cellDataArray[row];
    
    [cell updateItemCellModel:paraModel];
    
    WEAK
    [[cell.valueTextFeild.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        NSLog(@"paraModel:%@",x);
        [paraModel setValue:x forKey:@"value"];
    }];
    [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        if ([paraModel.paraString isEqualToString:@"title"]) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithObject:paraModel.value];
            //商品名称
            [YBLEditPurchaseSingleView showEditPurchaseSingleViewInVC:self.Vc.navigationController
                                                                 Data:dataArray
                                                                 Type:ditPurchaseSingleViewTypeGoodsName
                                                               Handle:^(NSString *selectValue) {
                                                                   STRONG
                                                                   [paraModel setValue:selectValue forKey:@"value"];
                                                                   [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                               }];

        } else if ([paraModel.paraString isEqualToString:@"specification"]||[paraModel.paraString isEqualToString:@"description"]) {
            //
            [YBLWriteTextView showWriteTextViewOnView:self.Vc.navigationController
                                          currentText:paraModel.value
                                     LimmitTextLength:60
                                         completetion:^(NSString *text) {
                                             STRONG
                                             [paraModel setValue:text forKey:@"value"];
                                             [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                         }];
        } else if ([paraModel.paraString isEqualToString:@"unit"]) {
            //specifacation
            [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"单位"
                                                          withData:@[@"箱",@"桶",@"袋",@"盒",@"瓶",@"坛",@"包",@"件",@"台",@"筐",@"罐",@"饼",@"听",@"支",@"个",@"双",@"部",@"架",@"本",@"条",@"捆",@"卷",@"批",@"块",@"套",@"头",@"只",@"碗",@"片",@"斤",@"公斤",@"克",@"千克",@"提"]
                                                  withDefaultIndex:0
                                                 withCancelHandler:^{
                                                     
                                                 }
                                                   withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                       STRONG
                                                       [paraModel setValue:selectedValue forKey:@"value"];
                                                       [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                   }];
        }
      
    }];
    [[[cell.arrowButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        if (paraModel.id) {
            [[self.viewModel SignalForOptionTypeWithId:paraModel.id] subscribeNext:^(YBLOptionTypesModel *x) {
                
                [ZJUsefulPickerView showSingleColPickerWithToolBarText:x.name
                                                              withData:x.values
                                                      withDefaultIndex:0
                                                     withCancelHandler:^{
                                                         
                                                     }
                                                       withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                           STRONG
                                                           [paraModel setValue:selectedValue forKey:@"value"];
                                                           [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                       }];
                
            } error:^(NSError *error) {
                
            }];
        }
    }];
    
}


@end
