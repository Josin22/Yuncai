//
//  YBLMyBrowsingHistoryService.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyBrowsingHistoryService.h"
#import "YBLMyBrowsingHistoryViewModel.h"
#import "YBLMyBrowsingHistoryViewController.h"
#import "YBLMyBrowsingHistoryTableViewCell.h"
@interface YBLMyBrowsingHistoryService()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YBLMyBrowsingHistoryViewModel *viewModel;
@property (nonatomic,weak  )YBLMyBrowsingHistoryViewController *vc;
@property (nonatomic,strong)UITableView *myBrowsingHistoryTableView;
@property (nonatomic,strong)NSArray *dateArr;
@property (nonatomic,assign)BOOL editing;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,assign)BOOL allSelected;
@property (nonatomic,strong)NSMutableArray *selectArr;

@end
@implementation YBLMyBrowsingHistoryService
- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        _vc = (YBLMyBrowsingHistoryViewController*)VC;
        _viewModel = (YBLMyBrowsingHistoryViewModel*)viewModel;
        [self setNavRightButton];
        self.dateArr = @[@"今天",@"1月9日",@"1月8日",@"1月10日"];
        self.editing = NO;
        self.allSelected = NO;
        [self.vc.view addSubview:self.myBrowsingHistoryTableView];
    }
    return self;
}
- (NSMutableArray*)selectArr{
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}
//nagagationbar 右侧按钮
- (void)setNavRightButton{
    if (self.editing == NO) {
        //两个按钮的父类view
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        //清空按钮
        UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        [rightButtonView addSubview:historyBtn];
        [historyBtn setTitle:@"清空" forState:UIControlStateNormal];
        historyBtn.titleLabel.font = YBLFont(15);
        [historyBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [historyBtn addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(50,4, 1, 17)];
        line.backgroundColor = YBLLineColor;
        [rightButtonView addSubview:line];
        //编辑按钮
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(51, 0, 50, 25)];
        [rightButtonView addSubview:editBtn];
        [editBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editBtn.titleLabel.font = YBLFont(15);
        [editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //把右侧的两个按钮添加到rightBarButtonItem
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.vc.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }
    else
    {
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishBtn setFrame:CGRectMake(0, 0, 50,25)];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
        finishBtn.titleLabel.font = YBLFont(15);
        [finishBtn addTarget:self action:@selector(finishedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [rightButtonView addSubview:finishBtn];
        UIBarButtonItem *rightCustomButonView = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
        self.vc.navigationItem.rightBarButtonItem = rightCustomButonView;
    }
    
}
#pragma mark--结束编辑（完成按钮点击效果）
- (void)finishedButtonClicked{
    self.editing = NO;
    if (self.allSelected == YES) {
        self.allSelected = NO;
        UIImageView *imageView = (UIImageView*)[self.bottomView viewWithTag:1002];
        [imageView setImage:[UIImage imageNamed:@"syncart_round_check1New"]];
    }
    [self.bottomView removeFromSuperview];
    [self setNavRightButton];
    NSLog(@"结束编辑");
    for (YBLMyBrowsingHistoryTableViewCell *cell in self.myBrowsingHistoryTableView.visibleCells) {
        cell.isEditting = self.editing;
//        cell.selected = NO;
//        cell.isSelected = NO;
    }
    [self.myBrowsingHistoryTableView reloadData];

    

}
- (UITableView*)myBrowsingHistoryTableView{
    if (_myBrowsingHistoryTableView == nil)
    {
        _myBrowsingHistoryTableView.backgroundColor = [UIColor whiteColor];
        _myBrowsingHistoryTableView = [[UITableView alloc]initWithFrame:self.vc.view.bounds style:UITableViewStyleGrouped];
        _myBrowsingHistoryTableView.dataSource = self;
        _myBrowsingHistoryTableView.delegate = self;
        _myBrowsingHistoryTableView.rowHeight = [YBLMyBrowsingHistoryTableViewCell getMyBrowsingHistoryCellHeight];
        _myBrowsingHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myBrowsingHistoryTableView registerClass:[YBLMyBrowsingHistoryTableViewCell class] forCellReuseIdentifier:@"MyBrowsingHistoryTableViewCell"];
    }
    return _myBrowsingHistoryTableView;
}
//清空点击事件
- (void)historyBtnEvent{

}
//编辑点击事件
- (void)editBtnClicked{
    [self.vc.view addSubview:self.bottomView];
    self.editing = YES;
    [self setNavRightButton];
    for (YBLMyBrowsingHistoryTableViewCell *cell in self.myBrowsingHistoryTableView.visibleCells) {
        cell.isEditting = self.editing;
        cell.selected = NO;
        cell.isSelected = NO;
    }
    [self.myBrowsingHistoryTableView reloadData];
}
- (UIView*)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,YBLWindowHeight - 40 ,YBLWindowWidth, 40)];
         _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,0,YBLWindowWidth,0.5)];
        line.backgroundColor = YBLLineColor;
        [_bottomView addSubview:line];
        
        UIImageView *selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space,space , 20, 20)];
        selectedImageView.image = [UIImage imageNamed:@"syncart_round_check1New"];
        selectedImageView.tag = 1002;
        [_bottomView addSubview:selectedImageView];
        
        UILabel *allSelectedlabel = [[UILabel alloc]initWithFrame:CGRectMake(selectedImageView.right + space ,_bottomView.height/2- 12/2,30, 12)];
        allSelectedlabel.text = @"全选";
        allSelectedlabel.textColor = BlackTextColor;
        allSelectedlabel.textAlignment = NSTextAlignmentLeft;
        allSelectedlabel.font = YBLFont(12);
        [_bottomView addSubview:allSelectedlabel];
        
        UIButton *allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allSelectedBtn setFrame:CGRectMake(0, 0, 110, _bottomView.height)];
        [allSelectedBtn addTarget:self action:@selector(allSelectedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:allSelectedBtn];
        
        UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deletBtn setFrame:CGRectMake(YBLWindowWidth/5*3,0,YBLWindowWidth*2/5,_bottomView.height)];
        [deletBtn setBackgroundColor:YBLColor(224, 42, 59, 1) forState:UIControlStateNormal];
        [deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deletBtn.titleLabel.font = YBLFont(15);
        [deletBtn addTarget:self action:@selector(deletBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:deletBtn];
        
    }
    return _bottomView;
}
#pragma mark--全选按钮点击事件
- (void)allSelectedBtnClicked{
    if (self.allSelected == NO)
    {
        UIImageView *imageView = (UIImageView*)[self.bottomView viewWithTag:1002];
        [imageView setImage:[UIImage imageNamed:@"syncart_round_check2New"]];
        //添加数据 在reload

    }
    else
    {
        UIImageView *imageView = (UIImageView*)[self.bottomView viewWithTag:1002];
        [imageView setImage:[UIImage imageNamed:@"syncart_round_check1New"]];
        // 删除数据 在reload
    }

    self.allSelected =!self.allSelected;
}
#pragma mark--删除按钮点击事件
- (void)deletBtnClicked{


}
#pragma mark--UITableViewDataSource&&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dateArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 5;
    }
    else
    {
    return 6;
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,YBLWindowWidth,40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    UIView *line = [[UIView alloc]init];
    if (self.editing == YES) {
        [label setFrame:CGRectMake(space+37,40/2-16/2,100,16)];
        [line setFrame:CGRectMake(space+37,40-0.5,YBLWindowWidth,0.5)];
    }else{
        [label setFrame:CGRectMake(space,40/2-16/2,100,16)];
        [line setFrame:CGRectMake(space,40-0.5,YBLWindowWidth,0.5)];
    }
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = YBLTextColor;
    label.font = YBLFont(15);
    label.text = [self.dateArr objectAtIndex:section];
    [headerView addSubview:label];
    
    line.backgroundColor = YBLLineColor;
    [headerView addSubview:line];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLMyBrowsingHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBrowsingHistoryTableViewCell" forIndexPath:indexPath];
    cell.isEditting = self.editing;
    
    if ([self.selectArr containsObject:indexPath]) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLMyBrowsingHistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.editing) {  //若为编辑模式
        
        if (![self.selectArr containsObject:indexPath]) {
            cell.isSelected = YES;
            [self.selectArr addObject:indexPath];
        }else{
            cell.isSelected = NO;
            [self.selectArr removeObject:indexPath];
        }
    }else{
        
        NSLog(@"您点击了第%ld个cell",indexPath.row + 1);
    }

}
@end
