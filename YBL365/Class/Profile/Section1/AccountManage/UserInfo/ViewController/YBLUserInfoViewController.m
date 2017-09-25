//
//  YBLUserInfoViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLUserInfoViewController.h"
#import "YBLAccountManageItemModel.h"
#import "YBLUserIconCell.h"
#import "YBLAccountItemCell.h"
#import "YBLLoginViewModel.h"
#import "ZJUsefulPickerView.h"
#import "YBLWriteInfoViewController.h"
#import "ZZYPhotoHelper.h"
#import "YBLSingletonMethodTools.h"
#import "YBLPhotoHeplerViewController.h"
#import "HVWOpenAlbumTool.h"

@interface YBLUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HVWOpenAlbumTool *tool;

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YBLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人信息";
    
    [self.view addSubview:self.infoTableView];
}

- (UITableView *)infoTableView{
    
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.showsVerticalScrollIndicator = NO;
        [_infoTableView registerClass:NSClassFromString(@"YBLUserIconCell") forCellReuseIdentifier:@"YBLUserIconCell"];
        [_infoTableView registerClass:NSClassFromString(@"YBLAccountItemCell") forCellReuseIdentifier:@"YBLAccountItemCell"];
    }
    return _infoTableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        YBLAccountManageItemModel *model = [YBLAccountManageItemModel new];
        NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
        if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
            model.icon_url = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
        } else {
            model.icon_url = @"login_head_icon_70x70_";
        }
        model.title = @"头像";
        model.cellItemType = CellItemTypeClickWrite;
        [_dataArray addObject:model];
        [_dataArray addObject:[self getTitle:@"用户名"
                                       value:[YBLUserManageCenter shareInstance].userInfoModel.mobile
                                    cellType:CellItemTypeNoCanWriteClick
                                   paraValue:@"e_mail"]];
        
        [_dataArray addObject:[self getTitle:@"昵称"
                                       value:[YBLUserManageCenter shareInstance].userInfoModel.nickname
                                    cellType:CellItemTypeJustClick
                                   paraValue:@"nickname"]];
        
        [_dataArray addObject:[self getTitle:@"性别"
                                       value:[YBLUserManageCenter shareInstance].userInfoModel.sex
                                    cellType:CellItemTypeJustClick
                                   paraValue:@"sex"]];
        
        [_dataArray addObject:[self getTitle:@"出生日期"
                                       value:[YBLUserManageCenter shareInstance].userInfoModel.birthday
                                    cellType:CellItemTypeJustClick
                                   paraValue:@"birthday"]];
        
        [_dataArray addObject:[self getTitle:@"邮箱"
                                       value:[YBLUserManageCenter shareInstance].userInfoModel.e_mail
                                    cellType:CellItemTypeJustClick
                                   paraValue:@"e_mail"]];;
    }
    return _dataArray;
}

- (YBLAccountManageItemModel *)getTitle:(NSString *)title value:(NSString *)value cellType:(CellItemType)cellType paraValue:(NSString *)paraValue{
    
    YBLAccountManageItemModel *model = [YBLAccountManageItemModel new];
    model.title = title;
    model.value = value;
    model.cellItemType = cellType;
    model.paraValue = paraValue;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return [YBLUserIconCell getHi];
    } else {
        return [YBLAccountItemCell getHi];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLUserIconCell"
                                               forIndexPath:indexPath];
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAccountItemCell"
                                               forIndexPath:indexPath];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    
    YBLAccountManageItemModel *model  = self.dataArray[row];
    
    if ([cell isKindOfClass:[YBLUserIconCell class]]) {
        
        YBLUserIconCell *user_cell = (YBLUserIconCell *)cell;
        [user_cell updateModel:model];
        WEAK
        [[[user_cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
                if (image) {
                    [[YBLLoginViewModel siganlForUpdateUserIconWithImage:image] subscribeError:^(NSError * _Nullable error) {
                        
                    } completed:^{
                        STRONG
                        //                        self.dataArray = nil;
                        model.icon_url = image;
                        [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }
                
            }
                                                                                    isEdit:YES
                                                                               isJustPhoto:NO];

            
//            HVWOpenAlbumTool *tool = [[HVWOpenAlbumTool alloc] init];
//            [tool openAlbumWithVC:self completion:^(UIImage *image) {
//                if (image) {
//                    [[YBLLoginViewModel siganlForUpdateUserIconWithImage:image] subscribeError:^(NSError * _Nullable error) {
//                        
//                    } completed:^{
//                        STRONG
//                        model.icon_url = image;
//                        [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    }];
//                }
//            }];
//            self.tool = tool;
            /*
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            UIImage *image = (UIImage *)data;
            if (image) {
                [[YBLLoginViewModel siganlForUpdateUserIconWithImage:image] subscribeError:^(NSError * _Nullable error) {
                    
                } completed:^{
                    STRONG
                    model.icon_url = image;
                    [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            }
        }];
          
        [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
            if (image) {
                [[YBLLoginViewModel siganlForUpdateUserIconWithImage:image] subscribeError:^(NSError * _Nullable error) {
                    
                } completed:^{
                    STRONG
                    //                        self.dataArray = nil;
                    model.icon_url = image;
                    [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            }

        }
                                                                                isEdit:YES
                                                                           isJustPhoto:NO];
             */
            /*
            [YBLTakePhotoSheetPhotoView showUserIconImagePickerWithVC:self PikerDoneHandle:^(UIImage *image) {
                STRONG
                if (image) {
                    [[YBLLoginViewModel siganlForUpdateUserIconWithImage:image] subscribeError:^(NSError * _Nullable error) {
                        
                    } completed:^{
                        STRONG
//                        self.dataArray = nil;
                        model.icon_url = image;
                        [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }
            }];
             */
        }];
        
    } else if ([cell isKindOfClass:[YBLAccountItemCell class]]) {
        
        YBLAccountItemCell *item_cell = (YBLAccountItemCell *)cell;
        [item_cell updateModel:model];
        WEAK
        [[[item_cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            if (row == 3) {
                //性别
                [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"选择性别"
                                                              withData:[@[@"男性",@"女性",@"保密"] mutableCopy]
                                                      withDefaultIndex:0
                                                     withCancelHandler:^{
                                                         
                                                     }
                                                       withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                           STRONG
                                                           NSString *value = nil;
                                                           if ([selectedValue isEqualToString:@"男性"]) {
                                                               value = @"man";
                                                           } else if ([selectedValue isEqualToString:@"女性"]) {
                                                               value = @"woman";
                                                           } else if ([selectedValue isEqualToString:@"保密"]) {
                                                               value = @"secret";
                                                           }
                                                           
                                                           [[YBLLoginViewModel siganlForUpdateUserInfoWithKey:@"sex" value:value] subscribeError:^(NSError * _Nullable error) {
                                                               
                                                           } completed:^{
                                                               STRONG
//                                                               self.dataArray = nil;
                                                               model.value = selectedValue;
                                                               [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];;
                                                           }];
                                                       }];
            } else if (row == 4) {
              
                ZJDatePickerStyle *style = [ZJDatePickerStyle new];
                style.datePickerMode = UIDatePickerModeDate;
                [ZJUsefulPickerView showDatePickerWithToolBarText:@"选择生日"
                                                        withStyle:style
                                                withCancelHandler:^{}
                                                  withDoneHandler:^(NSDate *selectedDate) {
                                                      
                                                      NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
                                                      [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                      NSString *strDate = [dateFormatter stringFromDate:selectedDate];
                                                      
                                                      [[YBLLoginViewModel siganlForUpdateUserInfoWithKey:@"birthday" value:strDate] subscribeError:^(NSError * _Nullable error) {
                                                          
                                                      } completed:^{
                                                          STRONG
//                                                          self.dataArray = nil;
                                                          model.value = strDate;
                                                          [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];;
                                                      }];
                                                  }];
                
            } else {
      
                YBLWriteInfoViewController *writeVC = [YBLWriteInfoViewController new];
                writeVC.infoString = model.paraValue;
                writeVC.titleString = model.title;
                writeVC.textValue = model.value;
                writeVC.writeInfoValueBlock = ^(NSString *value) {
                    STRONG
//                    self.dataArray = nil;
                    model.value = value;
                    [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];;
                };
                [self.navigationController pushViewController:writeVC animated:YES];
                
            }
      
        }];
    }
}


@end
