//
//  YBLGoodParameterView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodParameterView.h"
#import "YBLPurchaseShowIPayShipMentView.h"

@implementation GoodParaModel

+ (GoodParaModel *)getModelWithTitle:(NSString *)title value:(NSString *)value{
    GoodParaModel *model = [GoodParaModel new];
    model.title = title;
    model.value = value;
    return model;
}

@end

#pragma mark YBLGoodParameterCell

@interface YBLGoodParameterCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *valueLabel;

- (void)updateModel:(GoodParaModel *)model;

@end

@implementation YBLGoodParameterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, 40)];
    self.titleLabel.textColor = YBLTextColor;
    self.titleLabel.font = YBLFont(14);
    [self.contentView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, self.titleLabel.top, YBLWindowWidth-self.titleLabel.right-space, self.titleLabel.height)];
    self.valueLabel.textColor = YBLColor(70, 70, 70, 1);
    self.valueLabel.font = YBLFont(14);
    [self.contentView addSubview:self.valueLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, 39.5, YBLWindowWidth, .5)]];
}

- (void)updateModel:(GoodParaModel *)model{

    self.titleLabel.text = model.title;
    
    self.valueLabel.text = model.value;
}

@end

#pragma mark YBLGoodPayShippingmentCell

@interface YBLGoodPayShippingmentCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *valueLabel;

- (void)updateModel:(GoodParaModel *)model;

@end

@implementation YBLGoodPayShippingmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 10, 100, 20)];
    self.titleLabel.textColor = YBLThemeColor;
    self.titleLabel.layer.borderColor = YBLThemeColor.CGColor;
    self.titleLabel.layer.borderWidth = .5;
    self.titleLabel.layer.cornerRadius = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.font = YBLFont(12);
    [self.contentView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, self.titleLabel.top, YBLWindowWidth-self.titleLabel.right-space, self.titleLabel.height)];
    self.valueLabel.textColor = BlackTextColor;
    self.valueLabel.font = YBLFont(14);
    [self.contentView addSubview:self.valueLabel];
    
}

- (void)updateModel:(GoodParaModel *)model{

    self.titleLabel.text = model.title;
    self.valueLabel.text = model.value;
    
    CGSize titleSize = [model.title heightWithFont:YBLFont(13) MaxWidth:YBLWindowWidth-2*space];

    self.titleLabel.height = titleSize.height+2;
    self.titleLabel.width = titleSize.width+2;
    self.valueLabel.left = self.titleLabel.right+space;
    
    self.titleLabel.centerY = self.height/2;
    self.valueLabel.centerY = self.height/2;
}


@end

static YBLGoodParameterView *goodParameterView = nil;

static CGFloat const Top = 100;

@interface YBLGoodParameterView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIViewController *VC;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GoodParameterBlock goodParameterBlock;
@property (nonatomic, assign) ParaViewType paraViewType;
@property (nonatomic, strong) NSMutableArray *ruleDataArray;
@property (nonatomic, strong) NSMutableArray *payDetailArray;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) YBLPurchaseShowIPayShipMentView *itemShippingView;

@end

@implementation YBLGoodParameterView

- (NSMutableArray *)ruleDataArray{
    if (!_ruleDataArray) {
        _ruleDataArray = [NSMutableArray array];
        [_ruleDataArray addObject:[GoodParaModel getModelWithTitle:@"1.若参与订单报价不成功,保证金全额退还." value:nil]];
        [_ruleDataArray addObject:[GoodParaModel getModelWithTitle:@"2.若订单报价成功,您需要在买家规定的时间完成接单配送完成,物流发货信息提交流程." value:nil]];
        [_ruleDataArray addObject:[GoodParaModel getModelWithTitle:@"3.若你直接报价,系统将默认将您的报价比最低报价者低0.01元." value:nil]];
    }
    return _ruleDataArray;
}

- (NSMutableArray *)payDetailArray{
    if (!_payDetailArray) {
        _payDetailArray = [NSMutableArray array];
        [_payDetailArray addObject:[GoodParaModel getModelWithTitle:@"1.您发布的采购订单是根据您选择的发布时效决定的，例如：12小时发布结束" value:nil]];
        [_payDetailArray addObject:[GoodParaModel getModelWithTitle:@"2.如您在发布采购订单过程中没有供应商参与报价，在发布时效结束时该采购订单自动下架。同时您的采购保证金退还至【我的钱包】" value:nil]];
        [_payDetailArray addObject:[GoodParaModel getModelWithTitle:@"3.如您在发布采购订单过程中，有一名或多名供应商参与报价时，您可以随时选择其中一名成为该采购订单的供应商。同时该采购订单自动下架，形成订单，在【我的订单】查看订单状态。" value:nil]];
        [_payDetailArray addObject:[GoodParaModel getModelWithTitle:@"4.如您在发布采购订单过程中，有一名或多名供应商参与报价且您没做出选择报价供应商，该采购订单系统对您保留24小时的选择时效。" value:nil]];
        [_payDetailArray addObject:[GoodParaModel getModelWithTitle:@"5.如您在该采购订单保留的24小时时依然没有选择报价供应商，系统自动默认有效报价的最低报价供应商成为该采购订单的供应商。同时该采购订单发布结束，形成订单，在【我的订单】查看订单状态。" value:nil]];
    }
    return _payDetailArray;
}


+ (void)showGoodParameterViewInViewController:(UIViewController *)VC
                                 paraViewType:(ParaViewType)paraViewType
                                     withData:(NSMutableArray *)dataArray
                                 completetion:(GoodParameterBlock)Block{
    if (!goodParameterView) {
        goodParameterView = [[YBLGoodParameterView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                       inViewController:VC
                                                           paraViewType:paraViewType
                                                               withData:dataArray
                                                           completetion:Block];
    }
    [YBLMethodTools transformOpenView:goodParameterView.contentView SuperView:goodParameterView fromeVC:goodParameterView.VC Top:Top];
}

- (instancetype)initWithFrame:(CGRect)frame
             inViewController:(UIViewController *)VC
                 paraViewType:(ParaViewType)paraViewType
                     withData:(NSMutableArray *)dataArray
                 completetion:(GoodParameterBlock)Block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _VC = VC;
        _dataArray = dataArray;
        _goodParameterBlock = Block;
        _paraViewType = paraViewType;
        
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
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    self.topView = topView;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
    titleLabel.font = YBLFont(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = YBLColor(110, 110, 110, 1);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [topView addSubview:[YBLMethodTools addLineView:CGRectMake(0, topView.height-.5, topView.width, .5)]];
    

    if (_paraViewType == ParaViewTypePayShippingment) {
        self.titleLabel.text = @"配送方式以及支付方式";
        
        self.itemShippingView = [[YBLPurchaseShowIPayShipMentView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.contentView.width, self.contentView.height-self.topView.bottom)
                                                                          showMentType:ShowMentTypeAspfit
                                                                         textDataArray:_dataArray];
        
        self.itemShippingView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.itemShippingView];
        
    } else {
        
        [self.contentView addSubview:self.tableView];
    }


}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.contentView.width, self.contentView.height-self.topView.bottom) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (_paraViewType == ParaViewTypePara) {
            self.titleLabel.text = @"商品参数";
            [_tableView registerClass:NSClassFromString(@"YBLGoodParameterCell") forCellReuseIdentifier:@"YBLGoodParameterCell"];
            
        } else if (_paraViewType == ParaViewTypePayRule) {
            self.titleLabel.text = @"采购保证金规则";
            _dataArray = self.ruleDataArray;
            [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
        } else if (_paraViewType == ParaViewTypeEditPayRule) {
            self.titleLabel.text = @"采购方式说明";
            _dataArray = self.payDetailArray;
            [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
        }
    }
    return _tableView;
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.contentView SuperView:goodParameterView fromeVC:self.VC Top:YBLWindowHeight completion:^(BOOL finished) {
        [goodParameterView removeFromSuperview];
        goodParameterView = nil;
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_paraViewType == ParaViewTypePayRule||_paraViewType == ParaViewTypeEditPayRule) {
        GoodParaModel *model = _dataArray[indexPath.row];
        CGSize modelSize = [model.title heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-2*space];
        return modelSize.height+20;
    }
    return  40;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = nil;
    
    if (_paraViewType == ParaViewTypePara) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLGoodParameterCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
    
    } else if (_paraViewType == ParaViewTypePayShippingment) {
     
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLGoodPayShippingmentCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];

    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
     
        GoodParaModel *model = _dataArray[indexPath.row];
        
        cell.textLabel.textColor = YBLTextColor;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = YBLFont(14);
        cell.textLabel.text = model.title;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodParaModel *model = _dataArray[indexPath.row];
    
    if ([cell isKindOfClass:[YBLGoodParameterCell class]]) {
        YBLGoodParameterCell *para_cell = (YBLGoodParameterCell *)cell;
        [para_cell updateModel:model];
        
    } else if ([cell isKindOfClass:[YBLGoodPayShippingmentCell class]]) {
        YBLGoodPayShippingmentCell *payshipping_cell = (YBLGoodPayShippingmentCell *)cell;
        [payshipping_cell updateModel:model];
    }
}

@end
