//
//  YBLManyPayWayService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManyPayWayService.h"
#import "YBLManyPayWayViewController.h"
#import "YBLManyPayWayViewModel.h"
#import "YBLOrderViewController.h"

@interface YBLManyPayWayItemCell : UITableViewCell

@property (nonatomic, retain) UILabel *textValueLabel;

@property (nonatomic, strong) YBLButton *stateButton;

+ (CGFloat)gethi;

@end

@implementation YBLManyPayWayItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLManyPayWayItemCell gethi];
    
    self.textValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth*2/3, hi)];
    self.textValueLabel.textColor = BlackTextColor;
    self.textValueLabel.font = YBLFont(15);
    [self.contentView addSubview:self.textValueLabel];
   
    self.stateButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    [self.stateButton setImage:[UIImage imageNamed:@"order_success_icon"] forState:UIControlStateNormal];
    [self.stateButton setImage:[UIImage imageNamed:@"order_warning_icon"] forState:UIControlStateSelected];
    [self.stateButton setTitle:@"提单成功" forState:UIControlStateNormal];
    [self.stateButton setTitle:@"未支付" forState:UIControlStateSelected];
    [self.stateButton setTitleColor:YBLColor(26, 250, 41, 1) forState:UIControlStateNormal];
    [self.stateButton setTitleColor:YBLColor(216, 30, 6, 1) forState:UIControlStateSelected];
    [self.contentView addSubview:self.stateButton];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, .5)]];
    
}

+ (CGFloat)gethi{
    
    return 50;
}

@end

@interface YBLManyPayWayService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)   YBLManyPayWayViewController *Vc;

@property (nonatomic, strong) YBLManyPayWayViewModel *viewModel;

@property (nonatomic, strong) UITableView *manyPayWayTableView;

@end

@implementation YBLManyPayWayService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _Vc = (YBLManyPayWayViewController *)VC;
        _viewModel = (YBLManyPayWayViewModel *)viewModel;
        
        self.Vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"订单中心"
                                                                                     style:UIBarButtonItemStyleDone
                                                                                    target:self
                                                                                    action:@selector(goOrderCenter)];
        
        [_Vc.view addSubview:self.manyPayWayTableView];
        
        /*pay*/
        
        UILabel *payTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.viewModel.paymentArray.count+1)*45, YBLWindowWidth, 45)];
        payTitleLabel.textAlignment = NSTextAlignmentCenter;
        payTitleLabel.textColor = YBLTextColor;
        payTitleLabel.font = YBLFont(14);
        payTitleLabel.text = @"部分商品需要在线支付,请尽快支付!";
        [self.manyPayWayTableView addSubview:payTitleLabel];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(2*space, payTitleLabel.bottom, YBLWindowWidth-4*space, payTitleLabel.height);
        [payButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
        payButton.layer.cornerRadius = payTitleLabel.height/2;
        payButton.layer.masksToBounds = YES;
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.titleLabel.font = YBLFont(16);
        [self.manyPayWayTableView addSubview:payButton];
        [[payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        }];
    }
    return self;
}

- (void)goOrderCenter{
    
    YBLOrderViewModel *viewModel = [YBLOrderViewModel new];
    viewModel.pushInVCType = PushInVCTypeOtherWay;
    YBLOrderViewController *orderVC = [YBLOrderViewController new];
    orderVC.viewModel = viewModel;
    [self.Vc.navigationController pushViewController:orderVC animated:YES];
}

- (UITableView *)manyPayWayTableView{
    
    if (!_manyPayWayTableView) {
        _manyPayWayTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        _manyPayWayTableView.dataSource = self;
        _manyPayWayTableView.delegate = self;
        _manyPayWayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _manyPayWayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        _manyPayWayTableView.showsVerticalScrollIndicator = NO;
        [_manyPayWayTableView registerClass:NSClassFromString(@"YBLManyPayWayItemCell") forCellReuseIdentifier:@"YBLManyPayWayItemCell"];
    }
    return _manyPayWayTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.paymentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLManyPayWayItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLManyPayWayItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLManyPayWayItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLTakeOrderPaymentModel *model = self.viewModel.paymentArray[indexPath.row];
    cell.textValueLabel.text = [NSString stringWithFormat:@"%@ :¥%.2f",model.payment_method.name,model.amount.doubleValue];
    if ([model.payment_method.type isEqualToString:onlineString]||[model.payment_method.type isEqualToString:expressString]) {
        cell.stateButton.selected = YES;
    } else {
        cell.stateButton.selected = NO;
    }
}

@end
