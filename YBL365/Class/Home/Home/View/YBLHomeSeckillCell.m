//
//  YBLHomeSeckillCell.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeSeckillCell.h"
#import "YBLTimeDown.h"

#pragma mark  YBLSeckillGoodCell

@interface YBLSeckillGoodCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *seckillGoodImageView;

@property (nonatomic, strong) UILabel *seckillPriceLabel;

@property (nonatomic, strong) YBLLabel *oldPriceLabel;

@end

@implementation YBLSeckillGoodCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSeckillGoodsUI];
    }
    return self;
}

- (void)createSeckillGoodsUI{
    
    _seckillGoodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    _seckillGoodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
//    _seckillGoodImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_seckillGoodImageView];
    
    _seckillPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_seckillGoodImageView.frame), _seckillGoodImageView.width, 20)];
    _seckillPriceLabel.textAlignment = NSTextAlignmentCenter;
    NSString *mo = @"¥ 199.00";
    _seckillPriceLabel.attributedText = [NSString stringPrice:mo color:YBLThemeColor font:16 isBoldFont:YES appendingString:nil];
    [self.contentView addSubview:_seckillPriceLabel];
    
    _oldPriceLabel = [[YBLLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_seckillPriceLabel.frame), _seckillPriceLabel.width, 15)];
    NSString *momo = @"¥299.00";
    _oldPriceLabel.text = momo;
    _oldPriceLabel.font = YBLFont(12);
    _oldPriceLabel.textColor = YBLTextColor;
    _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
    _oldPriceLabel.strikeThroughColor = YBLTextColor;
    _oldPriceLabel.strikeThroughEnabled = YES;
    [self.contentView addSubview:_oldPriceLabel];
}

@end


#pragma mark  YBLHomeSeckillCell

@interface YBLHomeSeckillCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *seckillGoodCollectionView;

@property (nonatomic, strong) YBLButton *seckillImageViewButton;

@property (nonatomic, strong) YBLTimeDown *seckillTimeDown;

@property (nonatomic, strong) YBLButton *seckillTextButton;

@end

@implementation YBLHomeSeckillCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSackillUI];
    }
    return self;
}

- (void)createSackillUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _seckillImageViewButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _seckillImageViewButton.frame = CGRectMake(0, 5, 130, 20);
    [_seckillImageViewButton setImage:[UIImage imageNamed:@"home_seckill"] forState:UIControlStateNormal];
    [_seckillImageViewButton setTitle:@"20点场" forState:UIControlStateNormal];
    [_seckillImageViewButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    _seckillImageViewButton.titleLabel.font = YBLBFont(14);
    _seckillImageViewButton.imageRect = CGRectMake(space, 2.5, 60, 15);
    _seckillImageViewButton.titleRect = CGRectMake(space+60+5, 2.5, 55, 15);
    [self.contentView addSubview:_seckillImageViewButton];
    
    _seckillTimeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_seckillImageViewButton.frame), 5,80, 20) WithType:TimeDownTypeNumber];
    NSString *testTime = @"2017-02-09 9:06:30";
    [_seckillTimeDown setEndTime:testTime
                       begainText:@""];
    _seckillTimeDown.textColor = BlackTextColor;
    _seckillTimeDown.timeOverBlock = ^(){
        NSLog(@"秒杀结束.............");
    };
    [self.contentView addSubview:_seckillTimeDown];

    _seckillTextButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _seckillTextButton.frame = CGRectMake(CGRectGetMaxX(_seckillTimeDown.frame), 0, self.width-CGRectGetMaxX(_seckillTimeDown.frame), 20);
    [_seckillTextButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [_seckillTextButton setTitle:@"年货白酒疯抢直播" forState:UIControlStateNormal];
    _seckillTextButton.titleLabel.font = YBLFont(13);
    _seckillTextButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_seckillTextButton setImage:[UIImage imageNamed:@"home_seckill_circle"] forState:UIControlStateNormal];
    _seckillTextButton.titleRect = CGRectMake(0, 5, self.width-CGRectGetMaxX(_seckillTimeDown.frame)-30, 20);
    _seckillTextButton.imageRect = CGRectMake(self.width-CGRectGetMaxX(_seckillTimeDown.frame)-27, 7.5, 15, 15);
    [self.contentView addSubview:_seckillTextButton];
    
    CGFloat singleW = [self getSingleH];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _seckillGoodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_seckillImageViewButton.frame), self.width, singleW+35) collectionViewLayout:layout];
    _seckillGoodCollectionView.dataSource = self;
    _seckillGoodCollectionView.delegate = self;
    [_seckillGoodCollectionView registerClass:NSClassFromString(@"YBLSeckillGoodCell") forCellWithReuseIdentifier:@"YBLSeckillGoodCell"];
    _seckillGoodCollectionView.showsHorizontalScrollIndicator = NO;
    _seckillGoodCollectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_seckillGoodCollectionView];
}

- (CGFloat)getSingleH{
    
    CGFloat space = 0;
    CGFloat showNum = 3.3;
    CGFloat singleW = (YBLWindowWidth-9*space)/showNum;
    return singleW;
}

+ (CGFloat)getSeckillCellHeight{
    
    return 30+[[self new] getSingleH]+32;
}

#pragma mark - collection data source / delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLSeckillGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLSeckillGoodCell" forIndexPath:indexPath];

    return [self getSeckillCell:cell indexPath:indexPath];
}


#pragma mark - cell

- (YBLSeckillGoodCell *)getSeckillCell:(YBLSeckillGoodCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    return cell;
}

#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self getSingleH]-10, [self getSingleH]+20);
}

//- (UICollectionReusableView   *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
/*
 //返回头headerView的大小
 -(CGSize)collectionView:(UICollectionView *)collectionView
 layout:(UICollectionViewLayout *)collectionViewLayout
 referenceSizeForHeaderInSection:(NSInteger)section{
 
 }
 
 //返回头footerView的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView
 layout:(UICollectionViewLayout*)collectionViewLayout
 referenceSizeForFooterInSection:(NSInteger)section{
 
 }
 
 */
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BLOCK_EXEC(self.homeSeckillClickBlock,indexPath.row);
    
}


@end
