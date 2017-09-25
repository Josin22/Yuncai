//
//  YBLSeckillTableView.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillTableView.h"
#import "YBLSeckillCell.h"
#import "YBLSeckillHeaderView.h"
#import "YBLSeckillViewController.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLSeckillTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) SeckillTableViewType type;

@end

@implementation YBLSeckillTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style Type:(SeckillTableViewType)type{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _type = type;
        
        self.dataSource = self;
        self.delegate   = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLSeckillCell getSeckillCellHeight];
        self.sectionFooterHeight = 65;
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[YBLSeckillCell class] forCellReuseIdentifier:@"YBLSeckillCell"];
        if (_type == SeckillTableViewTypeDefault) {
            [self registerClass:[YBLSeckillHeaderView class] forHeaderFooterViewReuseIdentifier:@"YBLSeckillHeaderView"];
        }
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
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return _type == SeckillTableViewTypeDefault?30:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLSeckillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSeckillCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_type == SeckillTableViewTypeDefault) {
    
        YBLSeckillHeaderView *panicView = [YBLSeckillHeaderView headerViewWithTableView:tableView];
    
        return panicView;
    } else {
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (void)configureCell:(YBLSeckillCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    WEAK
    cell.seckillCellGoSeckillBlock = ^(){
        STRONG
        [self pushInGoodsDetail];
    };
    
    [cell updateSeckillData:self.test];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pushInGoodsDetail];
}

- (void)pushInGoodsDetail{

    YBLGoodsDetailViewController *goodsDetaillVC = [[YBLGoodsDetailViewController alloc] initWithType:self.test==1?GoodsDetailTypeSeckilling:GoodsDetailTypeSeckillNotTime];
    [self.seckillVC.navigationController pushViewController:goodsDetaillVC animated:YES];
   
}


@end
