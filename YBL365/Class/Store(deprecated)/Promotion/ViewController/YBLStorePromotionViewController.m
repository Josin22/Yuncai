//
//  YBLStorePromotionViewController.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStorePromotionViewController.h"
#import "YBLStorePromotionUISrvice.h"

@interface YBLStorePromotionViewController ()
@property (nonatomic, strong) YBLStorePromotionUISrvice * storePromotionUISrvice;
@property (nonatomic, strong) UICollectionView * storePromotionCollection;

@end

@implementation YBLStorePromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUIService];
    
    [self addSubViews];
}

- (void)startUIService {
    self.storePromotionUISrvice = [[YBLStorePromotionUISrvice alloc]init];
    WEAK
    self.storePromotionUISrvice.scrollYBlock = ^(CGFloat alpha,
                                                 UIScrollView * scrollView) {
        STRONG
        if (self.scrollYBlock) {
            self.scrollYBlock(alpha,scrollView);
        }
    };
}

- (void)addSubViews {
    self.title = @"热销";

    [self.view addSubview:self.storePromotionCollection];
}

#pragma mark 懒加载
- (UICollectionView *)storePromotionCollection{
    if (!_storePromotionCollection) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _storePromotionCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.view.height) collectionViewLayout:myLayout];
        _storePromotionCollection.delegate = self.storePromotionUISrvice;
        _storePromotionCollection.dataSource = self.storePromotionUISrvice;
        _storePromotionCollection.backgroundColor = YBLColor(250, 250, 250, 1);
        [_storePromotionCollection registerClass:NSClassFromString(@"YBLStoreGoodsCell")forCellWithReuseIdentifier:@"YBLStoreGoodsCell"];        _storePromotionCollection.showsVerticalScrollIndicator = NO;
    }
    return _storePromotionCollection;
}


- (void)updateFeameWithY:(CGFloat)heightY {
    self.storePromotionCollection.frame = CGRectMake(0, 0, YBLWindowWidth, heightY);
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
