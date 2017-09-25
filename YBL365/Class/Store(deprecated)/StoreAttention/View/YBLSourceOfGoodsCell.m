//
//  YBLSourceOfGoodsCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLSourceOfGoodsCell.h"

@interface YBLSourceOfGoodsCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel * companyLab;
@property (nonatomic, strong) UICollectionView * collecView;
@property (nonatomic, strong) UILabel * agentLab;
@property (nonatomic, strong) UILabel * agentPriceLab;
@property (nonatomic, strong) UILabel * wholesaleLab;
@property (nonatomic, strong) UILabel * wholesalePriceLab;
@property (nonatomic, strong) UIButton * forwardBtn;
@property (nonatomic, strong) UILabel * contentDetailLab;
@property (nonatomic, strong) UIImageView * lineImageView;


@end

@implementation YBLSourceOfGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createrUI];
    }
    return self;
}

- (UICollectionView *)collecView {
    if (!_collecView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize=CGSizeMake(68, 68);
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, YBLWindowWidth-20, 70) collectionViewLayout:layout];
        _collecView.directionalLockEnabled = NO;
        _collecView.showsHorizontalScrollIndicator=NO;
        _collecView.backgroundColor= [UIColor clearColor];
        _collecView.delegate=self;
        _collecView.dataSource=self;
        [_collecView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    }
    return _collecView;
}

- (void)createrUI {
    
    UIView * headerLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
    headerLineView.backgroundColor = YBLColor(242, 242, 242, 1);
    [self.contentView addSubview:headerLineView];
    
    [self.contentView addSubview:self.collecView];
    self.companyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, self.collecView.bottom+5, YBLWindowWidth-20, 20)];
    self.companyLab.textColor = YBLTextColor;
    self.companyLab.font = YBLFont(13);
    [self.contentView addSubview:self.companyLab];
    
    self.contentDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.contentDetailLab.textColor = [BlackTextColor colorWithAlphaComponent:0.9];
    self.contentDetailLab.font = YBLFont(15);
    [self.contentView addSubview:self.contentDetailLab];
    
}

//- (UIView *)priceView {
//    self.lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self.lineImageView.image = [UIImage imageNamed:@""];
//    [self.contentView addSubview:self.lineImageView];
//    
//    
//    self.agentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self.agentLab.textColor = YBLTextColor;
//    self.agentLab.font = YBLFont(13);
//    [self.contentView addSubview:self.agentLab];
//    
//    self.agentPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self.agentPriceLab.textColor = YBLThemeColor;
//    self.agentPriceLab.font = YBLFont(15);
//    [self.contentView addSubview:self.agentPriceLab];
//    
//    self.wholesaleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self.wholesaleLab.textColor = YBLTextColor;
//    self.wholesaleLab.font = YBLFont(13);
//    [self.contentView addSubview:self.wholesaleLab];
//    
//    self.wholesalePriceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self.wholesalePriceLab.textColor = YBLThemeColor;
//    self.wholesalePriceLab.font = YBLFont(15);
//    [self.contentView addSubview:self.wholesalePriceLab];
//    
//    self.forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.forwardBtn.layer.borderColor = YBLThemeColor.CGColor;
//    self.forwardBtn.layer.borderWidth = 0.3;
//    self.forwardBtn.layer.cornerRadius = 2;
//    self.forwardBtn.clipsToBounds = YES;
//    self.forwardBtn.backgroundColor = [UIColor whiteColor];
//    [self.forwardBtn setTitleColor:YBLThemeColor forState:UIControlStateNormal];
//    self.forwardBtn.titleLabel.font = YBLFont(15);
//    [self.contentView addSubview:self.forwardBtn];
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    imageView.tag = 900;
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.6;
    imageView.layer.borderColor = YBLLineColor.CGColor;
    imageView.image = [UIImage imageNamed:@""];
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
