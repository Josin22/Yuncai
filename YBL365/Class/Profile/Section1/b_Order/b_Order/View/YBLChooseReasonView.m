//
//  YBLChooseReasonView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseReasonView.h"
#import "YBLOrderViewModel.h"


@interface YBLReasonChooseCell : UITableViewCell

@property (nonatomic, retain) UILabel *reasonLabel;
@property (nonatomic, strong) UIButton *circleButton;

@end

@implementation YBLReasonChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat circleButtonWi = 30;
    CGFloat cellHeight = [YBLReasonChooseCell getCellHeight];
    
    UIButton *circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    circleButton.frame = CGRectMake(space, 0, circleButtonWi, circleButtonWi);
    circleButton.centerY = cellHeight/2;
    circleButton.userInteractionEnabled = NO;
    [circleButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [circleButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [self.contentView addSubview:circleButton];
    self.circleButton = circleButton;
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(circleButton.right+space, 0, YBLWindowWidth-circleButton.right+2*space, cellHeight-space)];
    reasonLabel.numberOfLines = 0;
    reasonLabel.centerY = cellHeight/2;
    reasonLabel.textColor = YBLTextColor;
    reasonLabel.font = YBLFont(15);
    [self.contentView addSubview:reasonLabel];
    self.reasonLabel = reasonLabel;
}

+ (CGFloat)getCellHeight{
    
    return 45;
}

@end

#define TTTOP YBLWindowHeight/8

static YBLChooseReasonView *chooseReasonView = nil;

@interface YBLChooseReasonView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIViewController *Vc;

@property (nonatomic, strong) UITableView *reasonTableView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSMutableArray *reasonDataArray;

@property (nonatomic, copy  ) ChooseReasonViewDoneBlock chooseReasonViewDoneBlock;

@property (nonatomic, strong) NSString *select_reason;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) OrderSource orderSource;

@property (nonatomic, strong) YBLOrderRefuseReasonModel *reasonModel;

@property (nonatomic, strong) NSString *sub_type;

@property (nonatomic, strong) NSString *stateEn;

@end

@implementation YBLChooseReasonView

+ (void)showChooseReasonInView:(UIViewController *)Vc
                   orderSource:(OrderSource)orderSource
          handleCompeleteBlock:(ChooseReasonViewDoneBlock)handleCompeleteBlock{
    
    [self showChooseReasonInView:Vc
                         stateEn:nil
                     orderSource:orderSource
            handleCompeleteBlock:handleCompeleteBlock];
}

+ (void)showChooseReasonInView:(UIViewController *)Vc
                       stateEn:(NSString *)stateEn
                   orderSource:(OrderSource)orderSource
          handleCompeleteBlock:(ChooseReasonViewDoneBlock)handleCompeleteBlock{
    
    if (!chooseReasonView ) {
        chooseReasonView = [[YBLChooseReasonView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                               InView:Vc
                                                              stateEn:stateEn
                                                          orderSource:orderSource
                                                 handleCompeleteBlock:handleCompeleteBlock];
    }
    
    [YBLMethodTools transformOpenView:chooseReasonView.contentView SuperView:chooseReasonView fromeVC:Vc Top:TTTOP];
}

- (NSMutableArray *)reasonDataArray{
    if (!_reasonDataArray) {
         _reasonDataArray = [NSMutableArray array];
    }
    return _reasonDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
                       InView:(UIViewController *)Vc
                      stateEn:(NSString *)stateEn
                  orderSource:(OrderSource)orderSource
         handleCompeleteBlock:(ChooseReasonViewDoneBlock)handleCompeleteBlock{

    self = [super initWithFrame:frame];
    if (self) {
        
        _chooseReasonViewDoneBlock = handleCompeleteBlock;
        _orderSource = orderSource;
        _stateEn = stateEn;
        _Vc = Vc;
        
        [self creUI];
    }
    return self;
}

- (void)creUI{
    
    self.contentView.height = YBLWindowHeight-TTTOP;
    self.bgView.alpha = 0.1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    titleLabel.text = @"取消订单";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = YBLTextColor;
    [self.contentView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, titleLabel.width, .5)]];

    UILabel *titleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, titleLabel.bottom, self.contentView.width-2*space, 40)];
    titleInfoLabel.font = YBLFont(15);
    titleInfoLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleInfoLabel];
    
    self.reasonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleInfoLabel.bottom, self.contentView.width,self.contentView.height-titleInfoLabel.bottom-buttonHeight) style:UITableViewStylePlain];
    self.reasonTableView.dataSource = self;
    self.reasonTableView.delegate =self;
    self.reasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reasonTableView.showsVerticalScrollIndicator = NO;
    self.reasonTableView.rowHeight = [YBLReasonChooseCell getCellHeight];
    [self.reasonTableView registerClass:NSClassFromString(@"YBLReasonChooseCell") forCellReuseIdentifier:@"YBLReasonChooseCell"];
    [self.contentView addSubview:self.reasonTableView];
    

    UIButton *cancelButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, self.reasonTableView.bottom, self.reasonTableView.width, buttonHeight)];
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.contentView addSubview:cancelButton];
    self.cancelButton.enabled = NO;
    self.cancelButton = cancelButton;
    WEAK
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (self.select_reason.length>0) {
            BLOCK_EXEC(self.chooseReasonViewDoneBlock, self.reasonModel,self.selectIndex);
            [self dismiss];
        }
    }];
    
    if (_orderSource == OrderSourceBuyer) {
        titleInfoLabel.text = @"取消订单后,本单享有的优惠可能会一并取消。是否继续?";
//        titleInfoSmallLabel.text = @"请选择取消订单的原因(必选) : ";
        self.sub_type = @"customer_cancel_reason";
    } else if (_orderSource == OrderSourcePurchaseBuyer){
        titleInfoLabel.text = @"取消订单后,本单享有的优惠可能会一并取消。是否继续?";
//        titleInfoSmallLabel.text = @"请选择取消订单的原因(必选) : ";
        self.sub_type = [NSString stringWithFormat: @"%@_purchase_customer_cancel_reason",self.stateEn];
    } else if (_orderSource == OrderSourcePurchaseSeller){
        titleInfoLabel.text = @"取消订单后,本单享有的优惠可能会一并取消。是否继续?";
//        titleInfoSmallLabel.text = @"请选择取消订单的原因(必选) : ";
        self.sub_type = [NSString stringWithFormat: @"%@_purchase_seller_cancel_reason",self.stateEn];
    } else if (_orderSource == OrderSourceSeller){
        titleInfoLabel.text = @"是否继续拒绝接单?";
//        titleInfoSmallLabel.text = @"请选择拒绝接单的原因(必选) : ";
        self.sub_type = @"seller_reject_reason";
    }
    
    [self requestReasonData];
}

- (void)requestReasonData{
    
    WEAK
    [[YBLOrderViewModel getCancelOrderReason:self.sub_type] subscribeNext:^(YBLOrderRefuseReasonModel *  _Nullable x) {
        STRONG
        self.reasonModel = x;
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSString *reason in x.name) {
            [dataArray addObject:reason];
        }
        self.reasonDataArray = dataArray;
        [self.reasonTableView jsReloadData];
        self.cancelButton.enabled = YES;
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:chooseReasonView.contentView SuperView:chooseReasonView fromeVC:chooseReasonView.Vc Top:YBLWindowHeight completion:^(BOOL finished) {
        [chooseReasonView removeFromSuperview];
        chooseReasonView = nil;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.reasonDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLReasonChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLReasonChooseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLReasonChooseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    NSString *reasonString = self.reasonDataArray[row];
    cell.reasonLabel.text = reasonString;
    if ([self.select_reason isEqualToString:reasonString]) {
        cell.circleButton.selected = YES;
    } else {
        cell.circleButton.selected = NO;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    NSString *reasonString = self.reasonDataArray[row];
    self.select_reason = reasonString;
    self.selectIndex = row;
    [self.reasonTableView jsReloadData];
}

@end
