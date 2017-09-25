//
//  YBLStoreNewViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreNewViewController.h"
#import "YBLStoreNewUIService.h"

@interface YBLStoreNewViewController ()
@property (nonatomic, strong) YBLStoreNewUIService * storeNewUIService;
@property (nonatomic, strong) UICollectionView * storeNewCollection;
@end

@implementation YBLStoreNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
}

- (void)startUIService {
    self.storeNewUIService = [[YBLStoreNewUIService alloc]init];
    WEAK
    self.storeNewUIService.scrollYBlock = ^(CGFloat alpha,
                                            UIScrollView * scrollView) {
        STRONG
        if (self.scrollYBlock) {
            self.scrollYBlock(alpha,scrollView);
        }
    };
}

- (void)addSubViews {
    self.title = @"上新";

    [self.view addSubview:self.storeNewCollection];
    
}

#pragma mark 懒加载
- (UICollectionView *)storeNewCollection{
    if (!_storeNewCollection) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _storeNewCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.view.height) collectionViewLayout:myLayout];
        _storeNewCollection.delegate = self.storeNewUIService;
        _storeNewCollection.dataSource = self.storeNewUIService;
        _storeNewCollection.backgroundColor = YBLColor(250, 250, 250, 1);
        [_storeNewCollection registerClass:NSClassFromString(@"YBLStoreGoodsCell")forCellWithReuseIdentifier:@"YBLStoreGoodsCell"];
        _storeNewCollection.showsVerticalScrollIndicator = NO;
        [_storeNewCollection registerClass:NSClassFromString(@"YBLStoreNewCollectionHeader") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLStoreNewCollectionHeader"];
    }
    return _storeNewCollection;
}

- (void)updateFeameWithY:(CGFloat)heightY {
    self.storeNewCollection.frame = CGRectMake(0, 0, YBLWindowWidth, heightY);
}
@end
