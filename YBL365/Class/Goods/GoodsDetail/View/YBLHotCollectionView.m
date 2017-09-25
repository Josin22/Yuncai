//
//  YBLHotCollectionView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLHotCollectionView.h"

@interface YBLHotListGoodCell : UICollectionViewCell

@end

@implementation YBLHotListGoodCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHotListGoodUI];
    }
    return self;
}

- (void)createHotListGoodUI{
    
    CGFloat wi = self.width;
//    CGFloat leftSpace = (self.height-wi)/2;
    
    //    self.backView = [[UIView alloc] initWithFrame:[self bounds]];
    //    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //    [self addSubview:self.backView];
    //    self.backView.hidden = YES;
    
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, wi-20, wi-10)];
    goodsImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    goodsImageView.layer.borderColor = YBLColor(240, 240, 240, 1).CGColor;
    goodsImageView.layer.borderWidth = 0.5;
    goodsImageView.layer.cornerRadius = 3;
    goodsImageView.layer.masksToBounds = YES;
    goodsImageView.centerX = self.width/2;
    [self addSubview:goodsImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.left+5, CGRectGetMaxY(goodsImageView.frame), goodsImageView.width-10, 30)];
    nameLabel.text = @"洋河经典 52度500ml 精品特供";
    nameLabel.numberOfLines = 2;
    nameLabel.font = YBLFont(12);
    nameLabel.centerX = self.width/2;
    nameLabel.textColor = YBLColor(40, 40, 40, 1);;
    [self addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), goodsImageView.width, 15)];
    priceLabel.attributedText = [NSString stringPrice:@"¥ 199.00" color:YBLThemeColor font:16 isBoldFont:NO appendingString:nil];
    priceLabel.centerX = self.width/2;
    [self addSubview:priceLabel];
    
}

@end

@interface YBLHotCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation YBLHotCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self registerClass:NSClassFromString(@"YBLHotListGoodCell") forCellWithReuseIdentifier:@"YBLHotListGoodCell"];
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBLHotListGoodCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLHotListGoodCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BLOCK_EXEC(self.hotCollectionDidSelectBlock,);
}


@end
