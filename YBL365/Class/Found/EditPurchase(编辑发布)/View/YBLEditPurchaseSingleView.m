//
//  YBLEditPurchaseSingleView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseSingleView.h"
#import "YBLEditPurchaseSingleCell.h"

static CGFloat Top = 120;

static NSInteger textFeildTag = 909;

static YBLEditPurchaseSingleView *singleView = nil;

@interface YBLEditPurchaseSingleView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak  ) UIViewController *VC;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, copy  ) EditPurchaseSingleViewSelectBlock block;
@property (nonatomic, assign) ditPurchaseSingleViewType type;
@property (nonatomic, strong) UITableView *editTableView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation YBLEditPurchaseSingleView

+ (void)showEditPurchaseSingleViewInVC:(UIViewController *)VC
                                  Data:(NSMutableArray *)data
                                  Type:(ditPurchaseSingleViewType)type
                                Handle:(EditPurchaseSingleViewSelectBlock)block{
    
    if (singleView == nil) {
        singleView = [[YBLEditPurchaseSingleView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                                 InVC:VC
                                                                 Data:data
                                                                 Type:type
                                                               Handle:block];

    }
    [YBLMethodTools transformOpenView:singleView.contentView
                            SuperView:singleView
                              fromeVC:singleView.VC
                                  Top:Top];
}

- (instancetype)initWithFrame:(CGRect)frame
                         InVC:(UIViewController *)VC
                         Data:(NSMutableArray *)data
                         Type:(ditPurchaseSingleViewType)type
                       Handle:(EditPurchaseSingleViewSelectBlock)block{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        _data = data;
        _VC = VC;
        _block = block;
        
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds ]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bg addGestureRecognizer:tap];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-Top)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    self.contentView = bgView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40.5)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];

    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topView.width, 40)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = BlackTextColor;
    titleLable.font = YBLFont(16);
    [topView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height-0.5, topView.width, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [topView addSubview:lineView];
    
    self.titleArray = [NSMutableArray array];

    UIKeyboardType type;
    
    if (self.type == ditPurchaseSingleViewTypeGoodsName) {
        
        self.titleArray = [@[@"输入商品名称 :"] mutableCopy];
        titleLable.text = @"商品名称编辑";
        type = UIKeyboardTypeDefault;
    } else if (self.type == ditPurchaseSingleViewTypeSpec) {
        self.titleArray = [@[@"输入商品规格 :"] mutableCopy];
        titleLable.text = @"商品规格";
        type = UIKeyboardTypeDefault;
    } else{
        
       self.titleArray = [@[@"输入条形码 :"] mutableCopy];
        titleLable.text = @"条形码编辑";
        type = UIKeyboardTypePhonePad;
    }
    
    NSInteger index = 0;
    
    for (NSString *title in self.titleArray) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+space+index*(40+space), self.width, 40)];
        bgView.backgroundColor = YBLColor(244, 244, 244, 1);
        [self.contentView addSubview:bgView];
        CGSize titleSize = [title heightWithFont:YBLFont(14) MaxWidth:200];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, titleSize.width, bgView.height)];
        label.textColor = BlackTextColor;
        label.font = YBLFont(14);
        label.text = title;
        [bgView addSubview:label];
        
        UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right+space, 0, bgView.width-label.right-space, bgView.height)];
        valueTextField.borderStyle = UITextBorderStyleNone;
        valueTextField.backgroundColor = [UIColor clearColor];
        valueTextField.font = YBLFont(14);
        valueTextField.tag = textFeildTag+index;
        valueTextField.delegate = self;
        valueTextField.returnKeyType = UIReturnKeyDone;
        valueTextField.keyboardType = type;
        valueTextField.placeholder = [title substringToIndex:title.length-1];
        valueTextField.textColor = YBLTextColor;
        [bgView addSubview:valueTextField];
        
        index++;
        
        if (index == self.titleArray.count) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.bottom+space-0.5, self.width, 0.5)];
            lineView.backgroundColor = YBLLineColor;
            [self.contentView addSubview:lineView];
            
            self.editTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, self.width, self.contentView.height-bgView.bottom-space) style:UITableViewStylePlain];
            self.editTableView.dataSource = self;
            self.editTableView.delegate = self;
            self.editTableView.rowHeight = [YBLEditPurchaseSingleCell getEditPurchaseSingleCellHeight];
            self.editTableView.tableFooterView = [UIView new];
            self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.editTableView.backgroundColor = [UIColor whiteColor];
            [self.editTableView registerClass:NSClassFromString(@"YBLEditPurchaseSingleCell") forCellReuseIdentifier:@"YBLEditPurchaseSingleCell"];
            [self.contentView addSubview:self.editTableView];
        }
    }
    
    
    UIButton *saveButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, self.contentView.height-buttonHeight, self.contentView.width, buttonHeight)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.contentView addSubview:saveButton];
    WEAK
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self saveTextValue];
    }];
    
}

- (void)saveTextValue{
    
    UITextField *textFeild = (UITextField *)[self.contentView viewWithTag:textFeildTag];
    if (textFeild.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写完整~"];
        return ;
    }
    [self.data insertObject:textFeild.text atIndex:0];
    [self.editTableView jsReloadData];
    [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
    for (NSInteger i = 0; i<self.titleArray.count; i++) {
        UITextField *textFeild = (UITextField *)[self.contentView viewWithTag:textFeildTag+i];
        textFeild.text = nil;
        
    }
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.contentView SuperView:singleView fromeVC:self.VC Top:YBLWindowHeight completion:^(BOOL finished) {
        [singleView removeFromSuperview];
        singleView = nil;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLEditPurchaseSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseSingleCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLEditPurchaseSingleCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.data[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLEditPurchaseSingleCell *cell = (YBLEditPurchaseSingleCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self dismiss];
    BLOCK_EXEC(self.block,cell.titleLabel.text);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self saveTextValue];
    return YES;
}

@end
