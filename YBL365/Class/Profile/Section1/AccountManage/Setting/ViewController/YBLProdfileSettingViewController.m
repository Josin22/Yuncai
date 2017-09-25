//
//  YBLProdfileSettingViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProdfileSettingViewController.h"
#import "YBLAccountItemCell.h"
#import "YBLAccountManageItemModel.h"
#import "YBLLoginViewModel.h"
#import "YBLAboutMeViewController.h"
//#import <MessageUI/MessageUI.h>


@interface YBLProdfileSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation YBLProdfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self.view addSubview:self.infoTableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachSize = [NSString stringWithFormat:@"%@",[YBLMethodTools getCachImageSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            YBLAccountManageItemModel *model = self.dataArray[1];
            model.value = cachSize;
            [self.infoTableView jsReloadData];
        });
    });
    
//    NSMutableArray *numberArray = [NSMutableArray array];
//    for (int i = 0; i<100; i++) {
////        int number = [YBLMethodTools getRandomNumber:0 to:9];
//        int num = (arc4random() % 1000000);
//        NSString *fin_str = [NSString stringWithFormat:@"%.6d", num];
////        NSString *fin_str = [NSString stringWithFormat:@"%@",@(number)];
//        [numberArray addObject:fin_str];
//    }
//    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
//    composeVC.messageComposeDelegate = self;
//    
//    // Configure the fields of the interface.
//    composeVC.recipients = numberArray;
//    composeVC.body = @"Hello from California!";
//    
//    // Present the view controller modally.
//    [self presentViewController:composeVC animated:YES completion:nil];
    
//    [[UIApplication sharedApplication] openURL: @"sms:98765432"];
    
}


- (UITableView *)infoTableView{
    
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.showsVerticalScrollIndicator = NO;
        [_infoTableView registerClass:NSClassFromString(@"YBLAccountItemCell") forCellReuseIdentifier:@"YBLAccountItemCell"];
    }
    return _infoTableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *cachSize = @"0M";
        [_dataArray addObject:[self getTitle:@"定位设置" value:@"" cellType:CellItemTypeJustClick]];
        [_dataArray addObject:[self getTitle:@"清除缓存" value:cachSize cellType:CellItemTypeJustClick]];
        NSString *appVersion = [YBLMethodTools getAppVersion];
        [_dataArray addObject:[self getTitle:@"关于" value:appVersion cellType:CellItemTypeJustClick]];
    }
    return _dataArray;
}

- (YBLAccountManageItemModel *)getTitle:(NSString *)title value:(NSString *)value cellType:(CellItemType)cellType{
    
    YBLAccountManageItemModel *model = [YBLAccountManageItemModel new];
    model.title = title;
    model.value = value;
    model.cellItemType = cellType;
    return model;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 65)];
    footer.backgroundColor = [UIColor whiteColor];
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {

        UIButton *logoutButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, 2*space, footer.width-2*space, 40)];
        [logoutButton setTitle:@"注销登录" forState:UIControlStateNormal];
        WEAK
        [[logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [[YBLLoginViewModel singalForLogout] subscribeError:^(NSError *error) {
                
            } completed:^{
                [self.infoTableView jsReloadData];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        [footer addSubview:logoutButton];
    
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YBLAccountItemCell getHi];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLAccountItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAccountItemCell"
                                                                    forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLAccountItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    
    YBLAccountManageItemModel *model  = self.dataArray[row];

    YBLAccountItemCell *item_cell = (YBLAccountItemCell *)cell;
    [item_cell updateModel:model];
    WEAK
    [[[item_cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        switch (row) {
                
            case 0:
            {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [YBLMethodTools OpenURL:url];
            }
                break;
            case 1:
            {
                //缓存
                [YBLMethodTools cleanImageCach];
                model.value = @"0KB";
                [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
            case 2:
            {
                //关于
                YBLAboutMeViewController *aboutVC = [YBLAboutMeViewController new];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
}

@end
