//
//  YBLAddStaffViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddStaffViewController.h"
#import "YBLFoundationMethod.h"
#import "YBLStaffManageViewModel.h"

static CGFloat const BASE_HEIGHT = 50;

static NSInteger const tag_button = 3231;

@interface YBLAddStaffViewController ()<UIScrollViewDelegate>
{
    NSArray *rolseTitleArray;
    NSInteger currentIndex;
    BOOL isAllRoles;
}
@property (nonatomic, strong) NSMutableArray *rolseArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, retain) XXTextField *nameTextField;
@property (nonatomic, retain) XXTextField *phoneTextField;

@end

@implementation YBLAddStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rolseTitleArray = @[@{dict_data_identity_key:@"销售经理",dict_data_identity_value:@"seller_manager"},
                        @{dict_data_identity_key:@"销售人员",dict_data_identity_value:@"seller_salesman"},
                        @{dict_data_identity_key:@"财务人员",dict_data_identity_value:@"seller_accountant"},
                        @{dict_data_identity_key:@"仓库人员",dict_data_identity_value:@"seller_warehouse_man"},
                        @{dict_data_identity_key:@"配送人员",dict_data_identity_value:@"seller_delivery_man"},
                        @{dict_data_identity_key:@"全职通",dict_data_identity_value:@"seller_manager,seller_salesman,seller_accountant,seller_warehouse_man,seller_delivery_man"}];
    
    [self createUI];
    
    if (self.staffManageModel) {
        self.navigationItem.title = @"编辑员工";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItem)];
        self.phoneTextField.text = self.staffManageModel.mobile;
        self.nameTextField.text = self.staffManageModel.name;
    } else {
        self.navigationItem.title = @"添加员工";
    }
}

- (NSMutableArray *)rolseArray{
    
    if (!_rolseArray) {
        _rolseArray = [NSMutableArray array];
        [_rolseArray addObject:@"seller_manager"];
    }
    return _rolseArray;
}

- (void)createUI{
    
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight - kNavigationbarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, BASE_HEIGHT*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bgView];
    
    self.personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.personButton];
//    self.personButton.frame = CGRectMake(self.scrollView.width - BASE_HEIGHT*2, 0, BASE_HEIGHT*2, BASE_HEIGHT*2);
    [self.personButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(BASE_HEIGHT*2));
        make.top.right.equalTo(@0);
    }];
    WEAK
    [[self.personButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [[YBLFoundationMethod shareInstance] showAddressBookWithVc:self handleSelectBlock:^(NSString *name, NSString *phone) {
            STRONG
            self.nameTextField.text = name;
            self.phoneTextField.text = phone;
        }];
    }];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_pick_btn_n"]];
    [self.personButton addSubview:personImageView];
    [personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.personButton.mas_centerX);
        make.bottom.equalTo(self.personButton.mas_centerY).with.offset(-3);
        make.width.height.equalTo(@30);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选联系人";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YBLColor(70, 70, 70, 1.0);
    label.font = YBLFont(14);
    [self.personButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@20);
        make.top.equalTo(self.personButton.mas_centerY).with.offset(3);
    }];
    
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = LINE_BASE_COLOR;
    [self.scrollView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(BASE_HEIGHT*2));
        make.top.equalTo(@0);
        make.width.equalTo(@0.5);
        make.right.equalTo(self.personButton.mas_left);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    nameLabel.text = @"员工名称:";
    nameLabel.font = YBLFont(16);
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@0);
        make.width.equalTo(@70);
        make.height.equalTo(@(BASE_HEIGHT));
    }];
    
    self.nameTextField = [self createTextField];
    self.nameTextField.maxLength = limit_for_name;
    [bgView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(10);
        make.top.equalTo(@0);
        make.height.equalTo(@(BASE_HEIGHT));
        make.right.equalTo(lineView1.mas_left).with.offset(-10);
    }];
    
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = LINE_BASE_COLOR;
    [bgView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.equalTo(@0.5);
        make.right.equalTo(lineView1.mas_left);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = YBLColor(70, 70, 70, 1.0);
    phoneLabel.text = @"联系方式:";
    phoneLabel.font = YBLFont(16);
    [bgView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(lineView2.mas_bottom);
        make.width.equalTo(@70);
        make.height.equalTo(@(BASE_HEIGHT));
    }];
    
    self.phoneTextField = [self createTextField];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.maxLength = maxLength_for_phone;
    [bgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).with.offset(10);
        make.top.equalTo(lineView2.mas_bottom);
        make.height.equalTo(@(BASE_HEIGHT));
        make.right.equalTo(lineView1.mas_left).with.offset(-10);
    }];
    
    
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = LINE_BASE_COLOR;
    [bgView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(phoneLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
 
    UILabel *titleChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.bottom+space, YBLWindowWidth, 30)];
    titleChooseLabel.text = @"职务选择";
    titleChooseLabel.textAlignment = NSTextAlignmentCenter;
    titleChooseLabel.font = YBLFont(16);
    [self.scrollView addSubview:titleChooseLabel];
    //按钮
    NSInteger payshiping_lie = rolseTitleArray.count>2?3:rolseTitleArray.count;
    
    CGFloat itemWi = (YBLWindowWidth-4*space)/payshiping_lie;
    CGFloat itemHi = 35;
    
    int index = 0;
    currentIndex = -1;
    
    for (NSDictionary *dict in rolseTitleArray) {
        
        
        
        NSString *title = dict[dict_data_identity_key];
        
        int row = index/payshiping_lie;
        int col = index%payshiping_lie;
        
        CGRect frame = CGRectMake(space+col*(itemWi+space), titleChooseLabel.bottom+space+row*(itemHi+space), itemWi, itemHi);
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
        itemButton.titleLabel.font = YBLFont(13);
        itemButton.centerX = (YBLWindowWidth/(payshiping_lie*2))*(col*2+1);
        itemButton.layer.cornerRadius = 3;
        itemButton.layer.masksToBounds = YES;
        itemButton.layer.borderWidth = .5;
        itemButton.layer.borderColor = YBLLineColor.CGColor;
        itemButton.tag = tag_button+index;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (index == 0) {
         itemButton.selected = YES;
        }
        [self.scrollView addSubview:itemButton];
        
        if (index == rolseTitleArray.count-1) {
            CGFloat scrollHi = itemButton.bottom+2*space;
            if (scrollHi<YBLWindowHeight) {
                scrollHi = YBLWindowHeight;
            }
            
            self.scrollView.contentSize = CGSizeMake(YBLWindowWidth, scrollHi);
        }
        
        index++;
    }
    
    
    
    UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-buttonHeight-space-kNavigationbarHeight, YBLWindowWidth-2*space, buttonHeight)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (self.nameTextField.text.length<=0||self.phoneTextField.text.length<5) {
            [SVProgressHUD showErrorWithStatus:@"您还没有填写完整呢~"];
            return ;
        }
        BOOL isPhoneVaild = [YBLMethodTools checkPhone:self.phoneTextField.text];
        if (!isPhoneVaild) {
            [SVProgressHUD showErrorWithStatus:@"手机号错误~"];
            return ;
        }
        
        NSString *_id = nil;
        NSString *rolse = nil;
        if (self.staffManageModel) {
            _id = self.staffManageModel.id;
        }
        if (isAllRoles) {
            rolse = [rolseTitleArray lastObject][dict_data_identity_value];
        } else {
            rolse = [YBLMethodTools getStaffRoleValueWithArray:self.rolseArray];
        }
        NSDictionary *salesMan = @{@"name":self.nameTextField.text,@"mobile":self.phoneTextField.text};
        
        [[YBLStaffManageViewModel signalForUpdateStaffWithID:_id rolse:rolse salesMan:salesMan] subscribeNext:^(YBLStaffManageModel *x) {
            STRONG
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError *error) {
            
        }];
        
    }];
//    
//    RAC(saveButton,enabled) = [RACSignal combineLatest:@[self.nameTextField.rac_textSignal,
//                                                         self.phoneTextField.rac_textSignal]
//                                                reduce:^id(NSString *name,NSString *phone){
//                                                    return @(name.length>0&&phone.length>5);
//                                                }];
}

- (XXTextField *)createTextField {
    XXTextField *textField = [[XXTextField alloc] init];
    textField.font = YBLFont(16);
    textField.textColor = YBLColor(70, 70, 70, 1.0);
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

- (void)goback1 {
    WEAK
    [YBLOrderActionView showTitle:@"当前您正在编辑员工,确定要放弃编辑吗?" cancle:@"我再想想" sure:@"确定" WithSubmitBlock:^{
        STRONG
        [self.navigationController popViewControllerAnimated:YES];
        
    }cancelBlock:^{
        
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (void)itemButtonClick:(UIButton *)btn {
    NSInteger index = btn.tag-tag_button;
    if (index != rolseTitleArray.count-1) {
        UIButton *itemButton = [self.view viewWithTag:rolseTitleArray.count-1+tag_button];
        itemButton.selected = NO;
        isAllRoles = NO;
        if (self.rolseArray.count<=1&&btn.selected) {
            return;
        }
        NSString *value = rolseTitleArray[index][dict_data_identity_value];
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.rolseArray containsObject:value]) {
                [self.rolseArray addObject:value];
            }
        } else {
            if ([self.rolseArray containsObject:value]) {
                [self.rolseArray removeObject:value];
            }
        }
    } else {
        if (btn.selected) {
            return;
        }
        for (int i = 0; i < rolseTitleArray.count-1; i++) {
            UIButton *itemButton = [self.view viewWithTag:i+tag_button];
            itemButton.selected = NO;
        }
        [self.rolseArray removeAllObjects];
        btn.selected = !btn.selected;
        isAllRoles = btn.selected;
    }
}

- (void)deleteItem {
    WEAK
    [YBLOrderActionView showTitle:@"是否删除当前员工?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      STRONG
                      [[YBLStaffManageViewModel signalForDeleteStaffWithid:self.staffManageModel.id] subscribeNext:^(id x) {
                          STRONG
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              [self.navigationController popViewControllerAnimated:YES];
                          });
                      } error:^(NSError *error) {
                          
                      }];
                  }
                      cancelBlock:^{
                          
                      }];
}

@end
