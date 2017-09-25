//
//  YBLEditPurchasePayShippingmentView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchasePayShippingmentView.h"
#import "YBLpurchaseInfosModel.h"
#import "YBLEdictPurchaseViewModel.h"
#import "YBLButtonsView.h"
#import "YBLpurchaseInfosModel.h"
#import "YBLAllPayShipButtonView.h"
/*
@interface EditPurchasePayShippingmentViewItemCell : UITableViewCell

@property (nonatomic, retain) UILabel *itemTitleLabel;

@property (nonatomic, retain) UILabel *itemDesLabel;

@property (nonatomic, strong) UIButton *selectButton;

+ (CGFloat)getHi;

@end

@implementation EditPurchasePayShippingmentViewItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [EditPurchasePayShippingmentViewItemCell getHi];
    CGFloat buttonWi = 30;
    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 6, YBLWindowWidth-buttonWi-2*space, 17)];
    itemTitleLabel.textColor = BlackTextColor;
    itemTitleLabel.font = YBLFont(15);
    [self.contentView addSubview:itemTitleLabel];
    self.itemTitleLabel = itemTitleLabel;
    
    UILabel *itemDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemTitleLabel.left, itemTitleLabel.bottom, itemTitleLabel.width, hi-itemTitleLabel.height-5)];
    itemDesLabel.textColor = YBLTextColor;
    itemDesLabel.numberOfLines = 2;
    itemDesLabel.font = YBLFont(13);
    [self.contentView addSubview:itemDesLabel];
    self.itemDesLabel = itemDesLabel;
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(itemTitleLabel.right, 0, buttonWi, buttonWi);
    selectButton.centerY = hi/2;
    [selectButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    selectButton.userInteractionEnabled = NO;
    [self.contentView addSubview:selectButton];
    self.selectButton = selectButton;
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, .5)]];
}

+ (CGFloat)getHi{
    
    return 70;
}

@end
 */


static CGFloat Top = 120;

static YBLEditPurchasePayShippingmentView *editPurchasePayShippingmentView = nil;

@interface YBLEditPurchasePayShippingmentView ()
{
    NSInteger currentIndex;
}
@property (nonatomic, strong) NSString *payValue;
@property (nonatomic, strong) NSString *payTitle;
@property (nonatomic, strong) NSString *shippingValue;
@property (nonatomic, strong) NSString *shippingTitle;
@property (nonatomic, weak  ) UIViewController *VC;
@property (nonatomic, copy  ) EditPurchasePayShippingmentViewSelectBlock block;
@property (nonatomic, assign) MentType type;
@property (nonatomic, assign) SelectionType selectionType;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableDictionary *data_dict;
@property (nonatomic, strong) YBLAllPayShipButtonView *allPayShipButtonsView;

@end

@implementation YBLEditPurchasePayShippingmentView

+ (void)showEditPurchasePayShippingmentViewInVC:(UIViewController *)VC
                                           undefineData:(NSMutableArray *)undefineData
                                           Type:(MentType)type
                                  SelectionType:(SelectionType)selectionType
                                         Handle:(EditPurchasePayShippingmentViewSelectBlock)block{
    if (!editPurchasePayShippingmentView) {
        
        editPurchasePayShippingmentView = [[YBLEditPurchasePayShippingmentView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                                                           ViewInVC:VC
                                                                                       undefineData:undefineData
                                                                                               Type:type
                                                                                      SelectionType:selectionType
                                                                                             Handle:block];
    }
    [YBLMethodTools transformOpenView:editPurchasePayShippingmentView.contentView
                            SuperView:editPurchasePayShippingmentView
                              fromeVC:editPurchasePayShippingmentView.VC
                                  Top:Top];
}

+ (void)showEditPurchasePayShippingmentViewInVC:(UIViewController *)VC
                                   undefineData:(NSMutableArray *)undefineData
                                         Handle:(EditPurchasePayShippingmentViewSelectBlock)block{
    
    
    [self showEditPurchasePayShippingmentViewInVC:VC
                                     undefineData:undefineData
                                             Type:MentTypeAllMent
                                    SelectionType:SelectionTypeSingle
                                           Handle:block];
}


- (instancetype)initWithFrame:(CGRect)frame
                     ViewInVC:(UIViewController *)VC
                         undefineData:(NSMutableArray *)undefineData
                         Type:(MentType)type
                SelectionType:(SelectionType)selectionType
                       Handle:(EditPurchasePayShippingmentViewSelectBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _VC = VC;
        _data = undefineData;
        _type = type;
        _selectionType = selectionType;
        _block = block;
        currentIndex = 0;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds]];
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
    titleLable.font = YBLFont(17);
    [topView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height-0.5, topView.width, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [topView addSubview:lineView];
    WEAK
    titleLable.text = @"选择支付以及配送时效";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.contentView.width, self.contentView.height-buttonHeight-titleLable.bottom)];
    self.scrollView.backgroundColor = YBLViewBGColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.scrollView];
    
    self.allPayShipButtonsView = [[YBLAllPayShipButtonView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 100)
                                                                      dataArray:_data];
    self.allPayShipButtonsView.allPayShipButtonViewUpdateHeightBlock = ^{
        STRONG
        self.scrollView.contentSize = CGSizeMake(self.contentView.width, self.allPayShipButtonsView.height);
    };
    [self.scrollView addSubview:self.allPayShipButtonsView];
    
    
    UIButton *saveButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, self.contentView.height-buttonHeight, self.contentView.width, buttonHeight)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    /*保存*/
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (self.allPayShipButtonsView.selectDataDict.count==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选择呢~~"];
            return ;
        }
        [self.allPayShipButtonsView getFinalData];
        NSArray *idsArray = self.allPayShipButtonsView.paraPayShipIdsArray;
        NSString *pay_distribution_titles = self.allPayShipButtonsView.paraPayShipTitles;
        BLOCK_EXEC(self.block,pay_distribution_titles,[idsArray mutableCopy])
        [self dismiss];
    }];
    [self.contentView addSubview:saveButton];
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.contentView SuperView:editPurchasePayShippingmentView fromeVC:self.VC Top:YBLWindowHeight completion:^(BOOL finished) {
        [editPurchasePayShippingmentView removeFromSuperview];
        editPurchasePayShippingmentView = nil;
    }];
}

@end
