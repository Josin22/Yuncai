//
//  YBLGoodsEvaluateCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsEvaluateCell.h"

@interface YBLGoodsEvaluateCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLGoodsEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createEvaluateUI];
    }
    return self;
}

- (void)createEvaluateUI{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat wi = (YBLWindowWidth)/4;
    layout.itemSize = CGSizeMake(wi, wi);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.imageCollectionView = [[YBLEvaluatePicCollection alloc] initWithFrame:CGRectMake(0, self.contentLabel.bottom, YBLWindowWidth, wi)
                                                      collectionViewLayout:layout];
    [self.contentView addSubview:self.imageCollectionView];

    self.contentLabel.left = space/2;
    self.contentLabel.width = self.imageCollectionView.width-space;
    self.bottomView.left = self.contentLabel.left;
    self.bottomView.width = self.contentLabel.width;
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(self.bottomView.left, self.bottomView.height-.5, YBLWindowWidth, .5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLOrderCommentsModel *model = (YBLOrderCommentsModel *)itemModel;
    CGFloat BOYTTO = space;
    if (model.pictures.count==0) {
        BOYTTO = 0;
        self.imageCollectionView.hidden = YES;
    } else {
        self.imageCollectionView.hidden = NO;
        self.imageCollectionView.dataArray = model.pictures;
    }
    self.imageCollectionView.top = self.contentLabel.bottom+space;
    if (!self.imageCollectionView.isHidden){
        self.bottomView.top = self.imageCollectionView.bottom+BOYTTO;
    } else {
        self.bottomView.top = self.contentLabel.bottom+space;
    }
   
    self.lineView.bottom = self.height;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    CGFloat basehi = [super getItemCellHeightWithModel:itemModel];
    
    YBLOrderCommentsModel *model = (YBLOrderCommentsModel *)itemModel;
    if (model.pictures.count!=0) {
        basehi += YBLWindowWidth/4;
    }
    return basehi;
}

@end
