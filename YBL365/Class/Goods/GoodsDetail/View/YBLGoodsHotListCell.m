//
//  YBLGoodsHotListCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsHotListCell.h"
#import "YBLCollectionViewFlowLayout.h"
#import "YBLSingleTextSegment.h"

@interface YBLGoodsHotListCell ()<YBLSingleTextSegmentDelegate>

@property (nonatomic, strong) YBLSingleTextSegment *seg;

@end

@implementation YBLGoodsHotListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createHotListUI];
    }
    return self;
}

- (void)createHotListUI{
    
    CGFloat wi = YBLWindowWidth/3;
    
    NSArray *titleArray = @[@"为你推荐"];
    
    YBLSingleTextSegment *seg = [[YBLSingleTextSegment alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40) TitleArray:titleArray];
    seg.delegate = self;
    seg.lineView.hidden = YES;
    [self addSubview:seg];
    self.seg = seg;
    
    YBLCollectionViewFlowLayout *layout = [YBLCollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(wi, wi+45);
    layout.minimumInteritemSpacing = 0*SCREEN_SCALE;
    layout.minimumLineSpacing = 0*SCREEN_SCALE;
    layout.headerReferenceSize = CGSizeMake(0*SCREEN_SCALE, 0*SCREEN_SCALE);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.hotListCollectionView = [[YBLHotCollectionView alloc] initWithFrame:CGRectMake(0, seg.bottom, YBLWindowWidth, 2*(wi+50)) collectionViewLayout:layout];
    [self addSubview:self.hotListCollectionView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.hotListCollectionView.frame), YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), YBLWindowWidth, 35);
    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:YBLColor(110, 110, 110, 1) forState:UIControlStateNormal];
    moreButton.titleLabel.font = YBLFont(16);
    [self addSubview:moreButton];
    self.moreButton = moreButton;
    
    
}

- (void)setType:(hotType)type{
    
    if (type == hotTypeNormal) {
        
        NSArray *titleArray = @[@"为你推荐",@"排行榜"];
        self.seg.titleArray = titleArray;
        
    } else {
        
        NSArray *titleArray = @[@"更多采购",@"采购排行"];
        self.seg.titleArray = titleArray;
    }
    
}


- (void)CurrentSegIndex:(NSInteger)index{
    
}

+ (CGFloat)getGoodsHotListCellHeight{
    
    return [[self new] getCollectionWI];
}

- (CGFloat)getCollectionWI{
    
    return self.moreButton.bottom;

}

@end
