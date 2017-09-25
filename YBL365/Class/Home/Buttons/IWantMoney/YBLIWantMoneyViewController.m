//
//  YBLIWantMoneyViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLIWantMoneyViewController.h"
#import "YBLShareView.h"
#import "YBLFurtureManageViewController.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLIwantMoneyCell : UITableViewCell

@property (nonatomic, strong) UIButton *shareButton;

+ (CGFloat)getHI;

@end

@implementation YBLIwantMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLIwantMoneyCell getHI];
    
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
    lookLabel.text = @"好友浏览 : 0.1/人";
    lookLabel.textColor = YBLTextColor;
    lookLabel.font = YBLFont(12);
    [self addSubview:lookLabel];
    
    UILabel *distributionLabel = [[UILabel alloc] initWithFrame:CGRectMake(lookLabel.left, lookLabel.bottom, goodNameLabel.width, 20)];
    distributionLabel.text = @"浏览人数 : 19832人";
    distributionLabel.textColor = YBLTextColor;
    distributionLabel.font = YBLFont(12);
    [self addSubview:distributionLabel];
    
    UIButton *iwantDitributionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iwantDitributionButton.frame = CGRectMake(goodNameLabel.right, 0, buttonWi, buttonHi);
    iwantDitributionButton.centerY = storeIamgeView.centerY;
    [iwantDitributionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iwantDitributionButton setTitle:@"立即分享" forState:UIControlStateNormal];
    [iwantDitributionButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    iwantDitributionButton.titleLabel.font = YBLFont(13);
    iwantDitributionButton.layer.cornerRadius = buttonHi/2;
    iwantDitributionButton.layer.masksToBounds = YES;
    [self addSubview:iwantDitributionButton];
    self.shareButton = iwantDitributionButton;
    
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHI{
    
    return 80;
}

@end

@interface YBLIWantMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *moneyTableView;

@end

@implementation YBLIWantMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要赚钱";
    
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

- (UITableView *)moneyTableView{
    
    if (!_moneyTableView) {
        _moneyTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _moneyTableView.rowHeight = [YBLIwantMoneyCell getHI];
        [_moneyTableView registerClass:NSClassFromString(@"YBLIwantMoneyCell") forCellReuseIdentifier:@"YBLIwantMoneyCell"];
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
    YBLIwantMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLIwantMoneyCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLIwantMoneyCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[cell.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        
        [YBLShareView shareViewWithPublishContentText:@"我的店铺有一个不错的商品,赶快来采购吧"
                                               title:@"飞天茅台 52度 特供 500ml 精品"
                                            imagePath:smallImagePlaceholder
                                                 url:@"http://lw.mayicms.net/app/index/jingdongp"
                                              Result:^(ShareType type, BOOL isSuccess) {
                                                  
                                              }
                             ShareADGoodsClickHandle:^(){
                                 YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] init];
                                 [self.navigationController pushViewController:goodsDetailVC animated:YES];
                             }];
    }];
}

@end
