//
//  YBLStoreGoodsViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreGoodsViewController.h"
#import "YBLStoreGoodsUIService.h"
#import "YBLStoreGoodsHeaderView.h"
#import "YBLGoodsClassifyViewController.h"

@interface YBLStoreGoodsViewController ()
@property (nonatomic, strong) YBLStoreGoodsUIService * storeGoodsUIService;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) YBLStoreGoodsHeaderView * storeGoodsHeaderView;
@end

@implementation YBLStoreGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
    // Do any additional setup after loading the view.
}

- (YBLStoreGoodsHeaderView *)storeGoodsHeaderView {
    if (!_storeGoodsHeaderView) {
        _storeGoodsHeaderView = [[YBLStoreGoodsHeaderView alloc]initWithFrame:CGRectMake(0, 64, YBLWindowWidth, 40)];
    }
    return _storeGoodsHeaderView;
}

- (void)startUIService {
    self.storeGoodsUIService = [[YBLStoreGoodsUIService alloc]init];
    WEAK
    self.storeGoodsUIService.scrollYBlock = ^(CGFloat alpha,
                                              UIScrollView * scrollView) {
        STRONG
        if (self.scrollYBlock) {
            self.scrollYBlock(alpha,scrollView);
        }
    };

}

- (void)addSubViews {
    self.title = @"全部商品";
    
    UIButton * categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(YBLWindowWidth - 44 - 5, 20, 40, 44);
    [categoryBtn setTitle:@"分类" forState:UIControlStateNormal];
    [categoryBtn setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [categoryBtn setImage:[UIImage newImageWithNamed:@"store_classify" size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = YBLFont(11);
    [categoryBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 13, 0, 0)];
    [categoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * categoryBarBtn = [[UIBarButtonItem alloc]initWithCustomView:categoryBtn];
    self.navigationItem.rightBarButtonItem = categoryBarBtn;
    [self.view addSubview:self.goodsCollectionView];
    WEAK
    self.storeGoodsHeaderView.classifyButtonBlock = ^(NSInteger selectIndex,
                                                      BOOL isChangeList) {
        STRONG
        NSLog(@"-%ld--",selectIndex);
        if (selectIndex == 4) {
            self.storeGoodsUIService.isChangeList = isChangeList;
            [self.goodsCollectionView reloadData];
        }
    };
}

#pragma mark 懒加载
- (UICollectionView *)goodsCollectionView{
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _goodsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.view.height) collectionViewLayout:myLayout];
        _goodsCollectionView.delegate = self.storeGoodsUIService;
        _goodsCollectionView.dataSource = self.storeGoodsUIService;
        _goodsCollectionView.backgroundColor = VIEW_BASE_COLOR;
        [_goodsCollectionView registerClass:NSClassFromString(@"YBLStoreGoodsCell")forCellWithReuseIdentifier:@"YBLStoreGoodsCell"];
        [_goodsCollectionView registerClass:NSClassFromString(@"YBLStoreGoodsListCell")forCellWithReuseIdentifier:@"YBLStoreGoodsListCell"];
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _goodsCollectionView;
}

- (void)setIsShowSelect:(BOOL)isShowSelect {
    _isShowSelect = isShowSelect;
    if (_isShowSelect) {
        [self.view addSubview:self.storeGoodsHeaderView];
        self.goodsCollectionView.frame = CGRectMake(0, 40, self.view.width, self.view.height -40);
    }
}

- (void)setIsChangeList:(BOOL)isChangeList {
    _isChangeList = isChangeList;
    
    self.storeGoodsUIService.isChangeList = isChangeList;
    [self.goodsCollectionView reloadData];
}

- (void)updateFeameWithY:(CGFloat)heightY {
    self.goodsCollectionView.frame = CGRectMake(0, 0, YBLWindowWidth, heightY);
}

#pragma mark - 分类
- (void)categoryBtnClick {
    //    分类
    YBLGoodsClassifyViewController * goodsClassifyVC = [[YBLGoodsClassifyViewController alloc]init];
    [self.navigationController pushViewController:goodsClassifyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
