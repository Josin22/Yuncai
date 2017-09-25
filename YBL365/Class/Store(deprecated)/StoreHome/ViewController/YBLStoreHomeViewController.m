//
//  YBLStoreHomeViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreHomeViewController.h"
#import "YBLStoreHomeUIService.h"

@interface YBLStoreHomeViewController ()
@property (nonatomic, strong) YBLStoreHomeUIService * storeHomeUIService;
@property (nonatomic, strong) UICollectionView * storeHomeCollection;
@end

@implementation YBLStoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)startUIService {
    self.storeHomeUIService = [[YBLStoreHomeUIService alloc]init];
}

- (void)addSubViews {
    [self.view addSubview:self.storeHomeCollection];
    
}

- (UICollectionView *)storeHomeCollection {
    if (!_storeHomeUIService) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _storeHomeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.view.height-50) collectionViewLayout:myLayout];
        _storeHomeCollection.delegate = self.storeHomeUIService;
        _storeHomeCollection.dataSource = self.storeHomeUIService;
        _storeHomeCollection.backgroundColor = [UIColor whiteColor];
        [_storeHomeCollection registerClass:NSClassFromString(@"YBLStoreGoodsCell")forCellWithReuseIdentifier:@"YBLStoreGoodsCell"];
        [_storeHomeCollection registerClass:NSClassFromString(@"YBLHomeBannerCell") forCellWithReuseIdentifier:@"YBLHomeBannerCell"];
        _storeHomeCollection.showsVerticalScrollIndicator = NO;
    }
    return _storeHomeCollection;
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
