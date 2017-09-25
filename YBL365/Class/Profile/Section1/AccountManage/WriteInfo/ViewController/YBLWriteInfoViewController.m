//
//  YBLWriteInfoViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWriteInfoViewController.h"
#import "YBLlimmitTextView.h"
#import "YBLLoginViewModel.h"
#import "YBLStoreBrandView.h"

@interface YBLWriteInfoViewController ()<YBLStoreBrandViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, retain) UILabel *nichengLabel;

@property (nonatomic, strong) YBLlimmitTextView *valueTextField;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) YBLStoreBrandView *brandView;

@end

@implementation YBLWriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [@"修改" stringByAppendingString:self.titleString];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveValue)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self createUI];
}

- (void)createUI{
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentScrollView];
    
    UIView *topVieww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 55)];
    topVieww.backgroundColor = YBLColor(248, 248, 248, 1);
    [self.contentScrollView addSubview:topVieww];
    
    self.valueTextField = [[YBLlimmitTextView alloc] initWithFrame:CGRectMake(space, 0, topVieww.width-2*space, topVieww.height)];
    self.valueTextField.font = YBLFont(16);
    self.valueTextField.text = self.textValue;
    self.valueTextField.backgroundColor = YBLColor(248, 248, 248, 1);
    [self.valueTextField becomeFirstResponder];
    [topVieww addSubview:self.valueTextField];
    
    UILabel *nichengLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, topVieww.bottom, topVieww.width, 30)];
    nichengLabel.textColor = YBLTextColor;
    nichengLabel.font = YBLFont(12);
    [self.contentScrollView addSubview:nichengLabel];
    self.nichengLabel = nichengLabel;
    
    if ([self.infoString isEqualToString:@"e_mail"]) {
        
        self.nichengLabel.hidden = YES;
        self.valueTextField.limmteTextLength = 30;
        self.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
        
    } else if ([self.infoString isEqualToString:@"nickname"]) {
        
        self.nichengLabel.hidden = NO;
        self.valueTextField.limmteTextLength = limit_for_name;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
        nichengLabel.text = @"4 - 20个字符,可由中英文、数字、“_”、“-”组成";
        
    } else if ([self.infoString isEqualToString:@"registration_numbe"]){
        
        self.valueTextField.text = self.undefineValue;
        self.valueTextField.limmteTextLength = 50;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
        
    } else if([self.infoString isEqualToString:@"mobile"]){

        self.valueTextField.text = self.undefineValue;
        self.valueTextField.limmteTextLength = maxLength_for_phone;
        self.valueTextField.keyboardType = UIKeyboardTypePhonePad;

    } else if ([self.infoString isEqualToString:@"tel"]){
        
        self.valueTextField.text = self.undefineValue;
        self.valueTextField.limmteTextLength = maxLength_for_massage;
        self.valueTextField.keyboardType = UIKeyboardTypePhonePad;
        
    }else if ([self.infoString isEqualToString:@"licensing_brand"]){

        self.valueTextField.limmteTextLength = 200;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
        nichengLabel.text = @"多个品牌之间请使用英文逗点(,)分隔。";
        
        self.contentScrollView.height -= self.addButton.height;
        
        [self checkIsArray];
        
        [self updateBrandView];
        
    } else if ([self.infoString isEqualToString:@"shop_name"]){

        self.valueTextField.text = self.undefineValue;
        self.valueTextField.limmteTextLength = limit_for_name;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
        
    } else if ([self.infoString isEqualToString:@"range"]){
        
        [self checkIsArray];
        
        NSString *value = [YBLMethodTools getAppendingTitleStringWithArray:self.undefineValue appendingKey:@","];
        self.valueTextField.text = value;
        self.valueTextField.limmteTextLength = 100;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
        
    } else {
        self.valueTextField.text = self.undefineValue;
        self.valueTextField.limmteTextLength = 50;
        self.valueTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
}   

- (void)saveValue {
    
    [self.view endEditing:YES];

    NSString *textValueString = self.valueTextField.text;
    
    if ([self.infoString isEqualToString:@"e_mail"]||[self.infoString isEqualToString:@"nickname"]) {
        
        if (textValueString.length==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没输入内容呢~"];
            return;
        }
        
        if ([self.infoString isEqualToString:@"e_mail"]&&![YBLMethodTools checkEmail:textValueString]) {
            [SVProgressHUD showErrorWithStatus:@"邮箱格式不对哦~"];
            return;
        }
        WEAK
        [[YBLLoginViewModel siganlForUpdateUserInfoWithKey:self.infoString value:textValueString] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            BLOCK_EXEC(self.writeInfoValueBlock,textValueString)
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } else {
        
        if([self.infoString isEqualToString:@"mobile"]&&textValueString.length!=11){
            return [SVProgressHUD showErrorWithStatus:@"手机号格式不对哦~"];
        }
    
        NSString *keyss = [self checkHasKongStringWith:textValueString];

        BLOCK_EXEC(self.writeInfoValueBlock,keyss)
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (NSString *)checkHasKongStringWith:(NSString *)textValueString{
    NSString *textSi = @"，";
    if ([textValueString rangeOfString:textSi].location != NSNotFound) {
        textValueString = [textValueString stringByReplacingOccurrencesOfString:textSi withString:@","];
    }
    //品牌
    if ([self.infoString isEqualToString:@"licensing_brand"]||[self.infoString isEqualToString:@"range"]) {
        if ([self.undefineValue isKindOfClass:[NSString class]]) {
            textValueString = self.undefineValue;
        } else if ([self.undefineValue isKindOfClass:[NSMutableArray class]]) {
            textValueString = [YBLMethodTools getAppendingStringWithArray:self.undefineValue appendingKey:@","];
        }
    }
    return textValueString;
}

- (void)updateBrandView{
    self.brandView.brandDataArray = self.undefineValue;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.brandView.bottom);
}

- (void)checkIsArray{
    
    if ([self.undefineValue isKindOfClass:[NSString class]]) {
        //        self.undefineValue = [self.undefineValue stringByAppendingString:[NSString stringWithFormat:@",%@",textValueString]];
        NSString *compString = (NSString *)self.undefineValue;
        if ([compString rangeOfString:@","].location==NSNotFound) {
            self.undefineValue = @[compString].mutableCopy;
        } else {
            NSArray *compenArray = [compString componentsSeparatedByString:@","];
            self.undefineValue = compenArray.mutableCopy;
        }
    }
}

- (void)updateValue{
    
    NSString *textValueString = self.valueTextField.text;

    [self checkIsArray];
    
    NSMutableArray *value_array = (NSMutableArray *)self.undefineValue;
    if ([textValueString rangeOfString:@","].location==NSNotFound) {
        [value_array addObject:textValueString];
    } else {
        NSArray *new_aa = [textValueString componentsSeparatedByString:@","];
        [value_array addObjectsFromArray:new_aa];
    }

}

- (UIButton *)addButton{
    
    if (!_addButton) {
        _addButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
        _addButton.bottom = YBLWindowHeight-kNavigationbarHeight;
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        WEAK
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (self.valueTextField.text.length==0) {
                [SVProgressHUD showErrorWithStatus:@"您还没输入内容呢~"];
                return;
            }
            [self updateValue];
            [self updateBrandView];
            self.valueTextField.text = nil;
        }];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}

- (YBLStoreBrandView *)brandView{
    
    if (!_brandView) {
        YBLStoreBrandView *brandView = [[YBLStoreBrandView alloc] initWithFrame:CGRectMake(0, self.nichengLabel.bottom+space*2, YBLWindowWidth, 100)];
        brandView.delegate = self;
        [self.contentScrollView addSubview:brandView];
        _brandView = brandView;
    }
    return _brandView;
}

- (void)brandItemClickToDelete:(NSInteger)index{

    WEAK
    [YBLOrderActionView showTitle:@"确定要删除此授权品牌吗?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      STRONG
                      NSMutableArray *unfo_array = (NSMutableArray *)self.undefineValue;
                      [unfo_array removeObjectAtIndex:index];
                      self.brandView.brandDataArray = unfo_array;
                  }
                      cancelBlock:^{
                          
                      }];

}

@end
