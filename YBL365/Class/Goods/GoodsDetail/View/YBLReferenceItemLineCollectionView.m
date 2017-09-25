//
//  YBLReferenceCollectionView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLReferenceItemLineCollectionView.h"

@interface referenceItemCell : UICollectionViewCell

@property (nonatomic, retain) UILabel *bottomTitleLabel;

@property (nonatomic, strong) UIButton *lineImageView;

@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation referenceItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itemButton.frame = CGRectMake(0, 5, 34, 50);
    self.itemButton.centerX = self.width/2;
    [self.itemButton setBackgroundImage:[UIImage imageNamed:@"reference_item_withe"] forState:UIControlStateNormal];
    [self.itemButton setBackgroundImage:[UIImage imageNamed:@"reference_item_red"] forState:UIControlStateSelected];
    [self.itemButton setTitle:@"kNavigationbarHeight2" forState:UIControlStateNormal];
    [self.itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.itemButton.titleLabel.font = YBLFont(12);
    [self addSubview:self.itemButton];

    self.lineImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lineImageView.frame = CGRectMake(0, self.itemButton.bottom+3, 1, self.height-self.itemButton.bottom-30-3);
    [self.lineImageView setBackgroundImage:[UIImage imageNamed:@"reference_item_line_grey"] forState:UIControlStateNormal];
    [self.lineImageView setBackgroundImage:[UIImage imageNamed:@"reference_item_line_red"] forState:UIControlStateSelected];
    self.lineImageView.centerX = self.width/2;
    [self addSubview:self.lineImageView];
    
    self.bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lineImageView.bottom, self.width, 30)];
    self.bottomTitleLabel.text = @"河南";
    self.bottomTitleLabel.textColor = YBLColor(136, 136, 136, 1);
    self.bottomTitleLabel.font = YBLFont(12);
    self.bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bottomTitleLabel];
    
    [self.bottomTitleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, self.bottomTitleLabel.width, 0.85)]];
    
}

@end

@interface YBLReferenceItemLineCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>



@end

@implementation YBLReferenceItemLineCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self registerClass:NSClassFromString(@"referenceItemCell") forCellWithReuseIdentifier:@"referenceItemCell"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    referenceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"referenceItemCell" forIndexPath:indexPath];
//    cell.backgroundColor  = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    referenceItemCell *newcell = (referenceItemCell *)cell;
    
    CGRect orginItemFrame = newcell.itemButton.frame;
    CGRect orginLineImageViewFrame = newcell.lineImageView.frame;
    
    newcell.itemButton.top = newcell.height-30-newcell.itemButton.height;
    newcell.lineImageView.top = newcell.itemButton.bottom;
    newcell.lineImageView.height = 0;
    
    [UIView animateWithDuration:.5f
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                          cell.frame = orginFrame;
                         newcell.itemButton.frame = orginItemFrame;
                         newcell.lineImageView.frame = orginLineImageViewFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

@end
