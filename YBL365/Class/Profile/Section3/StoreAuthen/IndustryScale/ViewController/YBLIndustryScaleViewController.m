//
//  YBLIndustryScaleViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLIndustryScaleViewController.h"
#import "YBLIdentityAuthenticationViewController.h"
#import "YBLUserInfosParaModel.h"
#import "YBLCompanyTypesItemModel.h"
#import "YBLStoreAuthenViewModel.h"

static NSInteger tag_left_tableView = 44;

#pragma mark left cell

@interface leftTitleCell : UITableViewCell

@property (nonatomic, strong) UIButton *titleButton;

@end

@implementation leftTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0, 0, YBLWindowWidth, 50);
//    [self.titleButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    [self.titleButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = YBLFont(15);
    [self.titleButton setTitle:@"正在加载" forState:UIControlStateNormal];
    [self.titleButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.titleButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    [self.contentView addSubview:self.titleButton];
    
    [self.titleButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.titleButton.height-0.5, self.titleButton.width, 0.5)]];
}

@end


@interface YBLIndustryScaleViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UIView *leftBGView;


@end

@implementation YBLIndustryScaleViewController

- (void)goback1{
    
    self.userInfosParModel = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - requset

- (void)requsetCompanyTypes:(NSString *)types{
    WEAK
    [[YBLStoreAuthenViewModel signalForCompanyTypesWith:types] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.dataArray = x;
        NSString *company_id = [YBLUserManageCenter shareInstance].userInfoModel.company_type_id;
        for (YBLCompanyTypesItemModel *itemModel in self.dataArray) {
            if ([itemModel._id isEqualToString:company_id]) {
                itemModel.isSelect = YES;
            }
        }
        [self.leftTableView jsReloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择类型";
    
    /* 选择大小比 */
    [self.view addSubview:self.leftTableView];
    
    [self requsetCompanyTypes:self.currentType];
}

- (UITableView *)leftTableView{
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.tag = tag_left_tableView;
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.rowHeight = 50;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        [_leftTableView registerClass:NSClassFromString(@"leftTitleCell") forCellReuseIdentifier:@"leftTitleCell"];
    }
    return _leftTableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    leftTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTitleCell" forIndexPath:indexPath];
    
    [self configureleftTitleCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
  
}

- (void)configureleftTitleCell:(leftTitleCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    YBLCompanyTypesItemModel *model = self.dataArray[row];
    
    cell.titleButton.selected = model.isSelect;
    [cell.titleButton setTitle:model.title forState:UIControlStateNormal];
    WEAK
    [[[cell.titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        NSInteger index = 0;
        for (YBLCompanyTypesItemModel *model in self.dataArray) {
            model.isSelect = NO;
            if (index==row) {
                model.isSelect = YES;
            }
            index++;
        }
        [self.leftTableView jsReloadData];
//        YBLCompanyTypesItemModel *model = self.leftModel.companytypes[row];
        YBLUserInfosParaModel *paraModel = [YBLUserInfosParaModel new];
        paraModel.companytype = model._id;
        paraModel.usertype = self.currentType;
        YBLIdentityAuthenticationViewController *vc = [YBLIdentityAuthenticationViewController new];
        vc.userInfosParModel = paraModel;
        [self.navigationController pushViewController:vc animated:YES];
        /*
        YBLCompanyTypesItemModel *model = self.leftModel.companytypes[row];
        [self requsetCompanyTypes:nil idvalue:model._id IsLeftQuest:NO];
        */
    }];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    YBLCompanyTypesItemModel *model = self.dataArray[row];
    YBLUserInfosParaModel *paraModel = [YBLUserInfosParaModel new];
    paraModel.companytype = model._id;
    YBLIdentityAuthenticationViewController *vc = [YBLIdentityAuthenticationViewController new];
    vc.userInfosParModel = paraModel;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
