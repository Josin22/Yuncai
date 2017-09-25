//
//  YBLStoreBankeViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreBankeViewController.h"
#import "YBLFurtureManageViewController.h"

@interface YBLStoreBankeCell : UITableViewCell

+ (CGFloat)getHI;

@end

@implementation YBLStoreBankeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLStoreBankeCell getHI];
    
    CGFloat imageWi = (YBLWindowWidth-space*4)/3;
    
    UIImageView *storeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space, 0, imageWi, 40)];
    storeIamgeView.centerY = hei/2;
    storeIamgeView.layer.borderColor = YBLLineColor.CGColor;
    storeIamgeView.layer.borderWidth = 0.5;
    storeIamgeView.image = [UIImage imageNamed:@"jiuyangstore"];
    [self addSubview:storeIamgeView];
    
    CGFloat buttonWi = 50;
    CGFloat buttonHi = 25;
    
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(storeIamgeView.right+space, space, YBLWindowWidth-storeIamgeView.right-space*2-buttonWi, 20)];
    storeName.text = @"九阳厨房电器旗舰店";
    storeName.font = YBLFont(14);
    storeName.textColor = BlackTextColor;
    [self addSubview:storeName];
    
    UILabel *foucsLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeName.left, storeName.bottom, storeName.width, 15)];
    foucsLabel.text = @"19832人关注";
    foucsLabel.textColor = YBLTextColor;
    foucsLabel.font = YBLFont(12);
    [self addSubview:foucsLabel];
    
    YBLButton *jinBiButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    jinBiButton.frame = CGRectMake(foucsLabel.left, foucsLabel.bottom, foucsLabel.width, foucsLabel.height);
    [jinBiButton setTitle:@"0.5个云币" forState:UIControlStateNormal];
    [jinBiButton setTitleColor:YBLColor(253, 222, 68, 1) forState:UIControlStateNormal];
    [jinBiButton setImage:[UIImage imageNamed:@"jinbi_icon"] forState:UIControlStateNormal];
    [jinBiButton setImageRect:CGRectMake(0, 0, 15, 15)];
    [jinBiButton setTitleRect:CGRectMake(15+3, 0, foucsLabel.width-foucsLabel.height/2, foucsLabel.height)];
    jinBiButton.titleLabel.font = YBLFont(11);
    [self addSubview:jinBiButton];
    
    UIButton *foucsStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foucsStoreButton.frame = CGRectMake(storeName.right, 0, buttonWi, buttonHi);
    foucsStoreButton.centerY = storeIamgeView.centerY;
    [foucsStoreButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [foucsStoreButton setTitleColor:YBLThemeColor forState:UIControlStateDisabled];
    [foucsStoreButton setTitle:@"关注" forState:UIControlStateNormal];
    [foucsStoreButton setTitle:@"关注成功" forState:UIControlStateDisabled];
    foucsStoreButton.titleLabel.font = YBLFont(13);
    foucsStoreButton.layer.cornerRadius = 3;
    foucsStoreButton.layer.masksToBounds = YES;
    foucsStoreButton.layer.borderColor = YBLThemeColor.CGColor;
    foucsStoreButton.layer.borderWidth = 0.5;
    [self addSubview:foucsStoreButton];
 
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHI{
    
    return 70;
}

@end


@interface YBLStoreBankeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *storeBankeTableView;

@end

@implementation YBLStoreBankeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"店铺排行";
    
    [self.view addSubview:self.storeBankeTableView];
    
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

- (UITableView *)storeBankeTableView{
    
    if (!_storeBankeTableView) {
        _storeBankeTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _storeBankeTableView.rowHeight = [YBLStoreBankeCell getHI];
        [_storeBankeTableView registerClass:NSClassFromString(@"YBLStoreBankeCell") forCellReuseIdentifier:@"YBLStoreBankeCell"];
        _storeBankeTableView.backgroundColor = [UIColor whiteColor];
        _storeBankeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _storeBankeTableView.dataSource = self;
        _storeBankeTableView.delegate = self;
        _storeBankeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    }
    return _storeBankeTableView;
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
    YBLStoreBankeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreBankeCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLStoreBankeCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
