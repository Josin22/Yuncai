//
//  YBLFurtureMoneyViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFurtureMoneyViewController.h"
#import "YBLEditFurtureMoneyViewController.h"
#import "YBLFurtureManageViewController.h"

@interface YBLMoneyCallCell : UITableViewCell

@property (nonatomic, strong) UIButton *callButton;

+ (CGFloat)getHI;

@end

@implementation YBLMoneyCallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLMoneyCallCell getHI];
    
    CGFloat imageWi = hei-2*space;
    
    UIImageView *storeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    storeIamgeView.image = [UIImage imageNamed:smallImagePlaceholder];
    storeIamgeView.layer.borderColor = YBLLineColor.CGColor;
    storeIamgeView.layer.borderWidth = 0.5;
    storeIamgeView.layer.cornerRadius = 3;
    storeIamgeView.layer.masksToBounds = YES;
    [self addSubview:storeIamgeView];
    
    CGFloat buttonWi = 40;
    CGFloat buttonHi = 40;
    
    UILabel *manNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeIamgeView.right+space, storeIamgeView.top, YBLWindowWidth-storeIamgeView.right-space*3-buttonWi, 20)];
    manNameLabel.text = @"张三";
    manNameLabel.font = YBLFont(14);
    manNameLabel.textColor = BlackTextColor;
    [self addSubview:manNameLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(manNameLabel.left, manNameLabel.bottom, manNameLabel.width, 20)];
    statusLabel.text = @"未开店状态,未来收益200";
    statusLabel.textColor = YBLTextColor;
    statusLabel.font = YBLFont(12);
    [self addSubview:statusLabel];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.left, statusLabel.bottom, manNameLabel.width, 20)];
    categoryLabel.text = @"中外名酒 白酒";
    categoryLabel.textColor = YBLTextColor;
    categoryLabel.font = YBLFont(12);
    [self addSubview:categoryLabel];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake(manNameLabel.right, 0, buttonWi, buttonHi);
    callButton.centerY = storeIamgeView.centerY;
    [callButton setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
    [self addSubview:callButton];
    self.callButton = callButton;
    
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHI{
    
    return 80;
}

@end

@interface YBLFurtureMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *moneyTableView;

@end

@implementation YBLFurtureMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"未来收益";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_icon"]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(addClickMethod:)];
    
    item.tintColor = YBLThemeColor;
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.moneyTableView];
    
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

- (void)addClickMethod:(UIBarButtonItem *)item{
    
    YBLEditFurtureMoneyViewController *editVC = [[YBLEditFurtureMoneyViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (UITableView *)moneyTableView{
    
    if (!_moneyTableView) {
        _moneyTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _moneyTableView.rowHeight = [YBLMoneyCallCell getHI];
        [_moneyTableView registerClass:NSClassFromString(@"YBLMoneyCallCell") forCellReuseIdentifier:@"YBLMoneyCallCell"];
        _moneyTableView.backgroundColor = [UIColor whiteColor];
        _moneyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _moneyTableView.dataSource = self;
        _moneyTableView.delegate = self;
        _moneyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    }
    return _moneyTableView;
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
    YBLMoneyCallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMoneyCallCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLMoneyCallCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[cell.callButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        [YBLMethodTools callWithNumber:Service_PhoneCall];
    }];
}

@end
