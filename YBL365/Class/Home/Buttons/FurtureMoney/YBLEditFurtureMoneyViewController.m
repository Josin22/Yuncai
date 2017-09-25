//
//  YBLEditFurtureMoneyViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditFurtureMoneyViewController.h"

static NSInteger textFeild_Tag = 2833;

@interface YBLEditFurtureMoneyViewController ()

@end

@implementation YBLEditFurtureMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新建";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];
    saveItem.tintColor = YBLThemeColor;
    self.navigationItem.rightBarButtonItem = saveItem;
    
    
    [self creatUI];
}

- (void)saveClick:(UIBarButtonItem *)item{
    
}


- (void)creatUI{
    
    CGFloat itemHi = 30;
 
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 2*space, YBLWindowWidth, itemHi*3)];
    [self.view addSubview:topView];
    
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageButton.frame = CGRectMake(space*2, 0, itemHi*2, itemHi*2);
    [addImageButton setImage:[UIImage imageNamed:@"add_grey_icon"] forState:UIControlStateNormal];
    addImageButton.layer.borderColor = YBLLineColor.CGColor;
    addImageButton.layer.borderWidth = 0.5;
    [topView addSubview:addImageButton];
    
    NSArray *titleArray = @[@[@"公司 : ",@"请输入公司名称"]
                            ,@[@"姓名 : ",@"请输入姓名"]
                            ,@[@"手机 : ",@"请输入手机号码"]];
    NSInteger index = 0;
    for (NSArray *indexArray in titleArray) {
        
        NSString *labelString = indexArray[0];
        CGSize labelStringSize = [labelString heightWithFont:YBLFont(15) MaxWidth:200];
        NSString *textFeildPString = indexArray[1];
        
        UIView *singeView = [[UIView alloc] initWithFrame:CGRectMake(addImageButton.right+space*2, index*itemHi, topView.width-addImageButton.right-space*3, itemHi)];
        [topView addSubview:singeView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelStringSize.width, labelStringSize.height)];
        label.textColor = BlackTextColor;
        label.text = labelString;
        label.font = YBLFont(15);
        [singeView addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, label.top, singeView.width-label.right, label.height)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = textFeildPString;
        textField.font = YBLFont(15);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = (textFeild_Tag+index);
        textField.textColor = BlackTextColor;
        [singeView addSubview:textField];
        if (index == 1) {
            UIButton *addLianxiRenButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addLianxiRenButton.frame = CGRectMake(0, 0, 20, 20);
            [addLianxiRenButton setImage:[UIImage imageNamed:@"add_green_icon"] forState:UIControlStateNormal];
            textField.rightView = addLianxiRenButton;
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
        
        [singeView addSubview:[YBLMethodTools addLineView:CGRectMake(textField.left, textField.bottom+5, textField.width, 0.5)]];
        
        index++;
    }
    
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+2*space, topView.width, 45)];
    [self.view addSubview:categoryView];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, categoryView.height)];
    [categoryView addSubview:categoryLabel];
    categoryLabel.text = @"商品类目 : ";
    categoryLabel.textColor = BlackTextColor;
    categoryLabel.font = YBLFont(14);
    
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [categoryView addSubview:categoryButton];
    categoryButton.frame = CGRectMake(categoryLabel.right, 0, categoryView.width-categoryLabel.right-space*3-8, categoryView.height);
    categoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [categoryButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [categoryButton setTitle:@"请选择商品类目" forState:UIControlStateNormal];
    categoryButton.titleLabel.font = YBLFont(14);
    WEAK
    [[categoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG

    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.center = CGPointMake(categoryButton.right+20, categoryView.height/2);
    [categoryView addSubview:arrowImageView];
    
    [categoryView addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, categoryView.width, 0.5)]];
    [categoryView addSubview:[YBLMethodTools addLineView:CGRectMake(0, categoryView.height-0.5, categoryView.width, 0.5)]];
}

@end
