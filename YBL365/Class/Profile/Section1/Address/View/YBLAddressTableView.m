//
//  YBLAddressTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddressTableView.h"
#import "YBLOrderAddressCell.h"
#import "YBLEditAddressViewController.h"
#import "YBLZitiAddressCell.h"
#import "YBLSelectZitiAddressCell.h"
#import "YBLFooterSignView.h"

@interface YBLAddressTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    BOOL isCanDelete;
    NSInteger index_default;
}
@property (nonatomic, assign) AddressGenre addressGenre;

@end

@implementation YBLAddressTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                 addressGenre:(AddressGenre)addressGenre{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _addressGenre = addressGenre;
        isCanDelete = YES;
        if (_addressGenre == AddressGenreZiti) {
            [self registerClass:[YBLZitiAddressCell class] forCellReuseIdentifier:@"YBLZitiAddressCell"];
        } else if (_addressGenre == AddressGenreShipping) {
            [self registerClass:[YBLOrderAddressCell class] forCellReuseIdentifier:@"YBLOrderAddressCell"];
        } else if (_addressGenre == AddressGenreSelectZiti){
            [self registerClass:[YBLSelectZitiAddressCell class] forCellReuseIdentifier:@"YBLSelectZitiAddressCell"];
        } else if (_addressGenre == AddressGenreTakeOrderSelectZiti||_addressGenre == AddressGenreGoodDetailShipping){
            isCanDelete = NO;
            [self registerClass:[YBLSelectZitiAddressCell class] forCellReuseIdentifier:@"YBLSelectZitiAddressCell"];
        }
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, self.width, kNavigationbarHeight+buttonHeight+space)];
        self.delegate = self;
        self.dataSource = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        index_default = 0;
    }
    return self;
}


- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;

    NSInteger index = 0;
    for (YBLAddressModel *addressModel in _dataArray) {
        if (_addressGenre == AddressGenreZiti) {
            //YBLZitiAddressCell
            [addressModel calulateTextSize:addressModel.full_address textFont:YBLFont(14) textMaxWidth:YBLWindowWidth-2*space-30-5];
        } else if (_addressGenre == AddressGenreShipping) {
            //YBLOrderAddressCell
            [addressModel calulateTextSize:addressModel.full_address textFont:YBLFont(16) textMaxWidth:YBLWindowWidth-2*space];
        } else {
            //YBLSelectZitiAddressCell
            CGFloat imageHi = 40;
            if (!addressModel.is_select) {
                imageHi = 0;
            }
            [addressModel calulateTextSize:addressModel.full_address textFont:YBLFont(15) textMaxWidth:YBLWindowWidth-2*space-17-imageHi];
        }
        if (addressModel.is_select) {
            index_default = index;
        }
        index++;
    }
    
    [self jsReloadData];
}


#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLAddressModel *model = _dataArray[indexPath.section];
    if (_addressGenre == AddressGenreZiti) {
        
        return  [YBLZitiAddressCell getItemCellHeightWithModel:model];
        
    } else if (_addressGenre == AddressGenreShipping) {
        
        return  [YBLOrderAddressCell getItemCellHeightWithModel:model];
        
    } else {
        
        return  [YBLSelectZitiAddressCell getItemCellHeightWithModel:model];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    YBLAddressModel *model = _dataArray[section];
    
    if (_addressGenre == AddressGenreZiti) {
        
        YBLZitiAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLZitiAddressCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateItemCellModel:model];
        
        WEAK
        [[[cell.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.addressTableViewCellButtonClickBlock,model);
        }];
        
        [[[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.addressTableViewCellDeleteClickBlock,model,section);
        }];
        
        return cell;
        
    } else if (_addressGenre == AddressGenreShipping) {
        
        YBLOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderAddressCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell updateItemCellModel:model];
        WEAK
        //编辑
        [[[cell.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.addressTableViewCellButtonClickBlock,model);
        }];
        //删除
        [[[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.addressTableViewCellDeleteClickBlock,model,section);
        }];
        //默认
        [[[cell.defaultButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            if (model._default.boolValue) {
                return ;
            }
           BLOCK_EXEC(self.addressTableViewRowDefaultBlock,model,section)
        }];
        
        return cell;
    } else if (_addressGenre == AddressGenreSelectZiti || _addressGenre == AddressGenreTakeOrderSelectZiti||_addressGenre == AddressGenreGoodDetailShipping){
        
        YBLSelectZitiAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSelectZitiAddressCell" forIndexPath:indexPath];
        if (index_default == section) {
            cell.duihaoImageView.hidden = NO;
        } else {
            cell.duihaoImageView.hidden = YES;
        }
        
        [cell updateItemCellModel:model];
        
        if (_addressGenre == AddressGenreTakeOrderSelectZiti||_addressGenre == AddressGenreGoodDetailShipping) {
            WEAK
            [[[cell.fullAddressButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                STRONG
                BLOCK_EXEC(self.addressTableViewRowDidSelectBlock,model,section)
            }];
        }
        return cell;
        
    } else {
        
        return 0;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return isCanDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger section = indexPath.section;
        YBLAddressModel *model = _dataArray[section];
        BLOCK_EXEC(self.addressTableViewCellDeleteClickBlock,model,section);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    index_default  = section;
    YBLAddressModel *model = _dataArray[section];
    if (_addressGenre == AddressGenreSelectZiti || _addressGenre == AddressGenreTakeOrderSelectZiti||_addressGenre == AddressGenreGoodDetailShipping){
        for (YBLAddressModel *model in _dataArray) {
            model.is_select = NO;
        }
        model.is_select = YES;
    }
    BLOCK_EXEC(self.addressTableViewRowDidSelectBlock,model,section)

}


#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_address";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没添加地址呢~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}



@end
