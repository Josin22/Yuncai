//
//  YBLAddInvoiceViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddInvoiceViewController.h"
#import "SMTextField.h"

static NSInteger const tag_taitou = 778;

static NSInteger const tag_invoice = 178;

@interface YBLAddInvoiceViewController (){
    
    NSInteger currentIndex;
    
}

@property (nonatomic, strong) UIView *invoiceView;

@property (nonatomic, strong) UIView *taitouView;

@property (nonatomic, strong) XXTextField *textField;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSArray *companyArray;

@property (nonatomic, strong) NSDictionary *supportedKindsDict;

@end

@implementation YBLAddInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加票据信息";
    
    [self createUI];
    
    [self requsetData];
    
    if (self.invoiceModel) {
        currentIndex = [self.companyArray indexOfObject:self.invoiceModel.company_or_person];
    }
    
}

- (YBLInvoiceModel *)invoiceModel{
    if (!_invoiceModel) {
        _invoiceModel = [YBLInvoiceModel new];
        _invoiceModel.kinds = [NSMutableArray array];
        _invoiceModel.company_or_person = self.companyArray[0];
    }
    return _invoiceModel;
}

- (void)requsetData{
    
    [YBLRequstTools HTTPGetDataWithUrl:url_orders_invoices
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 self.saveButton.enabled = YES;
                                 
                                 self.supportedKindsDict = [NSDictionary dictionary];
                                 self.supportedKindsDict = result[@"supported_kinds_cn"];
                                 
                                 [self handleSupportedKindsArray];
                                 
                                 
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   
                               }];
    
}

- (void)handleSupportedKindsArray{
 
    NSInteger lie = 3;
    CGFloat itemWi = (YBLWindowWidth-4*space)/lie;
    CGFloat itemHi = 35;
    int index = 0;
    for (NSString *jeys in [self.supportedKindsDict allKeys]) {
        NSString *value = self.supportedKindsDict[jeys];
        int row = index/lie;
        int col = index%lie;
        CGRect frame = CGRectMake(space+col*(itemWi+space), 40+row*(itemHi+space), itemWi, itemHi);
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:value forState:UIControlStateNormal];
        [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
        itemButton.titleLabel.font = YBLFont(13);
        itemButton.layer.cornerRadius = 3;
        itemButton.layer.masksToBounds = YES;
        itemButton.layer.borderWidth = .5;
        itemButton.layer.borderColor = YBLLineColor.CGColor;
        itemButton.tag = tag_invoice+index;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.invoiceView addSubview:itemButton];
        
        for (NSString *keys in self.invoiceModel.kinds) {
            if ([keys isEqualToString:jeys]) {
                itemButton.selected = YES;
            }
        }
        
        index++;
    }
    self.invoiceView.height += ceil((double)[self.supportedKindsDict allValues].count/lie)*itemHi;
    self.taitouView.top = self.invoiceView.bottom+space;
    
}

- (NSArray *)companyArray{
    if (!_companyArray) {
        _companyArray = @[@"person",@"company"];
    }
    return _companyArray;
}

- (void)createUI{
    
    CGFloat buttonwi = 80;
    
    //票据
    UIView *invoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 50)];
    invoiceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:invoiceView];
    self.invoiceView = invoiceView;
    
    UILabel *invoiceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, buttonwi, 20)];
    invoiceTitleLabel.textColor = BlackTextColor;
    invoiceTitleLabel.text = @"票据类型";
    invoiceTitleLabel.font = YBLFont(14);
    [invoiceView addSubview:invoiceTitleLabel];
    
    //抬头
    UIView *taitouView = [[UIView alloc] initWithFrame:CGRectMake(0, invoiceView.bottom+space, invoiceView.width, 80)];
    taitouView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:taitouView];
    self.taitouView = taitouView;
 
    UILabel *taitouTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, buttonwi, 20)];
    taitouTitleLabel.textColor = BlackTextColor;
    taitouTitleLabel.text = @"发票抬头";
    taitouTitleLabel.font = YBLFont(14);
    [taitouView addSubview:taitouTitleLabel];
    
    NSArray *taitouArray = @[@"个人",@"单位"];

    NSInteger index = 0;
    for (NSString *taitouString in taitouArray) {
        YBLButton *taitouButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        taitouButton.frame = CGRectMake(space+(buttonwi+space)*index, taitouTitleLabel.bottom+space, buttonwi, 20);
        [taitouButton setTitle:taitouString forState:UIControlStateNormal];
        [taitouButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [taitouButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
        [taitouButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
        [taitouButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
        taitouButton.imageRect = CGRectMake(0, 0, 20, 20);
        taitouButton.titleRect = CGRectMake(30, 0, buttonwi-30, 20);
        taitouButton.titleLabel.font = YBLFont(16);
        taitouButton.tag = tag_taitou+index;
        [taitouButton addTarget:self action:@selector(taitouButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [taitouView addSubview:taitouButton];
        if (self.invoiceModel.company_or_person) {
            NSString *upString = self.companyArray[index];
            if ([self.invoiceModel.company_or_person isEqualToString:upString]) {
                taitouButton.selected = YES;
            }
            
        } else {
            if (index == 0) {
                taitouButton.selected = YES;
            }
        }
        
        if (index == taitouArray.count-1) {
            XXTextField *textField = [[XXTextField alloc] initWithFrame:CGRectMake(space, taitouButton.bottom+space, YBLWindowWidth-2*space, 35)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.isAutoSpaceInLeft = YES;
            textField.maxLength = maxLength_for_massage;
            textField.placeholder = @"请填写个人名称";
            if (self.invoiceModel.title) {
                textField.text = self.invoiceModel.title;
            }
            textField.layer.cornerRadius = 3;
            textField.layer.masksToBounds = YES;
            textField.backgroundColor = YBLColor(231, 231, 231, 1);
            [taitouView addSubview:textField];
            self.textField = textField;
            
            self.taitouView.height = self.textField.bottom+space;
        }
        index++;
    }
    
    UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-2*space, buttonHeight)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.enabled = NO;
    [self.view addSubview:saveButton];
    self.saveButton = saveButton;
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.textField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有填写完整哟~"];
            return ;
        }

        self.invoiceModel.title = self.textField.text;
        
        BLOCK_EXEC(self.addInvoiceBlock,self.invoiceModel);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)itemButtonClick:(UIButton *)btn{
 
    NSInteger index = btn.tag - tag_invoice;
    
    btn.selected = !btn.selected;
    
    NSString *key = [self.supportedKindsDict allKeys][index];
    
    if (btn.selected) {
        if (![self.invoiceModel.kinds containsObject:key]) {
            [self.invoiceModel.kinds addObject:key];
        }
    } else {
        
        if ([self.invoiceModel.kinds containsObject:key]) {
            [self.invoiceModel.kinds removeObject:key];
        }
    }
    
}

- (void)taitouButtonClick:(UIButton *)btn{
    
    NSInteger index = btn.tag - tag_taitou;
    
    if (currentIndex!=index) {
        btn.selected = YES;
        UIButton *button = (UIButton *)[self.view viewWithTag:tag_taitou+currentIndex];
        button.selected = NO;

        self.textField.placeholder = index == 0?@"请填写个人名称":@"请填写单位名称";
        
        self.invoiceModel.company_or_person = self.companyArray[index];
        
        currentIndex = index;
    }

}


@end
