//
//  YBLIWantDistributionViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLIWantDistributionViewController.h"
#import "YBLFurtureManageViewController.h"

@interface YBLDistributionCell : UITableViewCell

@property (nonatomic, strong) UIButton *iwantDitributionButton;

+ (CGFloat)getHI;

@end

@implementation YBLDistributionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLDistributionCell getHI];
    
    CGFloat imageWi = hei-2*space;
    
    UIImageView *storeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    storeIamgeView.image = [UIImage imageNamed:smallImagePlaceholder];
    storeIamgeView.layer.borderColor = YBLLineColor.CGColor;
    storeIamgeView.layer.borderWidth = 0.5;
    storeIamgeView.layer.cornerRadius = 3;
    storeIamgeView.layer.masksToBounds = YES;
    [self addSubview:storeIamgeView];
    
    CGFloat buttonWi = 80;
    CGFloat buttonHi = 25;
    
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeIamgeView.right+space/2, storeIamgeView.top, YBLWindowWidth-storeIamgeView.right-space*2-buttonWi, 20)];
    goodNameLabel.text = @"五粮液上品52度 500ml2瓶";
    goodNameLabel.font = YBLFont(14);
    goodNameLabel.textColor = BlackTextColor;
    [self addSubview:goodNameLabel];
    
    UILabel *lookLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLabel.left, goodNameLabel.bottom, goodNameLabel.width, 20)];
    lookLabel.text = @"浏览人数 : 19832人";
    lookLabel.textColor = YBLTextColor;
    lookLabel.font = YBLFont(12);
    [self addSubview:lookLabel];
    
    UILabel *distributionLabel = [[UILabel alloc] initWithFrame:CGRectMake(lookLabel.left, lookLabel.bottom, goodNameLabel.width, 20)];
    distributionLabel.text = @"分销人数 : 19832人";
    distributionLabel.textColor = YBLTextColor;
    distributionLabel.font = YBLFont(12);
    [self addSubview:distributionLabel];
    
    UIButton *iwantDitributionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iwantDitributionButton.frame = CGRectMake(goodNameLabel.right, 0, buttonWi, buttonHi);
    iwantDitributionButton.centerY = storeIamgeView.centerY;
    [iwantDitributionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iwantDitributionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [iwantDitributionButton setTitle:@"我要分销" forState:UIControlStateNormal];
    [iwantDitributionButton setTitle:@"分销成功" forState:UIControlStateDisabled];
    [iwantDitributionButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [iwantDitributionButton setBackgroundColor:YBLThemeColor forState:UIControlStateDisabled];
    iwantDitributionButton.titleLabel.font = YBLFont(13);
    iwantDitributionButton.layer.cornerRadius = buttonHi/2;
    iwantDitributionButton.layer.masksToBounds = YES;
    [self addSubview:iwantDitributionButton];
    self.iwantDitributionButton = iwantDitributionButton;
    
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHI{
    
    return 80;
}

@end

@interface YBLIWantDistributionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *distributionTableView;

@end

@implementation YBLIWantDistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我要分销";
    
    [self.view addSubview:self.distributionTableView];
    
    /*  */
    WEAK
    UIButton *moneyManageButton = [YBLMethodTools getFurtureMoneyButtonWithFrame:CGRectMake(YBLWindowWidth-space-60, YBLWindowHeight-space-95, 60, 95)];
    [[moneyManageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLFurtureManageViewController *furtureVC = [YBLFurtureManageViewController new];
        [self.navigationController pushViewController:furtureVC animated:YES];
    }];
    [self.view addSubview:moneyManageButton];
}

- (UITableView *)distributionTableView{
    
    if (!_distributionTableView) {
        _distributionTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _distributionTableView.rowHeight = [YBLDistributionCell getHI];
        [_distributionTableView registerClass:NSClassFromString(@"YBLDistributionCell") forCellReuseIdentifier:@"YBLDistributionCell"];
        _distributionTableView.backgroundColor = [UIColor whiteColor];
        _distributionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _distributionTableView.dataSource = self;
        _distributionTableView.delegate = self;
        _distributionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    }
    return _distributionTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLDistributionCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLDistributionCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[cell.iwantDitributionButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        [SVProgressHUD showSuccessWithStatus:@"分销成功"];
    }];
}


@end
