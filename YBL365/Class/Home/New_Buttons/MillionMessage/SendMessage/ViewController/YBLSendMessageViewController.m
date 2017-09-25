//
//  YBLSendMessageViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSendMessageViewController.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLEditPurchaseCell.h"
#import "YBLlimmitTextView.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLMineMillionMessageViewController.h"
#import "YBLSendMessageTools.h"
#import "YBLMineMillionMessageItemModel.h"
#import "YBLCustomersLabel.h"

static NSInteger tag_image = 81932;

@interface YBLSendMessageViewController ()
{
    UIView *_selectCustomerView;
    UIView *_writeCustomerView;
    UIButton *_addButton;
    YBLlimmitTextView*_contentTextView;
    NSString *_contentString;
    UILabel *infoLabel1;
    NSInteger button_count;
    CGFloat add_button_wi;
}

@property (nonatomic, strong) UIButton            *sendButton;
@property (nonatomic, strong) YBLSendMessageTools *tools;
@property (nonatomic, strong) NSMutableArray      *selectGoodArray;

@end

@implementation YBLSendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"短信通知";
    
    YBLSendMessageTools *tools = [YBLSendMessageTools new];
    self.tools = tools;
    
    [self  createUI];
    
}

- (void)createLogs{

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *ids = [YBLMethodTools getAppendingStringWithArray:self.customers appendingKey:@","];
    para[@"ids"] = ids;
    para[@"content"] = _contentString;
    
    [YBLRequstTools HTTPPostWithUrl:url_customers_logs
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD dismiss];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                
                            }];
    
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, YBLWindowWidth, kBottomBarHeight)];
        _sendButton.bottom = YBLWindowHeight-kNavigationbarHeight;
        [_sendButton setTitle:@"确定发送" forState:UIControlStateNormal];
        WEAK
        [[_sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
//            [self createLogs];
//            return 
            if (self.customers.count==0) {
                [SVProgressHUD showErrorWithStatus:@"您还没有选择客户哟~"];
                return ;
            }
            _contentString = _contentTextView.text;
            NSMutableArray *allPhone = @[].mutableCopy;
            for (YBLMineMillionMessageItemModel *itemModel in self.customers) {
                [allPhone addObject:itemModel.mobile];
            }
            [self.tools sendContacts:allPhone
                             message:_contentString
                          completion:^(YBLMessageComposeResult result) {
                              
                              switch (result) {
                                  case YBLMessageComposeResultSent:
                                  {
                                      [SVProgressHUD showSuccessWithStatus:@"发送成功~"];
                                      [self createLogs];
                                  }
                                      break;
                                  case YBLMessageComposeResultCancelled:
                                  {
                                      [SVProgressHUD showInfoWithStatus:@"取消发送~"];
                                  }
                                      break;
                                  case YBLMessageComposeResultFailed:
                                  {
                                      [SVProgressHUD showErrorWithStatus:@"发送失败~"];
                                  }
                                      break;
                                      
                                  default:
                                      break;
                              }
                             
                          }];
        }];
    }
    return _sendButton;
}

- (void)setSelectCountInfo:(NSInteger)selectCount{
    NSString *fin_count = [NSString stringWithFormat:@"%ld",selectCount];
    NSString *final_string = [NSString stringWithFormat:@"选择通知(%@)商业伙伴",fin_count];;
    NSRange count_range = [final_string rangeOfString:fin_count];
    NSMutableAttributedString *mu_att = [[NSMutableAttributedString alloc] initWithString:final_string];
    [mu_att addAttributes:@{NSForegroundColorAttributeName:YBLThemeColor,
                            NSFontAttributeName:YBLFont(14)} range:NSMakeRange(count_range.location, count_range.length)];
    infoLabel1.attributedText = mu_att;
//    infoLabel1.text = final_string;
}

- (void)setContentTextViewMessage:(NSString *)message{
    if (!message) {
        message = @"“请选择您的商品”";
    }
    NSString *shopName = [YBLUserManageCenter shareInstance].userInfoModel.shopname;
    _contentString = [NSString stringWithFormat:@"【云采商城】%@:%@,更多产品更低价格,期待合作 %@ ，回TD退订",shopName,message,@"http://dwz.cn/6ldb7y"];
    _contentTextView.text = _contentString;
}

- (void)handleSelectCustomers{
    
    NSInteger selectCount = self.customers.count;
    
    [self setSelectCountInfo:selectCount];
    //
    NSInteger final_count = selectCount>=button_count?button_count-1:selectCount;
    for (int i = 0; i < button_count; i++) {
        YBLCustomersLabel *fakeImgeView = [self.view viewWithTag:tag_image+i];
        if (!fakeImgeView) {
            fakeImgeView = [[YBLCustomersLabel alloc] initWithFrame:CGRectMake(space+(i*(add_button_wi+space)), infoLabel1.bottom, add_button_wi, add_button_wi)];
            fakeImgeView.tag = tag_image+i;
            fakeImgeView.hidden = YES;
            [_selectCustomerView addSubview:fakeImgeView];
        }
        YBLMineMillionMessageItemModel *model_1 = self.customers[i];
        fakeImgeView.text = model_1.first_name;
        fakeImgeView.backgroundColor = model_1.name_bg_color;
        fakeImgeView.hidden = i<final_count?NO:YES;
    }
    _addButton.left = space+(final_count*(add_button_wi+space));
}

- (void)createUI {

    _selectCustomerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    _selectCustomerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectCustomerView];
    
    infoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, _selectCustomerView.width, 40)];
    infoLabel1.textColor = YBLTextColor;
    infoLabel1.font = YBLFont(12);
    [_selectCustomerView addSubview:infoLabel1];
    [self setSelectCountInfo:0];
    
    button_count = 7;
    
    add_button_wi = (YBLWindowWidth-space)/button_count-space;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(space, infoLabel1.bottom, add_button_wi, add_button_wi);
    [_addButton setImage:[UIImage imageNamed:@"bg_photo_add"] forState:UIControlStateNormal];
    [_selectCustomerView addSubview:_addButton];
    
    _selectCustomerView.height = _addButton.bottom+space;
    
    WEAK
    [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        /**
         *  选择客户
         */
        YBLMineMillionMessageViewModel *viewModel = [YBLMineMillionMessageViewModel new];
        viewModel.selectCustomerArray = self.customers;
        viewModel.millionType = MillionTypeSelect;
        viewModel.selectBlock = ^(NSMutableArray *selectAray) {
            STRONG
            self.customers = selectAray;
            [self handleSelectCustomers];
        };
        YBLMineMillionMessageViewController *millionVc = [YBLMineMillionMessageViewController new];
        millionVc.viewModel = viewModel;
        [self.navigationController pushViewController:millionVc animated:YES];

    }];
    
    _writeCustomerView = [[UIView alloc] initWithFrame:CGRectMake(0, _selectCustomerView.bottom+space, YBLWindowWidth, 200)];
    _writeCustomerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_writeCustomerView];

    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel getModelWith:@"选择商品"
                                                                       value:nil
                                                                  isRequired:YES
                                                                        type:EditTypeCellOnlyClick
                                                                  paraString:nil
                                                                keyboardType:UIKeyboardTypeDefault];;

    YBLEditPurchaseCell *cell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, 0, _writeCustomerView.width, 50);
    [cell updateItemCellModel:model];
    [_writeCustomerView addSubview:cell];
    [[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        /**
         *  选择商品
         */
        YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
        viewModel.listVCType = ListVCTypeStoreGoodSingleSelect;
        viewModel.openedExpressCompanyGoodListDataArray = self.selectGoodArray;
        viewModel.logisticsCompanyAndGoodListBlock = ^(NSMutableArray *selectArray) {
            STRONG
            self.selectGoodArray = selectArray;
            YBLGoodModel *goodModel = selectArray[0];
            NSString *final_string = [NSString stringWithFormat:@"%@ %@ ¥:%@",goodModel.title,goodModel.specification,goodModel.price];
            [self setContentTextViewMessage:final_string];
        };
        YBLLogisticsCompanyAndGoodListViewController *listVc = [YBLLogisticsCompanyAndGoodListViewController new];
        listVc.viewModel = viewModel;
        [self.navigationController pushViewController:listVc animated:YES];
    }];
    
    _contentTextView = [[YBLlimmitTextView alloc] initWithFrame:CGRectMake(space, cell.bottom+space, _writeCustomerView.width-space*2, _writeCustomerView.height-cell.bottom-space*2)
                                                           type:LimmitTextViewTypeShowLengthLabel];
    _contentTextView.limmteTextLength = 200;
    _contentTextView.backgroundColor = YBLColor(230, 230, 230, 1);
    _contentTextView.textColor = BlackTextColor;
    _contentTextView.font = YBLFont(15);
    [_writeCustomerView addSubview:_contentTextView];
    
    [self setContentTextViewMessage:nil];
    
    [self.view addSubview:self.sendButton];
    
    [self handleSelectCustomers];
}

@end
