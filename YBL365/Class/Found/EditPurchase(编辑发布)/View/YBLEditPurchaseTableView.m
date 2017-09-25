//
//  YBLEditPurchaseTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseTableView.h"
#import "YBLEditPurchaseHeaderView.h"
#import "YBLEditPurchaseCell.h"
#import "YBLGoodModel.h"
#import "YBLFooterSignView.h"

@interface YBLEditPurchaseTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) YBLGoodModel *goodModel;

@property (nonatomic, assign) EditType editType;

@end

@implementation YBLEditPurchaseTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    return [self initWithFrame:frame
                         style:style
                      editType:EditTypePurchase];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     editType:(EditType)editType{
    
    if (self = [super initWithFrame:frame style:style]) {

        self.editType = editType;
        self.dataSource = self;
        self.delegate   = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLEditPurchaseCell getItemCellHeightWithModel:nil];
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+space*2+buttonHeight)];
        [self registerClass:NSClassFromString(@"YBLEditPurchaseCell") forCellReuseIdentifier:@"YBLEditPurchaseCell"];
        if (self.editType == EditTypePurchase) {
            self.sectionHeaderHeight = [YBLEditPurchaseHeaderView getEditPurchaseHeadeHeight];
            [self registerClass:NSClassFromString(@"YBLEditPurchaseHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLEditPurchaseHeaderView"];
        }
    }
    return self;
}

- (void)updateCellDataArray:(NSMutableArray *)cellArray goodModel:(YBLGoodModel *)goodModel{
    _cellDataArray = cellArray;
    _goodModel = goodModel;
    
    [self jsReloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0&&self.editType == EditTypePurchase) {
        
        YBLEditPurchaseHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLEditPurchaseHeaderView"];
        
        [headerView.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.goodModel.avatar] placeholderImage:smallImagePlaceholder];
        headerView.nameLabel.text = self.goodModel.title;
        
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
    
    NSInteger row = indexPath.row;
    
    YBLEditItemGoodParaModel *paraModel = self.cellDataArray[row];
    [cell updateItemCellModel:paraModel];
    
    BLOCK_EXEC(self.editPurchaseTableViewCellBlock,cell,paraModel,indexPath);

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self endEditing:YES];
}

@end
