//
//  YBLCategoryRightView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryRightView.h"
#import "YBLCategoryTreeModel.h"

#pragma mark--
#pragma mark--YBLCategoryRightCell

@interface YBLCategoryRightCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodNameLabel;

@end

@implementation YBLCategoryRightCell

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
    self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width-25, self.width-25)];
    self.goodImageView.centerX = self.width/2;
    [self.contentView addSubview:self.goodImageView];
 
    self.goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodImageView.bottom, self.width, 20)];
    self.goodNameLabel.textColor = YBLColor(120, 120, 120, 1.0);
    self.goodNameLabel.font = YBLFont(12);
    self.goodNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodNameLabel];
}

@end

#pragma mark--
#pragma mark--YBLCategoryRightHeaderView

@interface YBLCategoryRightHeaderView : UICollectionReusableView

@property (nonatomic, retain) UILabel *categoryLabel;

@end

@implementation YBLCategoryRightHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{

    self.backgroundColor = YBLViewBGColor;
    
    self.categoryLabel = [[UILabel alloc] init];
    [self addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.equalTo(@0);
        make.left.equalTo(@8);
    }];
    self.categoryLabel.font = YBLFont(13);
    self.categoryLabel.textColor = YBLColor(40, 40, 40, 1.0);
}

@end

#pragma mark--
#pragma mark--YBLCategoryRightView

@interface YBLCategoryRightView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) TypeHeader typeHeader;

@end


@implementation YBLCategoryRightView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                   typeHeader:(TypeHeader)typeHeader{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
//        self.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
//        self.rightTableView.backgroundColor = YBLColor(240, 240, 240, 1.0);
        [self registerClass:[YBLCategoryRightCell class] forCellWithReuseIdentifier:@"YBLCategoryRightCell"];
        [self registerClass:[YBLCategoryRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLCategoryRightHeaderView"];
      
    }
    return self;
}

- (void)setRightDataArray:(NSMutableArray *)rightDataArray{
    _rightDataArray = rightDataArray;
    
    [self jsReloadData];
}

#pragma mark -
#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   
    return _rightDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *rowArray = _rightDataArray[section][@"row"];
    return [rowArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBLCategoryRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLCategoryRightCell" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray *rowArray = _rightDataArray[section][@"row"];
    YBLCategoryTreeModel *model = rowArray[row];
    
    [cell.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:smallImagePlaceholder];
    
    cell.goodNameLabel.text = model.title;
    
    return cell;

    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        YBLCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLCategoryRightHeaderView" forIndexPath:indexPath];
        NSInteger section = indexPath.section;

        YBLCategoryTreeModel *model = _rightDataArray[section][@"section"];

        headerView.categoryLabel.text = model.title;
        
        return headerView;
    } else {
        return 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray *rowArray = _rightDataArray[section][@"row"];
    YBLCategoryTreeModel *model = rowArray[row];
    BLOCK_EXEC(self.self.itemClickBlock,model);
}


#pragma mark -
#pragma mark -UIScrollViewDelegate


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < -(self.contentInset.top+45)) {
        if(self.scrollChangeBlock){
            self.scrollChangeBlock(NO);
        }
        return;
    }
    if(offY > self.contentSize.height + 45 - self.height){
        if(self.scrollChangeBlock){
            self.scrollChangeBlock(YES);
        }
        return;
    }
}



@end
