//
//  YBLExpressNewsCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLExpressNewsCell.h"
#import "YBLListBaseModel.h"

@interface YBLExpressNewsCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *expressScrollView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) YBLListCellItemModel *model;

@end

@implementation YBLExpressNewsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.contentView.backgroundColor = YBLColor(243, 243, 243, 1);
    
    //快报
    UIView *expressNewsView = [[UIView alloc] initWithFrame:CGRectMake(space, space, self.width-space*2, 35)];
    expressNewsView.layer.cornerRadius = expressNewsView.height/2;
    expressNewsView.layer.masksToBounds = YES;
    expressNewsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:expressNewsView];
    
    UIImageView *expressNewsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_express"]];
    expressNewsImageView.frame = CGRectMake(space, 0, 63, 15);
    expressNewsImageView.centerY = expressNewsView.height/2;
    expressNewsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [expressNewsView addSubview:expressNewsImageView];
    
    SDCycleScrollView *expressScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(CGRectGetMaxX(expressNewsImageView.frame), 0, expressNewsView.width-expressNewsImageView.right-5-50, expressNewsView.height) delegate:self placeholderImage:nil];
    expressScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    expressScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    expressScrollView.onlyDisplayText = YES;
    expressScrollView.titleLabelTextColor = BlackTextColor;
    expressScrollView.titleLabelTextFont = YBLFont(12);
    [expressNewsView addSubview:expressScrollView];
    self.expressScrollView = expressScrollView;
    
    NSString *title = @"更多";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(CGRectGetMaxX(expressScrollView.frame), 0, expressNewsView.width-CGRectGetMaxX(expressScrollView.frame), expressNewsView.height);
    [moreButton setTitle:title forState:UIControlStateNormal];
    moreButton.backgroundColor = [UIColor clearColor];
    [moreButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = YBLFont(12);
    [expressNewsView addSubview:moreButton];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, 0.5, 20)];
    lineView.backgroundColor = YBLLineColor;
    [moreButton addSubview:lineView];
    self.moreButton = moreButton;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    YBLPushPurchaseInfoModel *infoModel = self.model.orginValueOfRowItemCellData[index];
    BLOCK_EXEC(self.expressNewsCellScrollClickBlock,infoModel)
}


- (void)updateItemCellModel:(id)itemModel{
    YBLListCellItemModel *model = (YBLListCellItemModel *)itemModel;
    self.model = model;
    self.expressScrollView.titlesGroup = model.valueOfRowItemCellData;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 55;
}

//old

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    self.titleArray = [NSMutableArray array];
    for (YBLPushPurchaseInfoModel *infoModel in _dataArray) {
        [self.titleArray addObject:infoModel.message];
    }
    self.expressScrollView.titlesGroup = self.titleArray;
}

+ (CGFloat)getButtonsCellHeight{
    
    return 45+space;
}

@end
