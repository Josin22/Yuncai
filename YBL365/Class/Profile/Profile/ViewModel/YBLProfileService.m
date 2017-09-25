//
//  YBLProfileService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProfileService.h"
#import "YBLProfileViewController.h"
#import "YBLProfileNavigationView.h"
#import "YBLProfileViewModel.h"
#import "YBLLoginViewModel.h"
#import "YBLProfileHeadView.h"
#import "YBLLoginViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLOrderViewController.h"
#import "YBLAccountManageViewController.h"
#import "YBLProdfileSettingViewController.h"
#import "YBLBadgeLabel.h"
#import "KSPhotoBrowser.h"

@interface YBLProfileRowItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *nummberLabel;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, retain) YBLBadgeLabel *badgeLabel;

- (void)updateProfileItemModel:(YBLProfileItemModel *)model;

@end

@implementation YBLProfileRowItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = [self bounds];
    [self.contentView addSubview:self.selectButton];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.iconImageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-12);
    }];
    
    self.badgeLabel = [[YBLBadgeLabel alloc] initWithFrame:CGRectZero];
    self.badgeLabel.center = CGPointMake(self.width/2+10, self.height/2-30);
    [self.contentView addSubview:self.badgeLabel];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = YBLFont(16);
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    self.nummberLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY).with.offset(-12);
    }];

    UILabel *label1 = [[UILabel alloc] init];
    label1.font = YBLFont(11);
    label1.textColor = YBLColor(40, 40, 40, 1.0);
    label1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label1];
    self.titleLabel = label1;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY).with.offset(12);
    }];
    
}

- (void)updateProfileItemModel:(YBLProfileItemModel *)model{
    
    if ([model.profile_item_image_or_value isKindOfClass:[NSString class]]) {
        self.iconImageView.hidden = NO;
        self.nummberLabel.hidden = YES;
        self.iconImageView.image = [UIImage imageNamed:model.profile_item_image_or_value];
    } else if ([model.profile_item_image_or_value isKindOfClass:[NSNumber class]]) {
        self.iconImageView.hidden = YES;
        self.nummberLabel.hidden = NO;
        self.nummberLabel.text = [NSString stringWithFormat:@"%@",model.profile_item_image_or_value];
    }
    self.titleLabel.text = model.profile_item_text;
    if (model.profile_orderBadgeValue&&model.profile_orderBadgeValue.integerValue!=0) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.bageValue = model.profile_orderBadgeValue.integerValue;
    } else {
        self.badgeLabel.hidden = YES;
    }
}

@end


@interface YBLProfileService ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak  ) YBLProfileViewController *VC;

@property (nonatomic, weak  ) YBLProfileViewModel      *viewModel;

@property (nonatomic, strong) UICollectionView         *profileCollectionView;

@end

@implementation YBLProfileService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _VC = (YBLProfileViewController *)VC;
        _viewModel = (YBLProfileViewModel *)viewModel;
        
        WEAK
        [RACObserve([YBLUserManageCenter shareInstance], userModel) subscribeNext:^(id x) {
            STRONG
            [self reloadCollectionViewNoAnimation];
        }];
    }
    return self;
}

- (void)requestUserInfoData{
    
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        WEAK
        //判断是否有userionfos_id
        if ([YBLUserManageCenter shareInstance].userModel.userinfo_id.length==0) {
            //查询userionfos_id
            [[YBLLoginViewModel siganlForGetUserInfoIds]subscribeError:^(NSError * _Nullable error) {
            } completed:^{
                STRONG
                [self requestUserInfoModel];    
            }];
        } else {
            [self requestUserInfoModel];
        }
    } else {
        
        [self reloadCollectionViewNoAnimation];
    }
}

- (void)reloadCollectionViewNoAnimation{

    [UIView performWithoutAnimation:^{
        [self.profileCollectionView jsReloadData];
    }];
}

- (void)requestUserInfoModel{
    WEAK
    [[YBLLoginViewModel siganlForGetUserInfos] subscribeError:^(NSError * _Nullable error) {
    } completed:^{
        STRONG
        [self reloadCollectionViewNoAnimation];
    }];
}

- (UICollectionView *)profileCollectionView{
    
    if (!_profileCollectionView) {
        CGFloat collectionWi = _VC.view.width/4;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = CGSizeMake(collectionWi, 75);
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        _profileCollectionView = [[UICollectionView alloc] initWithFrame:[_VC.view bounds] collectionViewLayout:flowlayout];
        _profileCollectionView.dataSource = self;
        _profileCollectionView.delegate = self;
        _profileCollectionView.alwaysBounceVertical = YES;
        _profileCollectionView.showsVerticalScrollIndicator = NO;
        _profileCollectionView.showsHorizontalScrollIndicator = NO;
        _profileCollectionView.height = YBLWindowHeight - kBottomBarHeight;
        _profileCollectionView.backgroundColor = [UIColor whiteColor];
        [_profileCollectionView registerClass:NSClassFromString(@"YBLProfileRowItemCell") forCellWithReuseIdentifier:@"YBLProfileRowItemCell"];
        [_profileCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        [_profileCollectionView registerClass:[YBLProfileWaveHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLProfileWaveHeaderView"];
        [_VC.view addSubview:_profileCollectionView];
    }
    return _profileCollectionView;
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewModel.profile_cell_data_array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.viewModel.profile_cell_data_array[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    YBLProfileRowItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLProfileRowItemCell"
                                                                            forIndexPath:indexPath];
    YBLProfileItemModel *model = self.viewModel.profile_cell_data_array[section][row];
    [cell updateProfileItemModel:model];
    WEAK
    [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [self.viewModel pushVCWithItemModel:model WithNavigationVC:self.VC];
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section==0) {
            YBLProfileWaveHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                       withReuseIdentifier:@"YBLProfileWaveHeaderView"
                                                                                              forIndexPath:indexPath];
            WEAK
            [headerView reloadHeaderData];
            
            [[[headerView.setButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                STRONG
                YBLProdfileSettingViewController *settingVC = [YBLProdfileSettingViewController new];
                [self.VC.navigationController pushViewController:settingVC animated:YES];
            }];
            [[[headerView.bgButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                STRONG
                if (![YBLMethodTools checkLoginWithVc:self.VC]) {
                    return ;
                }
                YBLAccountManageViewController *accountVC = [YBLAccountManageViewController new];
                [self.VC.navigationController pushViewController:accountVC animated:YES];
            }];
            [[[headerView.userTap rac_gestureSignal] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                STRONG
                NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
                if (![YBLMethodTools checkLoginWithVc:self.VC]) {
                    return ;
                }
                if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
                    KSPhotoItem *items = [[KSPhotoItem alloc] initWithSourceView:headerView.userImageView imageUrl:[NSURL URLWithString:useIconUrl]];
                    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[items] selectedIndex:0];
                    //                                                  browser.delegate = self;
                    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
                    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
                    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
                    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
                    browser.bounces = NO;
                    [browser showFromViewController:self.VC];

                }
            }];
            
            self.waveHeaderView = headerView;
            
            return headerView;
        } else {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                      withReuseIdentifier:@"UICollectionReusableView"
                                                                                             forIndexPath:indexPath];
            headerView.backgroundColor = YBLViewBGColor;
            return headerView;
        }
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(YBLWindowWidth, (YBLWindowHeight-kNavigationbarHeight)/3);
    }
    return CGSizeMake(YBLWindowWidth, space);
}

@end
