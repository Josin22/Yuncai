//
//  YBLStoreSettingFollowRewardVC.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreSettingFollowRewardVC.h"
#import "YBLStoreAuthenViewModel.h"
#import "YBLButtonsCollectionView.h"
#import "YBLStoreFollowSettingViewModel.h"
#import "YBLCompanyTypesItemModel.h"
#import "YBLStoreBalanceViewController.h"

@interface YBLStoreSettingFollowRewardVC ()
{
    float storeMoney;
    float walletsMoney;
    float quotaMoney;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *companyTypesDataArray;

@property (nonatomic, strong) YBLButtonsCollectionView *companyCollectionView;

@property (nonatomic, retain) UILabel *storeTypeInfoLabel;

@property (nonatomic, retain) UILabel *topInfoLabel;

@property (nonatomic, strong) XXTextField *moenyTextField;

@end

@implementation YBLStoreSettingFollowRewardVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"店铺收藏奖励";
    
    [self createUI];

}

- (void)createUI {

    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.backgroundColor = YBLColor(245, 245, 245, 1);
    [self.view addSubview:self.contentScrollView];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:topView];
    
    UILabel *topInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space, topView.width, 30)];
    topInfoLabel.textAlignment = NSTextAlignmentCenter;
    topInfoLabel.centerY = topView.height/2;
    topInfoLabel.textColor = YBLTextColor;
    topInfoLabel.font = YBLFont(16);
    [topView addSubview:topInfoLabel];
    self.topInfoLabel = topInfoLabel;
    
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageButton.frame = CGRectMake(0, 0, 60, 30);
    [manageButton setTitle:@"管理 »»" forState:UIControlStateNormal];
    [manageButton setTitleColor:YBLTextLightColor forState:UIControlStateNormal];
    manageButton.titleLabel.font = YBLFont(12);
    manageButton.bottom = topView.height;
    manageButton.right = topView.width;
    [topView addSubview:manageButton];
    WEAK
    [[manageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLStoreBalanceViewController *storeBalanceVc = [YBLStoreBalanceViewController new];
        storeBalanceVc.quotaMoeny = quotaMoney;
        storeBalanceVc.walletsMoeny = walletsMoney;
        [self.navigationController pushViewController:storeBalanceVc animated:YES];
    }];
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, topView.width, 50)];
    itemView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:itemView];
    
    UILabel *moneyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 100, itemView.height)];
    moneyInfoLabel.textColor = BlackTextColor;
    moneyInfoLabel.font = YBLFont(14);
    moneyInfoLabel.text = @"收藏店铺奖励 :";
    [itemView addSubview:moneyInfoLabel];
    
    XXTextField *moenyTextField = [[XXTextField alloc] initWithFrame:CGRectMake(moneyInfoLabel.right, 0, itemView.width-moneyInfoLabel.right-60, itemView.height)];
    moenyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    moenyTextField.placeholder = @"请输入奖励金币数";
    moenyTextField.font = YBLFont(14);
    moenyTextField.textColor = BlackTextColor;
    [itemView addSubview:moenyTextField];
    self.moenyTextField = moenyTextField;
    
    UILabel *yunbiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, itemView.height)];
    yunbiLabel.right = itemView.width-space;
    yunbiLabel.textAlignment = NSTextAlignmentRight;
    yunbiLabel.textColor = YBLThemeColor;
    yunbiLabel.font = YBLFont(14);
    yunbiLabel.text = @"云币";
    [itemView addSubview:yunbiLabel];
    
    [itemView addSubview:[YBLMethodTools addLineView:CGRectMake(0, itemView.height-.5, itemView.width, .5)]];
    
    UILabel *storeTypeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, itemView.bottom+space, itemView.width, 30)];
    storeTypeInfoLabel.textColor = YBLTextLightColor;
    storeTypeInfoLabel.font = YBLFont(14);
    storeTypeInfoLabel.text = @"请选择收藏店铺对象";
    [self.contentScrollView addSubview:storeTypeInfoLabel];
    self.storeTypeInfoLabel = storeTypeInfoLabel;
    
    UIButton *saveButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
    saveButton.bottom = YBLWindowHeight-kNavigationbarHeight;
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (self.moenyTextField.text.doubleValue<1) {
            [SVProgressHUD showInfoWithStatus:@"店铺收藏奖励最小起始1云币哟~"];
            return ;
        }
        if (self.moenyTextField.text.doubleValue>100) {
            [SVProgressHUD showInfoWithStatus:@"店铺收藏奖励不能超过100云币哟~"];
            return ;
        }
        NSMutableArray *ids = @[].mutableCopy;
        for (YBLCompanyTypesItemModel *itemModel in self.companyTypesDataArray) {
            if (itemModel.isSelect&&itemModel._id) {
                [ids addObject:itemModel._id];
            }
        }
//        if (ids.count==0) {
//            [SVProgressHUD showInfoWithStatus:@"您还没有选择店铺类型哟~"];
//            return ;
//        }
        NSString *new_ids = [YBLMethodTools getAppendingStringWithArray:ids appendingKey:@","];
        [[YBLStoreFollowSettingViewModel signalForSettingFollowOptionsWithMoney:self.moenyTextField.text.doubleValue types:new_ids] subscribeNext:^(id  _Nullable x) {
            STRONG
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError * _Nullable error) {
            
        }];
    }];
}

- (YBLButtonsCollectionView *)companyCollectionView{
    if (!_companyCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        CGFloat itemWi = (YBLWindowWidth-space*6)/3;
        layout.itemSize = CGSizeMake(itemWi, itemWi/2);
        _companyCollectionView = [[YBLButtonsCollectionView alloc] initWithFrame:CGRectMake(0, self.storeTypeInfoLabel.bottom, YBLWindowWidth, YBLWindowHeight)
                                                            collectionViewLayout:layout
                                                                     chooseStyle:ButtonsChooseStyleMultiSelect
                                                                    hasAllSelect:ButtonsHasAllSelectYES];
        [self.contentScrollView addSubview:_companyCollectionView];
    }
    return _companyCollectionView;
}

- (void)requestData {
    WEAK
    [[YBLStoreAuthenViewModel signalForCompanyTypesWith:@"0"] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.companyTypesDataArray = x;
        self.companyCollectionView.dataArray = self.companyTypesDataArray;
        [self.companyCollectionView jsReloadData];
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.companyCollectionView.bottom);
        //回现
        [[YBLStoreFollowSettingViewModel siganlForFollowOptions] subscribeNext:^(id  _Nullable x) {
            STRONG
            walletsMoney = [x[@"gold"] doubleValue];
            quotaMoney = [x[@"follow_quota"] doubleValue];
            storeMoney = [x[@"follow_shop_money"] doubleValue];
            NSString *storeQuotaString = [NSString stringWithFormat:@"%.1f",quotaMoney];
            NSString *storeMoneyString = [NSString stringWithFormat:@"%.1f",storeMoney];
            NSString *fi_string = [NSString stringWithFormat:@"您有%@店铺关注专项云币",storeQuotaString];
            NSMutableAttributedString *mutiString = [[NSMutableAttributedString alloc] initWithString:fi_string];
            NSRange money_range = [fi_string rangeOfString:storeQuotaString];
            [mutiString addAttributes:@{NSForegroundColorAttributeName:YBLThemeColor,
                                        NSFontAttributeName:YBLFont(25)} range:money_range];
            self.topInfoLabel.attributedText = mutiString;
            self.moenyTextField.text = storeMoneyString;
            //
            NSMutableArray *indexps = [NSMutableArray array];
            for (NSArray *itemArray in x[@"follow_company_types"]) {
                NSString *item_id = itemArray[0];
                [self.companyTypesDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YBLCompanyTypesItemModel *model = (YBLCompanyTypesItemModel *)obj;
                    if ([model._id isEqualToString:item_id]) {
                        model.isSelect = YES;
                        NSIndexPath *indexp = [NSIndexPath indexPathForRow:idx inSection:0];
                        [indexps addObject:indexp];
                        *stop = YES;
                    }
                }];
            }
            [self.companyCollectionView reloadItemsAtIndexPaths:indexps];
        } error:^(NSError * _Nullable error) {
            
        }];
    } error:^(NSError * _Nullable error) {
        
    }];
}


@end
