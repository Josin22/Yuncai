//
//  YBLRegionalAgentViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRegionalAgentViewController.h"
#import "SMTextField.h"
#import "YBLAgentRulesViewController.h"
#import "YBLChooseCityView.h"
#import "ZJUsefulPickerView.h"
#import "YBLAgentViewModel.h"
#import "IQKeyboardManager.h"

static const NSInteger textFeild_tag = 5343;

@interface YBLRegionalAgentViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) YBLAgentViewModel *viewModel;

@end

@implementation YBLRegionalAgentViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"区域代理";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createUI];
    
}

- (YBLAgentViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [YBLAgentViewModel new];
        AgentParaModel *model = [AgentParaModel new];
        _viewModel.agentParaModel = model;
    }
    return _viewModel;
}

- (void)createUI{
 
    UIImage *image = [UIImage imageNamed:@"profile_daili_bg"];
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)];
    CGFloat hi = ((double)2070/750)*imageScrollView.width;
    imageScrollView.delegate = self;
    imageScrollView.contentSize = CGSizeMake(imageScrollView.width, hi);
    [self.view addSubview:imageScrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageScrollView.width, hi)];
    imageView.image = image;
    [imageScrollView addSubview:imageView];
    
    CGFloat contentHi = (double)(2070-1120)/2070 *hi;
    CGFloat bottom =  hi-contentHi;
    
    CGFloat itemHI = (contentHi-space*8)/8;
    NSArray *pla = @[@"公司名称",@"* 代理商姓名",@"* 联系电话",@"* 电子邮箱",@"* 意向地区",@"* 请选择资金范围"];
    NSInteger index = 0;
    for (NSString *plaString in pla) {
        
        SMTextField *textFeild = [[SMTextField alloc] initWithFrame:CGRectMake(space*2, bottom+index*(itemHI+space), imageScrollView.width-4*space, itemHI)];
        textFeild.tag = textFeild_tag+index;
        textFeild.borderStyle = UITextBorderStyleNone;
        textFeild.placeholder = plaString;
        textFeild.font = YBLFont(16);
        textFeild.backgroundColor = [UIColor whiteColor];
        textFeild.delegate = self;
        textFeild.layer.borderColor = YBLLineColor.CGColor;
        textFeild.layer.borderWidth = 0.8;
        textFeild.layer.cornerRadius = 3;
        textFeild.layer.masksToBounds = YES;
        textFeild.textColor = BlackTextColor;
        textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
        [imageScrollView addSubview:textFeild];
        if (index == 2) {
            textFeild.keyboardType = UIKeyboardTypePhonePad;
        } else if (index == 4){
#pragma mark 意向地址
            UIButton *address = [UIButton buttonWithType:UIButtonTypeCustom];
            address.frame = [textFeild bounds];
            [textFeild addSubview:address];
            WEAK
            [[address rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG
                [self.view endEditing:YES];
                [YBLChooseCityView chooseCityWithViewController:self.navigationController
                 
                                                      cityCount:2
                                                   cityViewType:ChooseCityViewTypeWithDismissButton
                                                   successBlock:^(YBLAddressAreaModel *model,NSMutableArray *selectArray){
                                                       STRONG
                                                       NSString *final = [YBLMethodTools getFullAppendingAddressWithArray:selectArray];
                                                       SMTextField *textFF = (SMTextField *)[self.view viewWithTag:textFeild_tag+index];
                                                       textFF.text = final;
                                                       self.viewModel.agentParaModel.county = [NSString stringWithFormat:@"%@",model.id];
                                                   }];
            }];
            
        }else if (index == 5){
#pragma mark 资金范围
            UIButton *money = [UIButton buttonWithType:UIButtonTypeCustom];
            money.frame = [textFeild bounds];
            [textFeild addSubview:money];
            WEAK
            [[money rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG
                [self.view endEditing:YES];
                [[self.viewModel siganlForAgentPrice] subscribeNext:^(NSMutableArray*  _Nullable x) {
                    STRONG
                    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"请选择资金范围"
                                                                  withData:self.viewModel.titeArray
                                                          withDefaultIndex:0
                                                         withCancelHandler:^{
                                                             
                                                         }
                                                           withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                               STRONG
                                                               SMTextField *textFF = (SMTextField *)[self.view viewWithTag:textFeild_tag+index];
                                                               textFF.text = selectedValue;
                                                               PriceRangeModel *model = self.viewModel.priceRangeArray[selectedIndex];
                                                               self.viewModel.agentParaModel.agent_price_range_id = model._id;
                                                           }];
                } error:^(NSError * _Nullable error) {
                    
                }];
                
            }];
            
            UILabel *labelInfoLABEL = [[UILabel alloc] initWithFrame:CGRectMake(textFeild.left, textFeild.bottom, textFeild.width, 20)];
            labelInfoLABEL.text = @"* 为必填项,请你如实填写,云采平台不会把您的信息透露给第三方";
            labelInfoLABEL.textColor = BlackTextColor;
            labelInfoLABEL.font = YBLFont(11);
            [imageScrollView addSubview:labelInfoLABEL];
            
            UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            commitButton.frame = CGRectMake(labelInfoLABEL.left, labelInfoLABEL.bottom+itemHI/2, labelInfoLABEL.width, itemHI);
            [commitButton setTitle:@"提交" forState:UIControlStateNormal];
            [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [commitButton setTitleColor:YBLColor(140, 140, 140, 1) forState:UIControlStateDisabled];
            [commitButton setBackgroundColor:YBLColor(210, 210, 210, 1) forState:UIControlStateDisabled];
            [commitButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
            commitButton.layer.cornerRadius = 3;
            commitButton.layer.masksToBounds = YES;
            [imageScrollView addSubview:commitButton];
#pragma mark 提交
            [[commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG
                BOOL isHaveTextValue = YES;
                for (int i = 0; i<4; i++) {
                    SMTextField *textt = (SMTextField *)[self.view viewWithTag:textFeild_tag+i];
                    if (textt.text.length==0) {
                        isHaveTextValue = NO;
                    } else {
                        switch (i) {
                            case 0:
                            {
                                self.viewModel.agentParaModel.company_name = textt.text;
                            }
                                break;
                            case 1:
                            {
                                self.viewModel.agentParaModel.name = textt.text;
                            }
                                break;
                            case 2:
                            {
                                self.viewModel.agentParaModel.mobile = textt.text;
                            }
                                break;
                            case 3:
                            {
                                self.viewModel.agentParaModel.e_mail = textt.text;
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
                if (self.viewModel.agentParaModel.county.length==0||self.viewModel.agentParaModel.agent_price_range_id.length==0) {
                    isHaveTextValue = NO;
                }
                if (!isHaveTextValue) {
                    [SVProgressHUD showErrorWithStatus:@"您还没有填写完整~"];
                    return ;
                }
                
                [[self.viewModel siganlForAgent] subscribeNext:^(id  _Nullable x) {
                    STRONG
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                } error:^(NSError * _Nullable error) {
                    
                }];
            }];
            UIButton *xijieButton = [UIButton buttonWithType:UIButtonTypeCustom];
            xijieButton.frame = CGRectMake(commitButton.left, commitButton.bottom+5, commitButton.width, 20);
            xijieButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSString *text = @"详情请看<<云采平台城市代理细则>>";
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
            [string addAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:YBLFont(12)} range:NSMakeRange(0, 4)];
            [string addAttributes:@{NSForegroundColorAttributeName:YBLThemeColor,NSFontAttributeName:YBLFont(12)} range:NSMakeRange(4, text.length-4)];
            [xijieButton setAttributedTitle:string forState:UIControlStateNormal];
            [imageScrollView addSubview:xijieButton];
            
            [[xijieButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG
                YBLAgentRulesViewController *v1 = [YBLAgentRulesViewController new];
                [self.navigationController pushViewController:v1 animated:YES];
            }];
        }
        
        index++;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}

@end
