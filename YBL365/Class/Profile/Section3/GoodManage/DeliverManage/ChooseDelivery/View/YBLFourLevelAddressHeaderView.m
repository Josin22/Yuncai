//
//  YBLFourLevelAddressHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFourLevelAddressHeaderView.h"
#import "YBLFourLevelAddressItemCollectionView.h"
#import "YBLAddressAreaModel.h"

static NSInteger const tag_fourcollectionview = 2542;

@interface YBLFourLevelAddressHeaderView ()

@property (nonatomic, strong) YBLFourLevelAddressItemCollectionView *shengTableView;

@end

@implementation YBLFourLevelAddressHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];    
    }
    return self;
}

- (YBLChooseAreaViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLChooseAreaViewModel new];
        _viewModel.chooseAreaVCType = ChooseAreaVCTypeHorizontal;
    }
    return _viewModel;
}

- (void)createUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat header_height = [YBLFourLevelAddressHeaderView getHeaderViewHeight];

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    YBLFourLevelAddressItemCollectionView *fourView = [[YBLFourLevelAddressItemCollectionView alloc] initWithFrame:CGRectMake(0, space/2, YBLWindowWidth, Height_CollectionView) collectionViewLayout:layout collectionType:tableTypeSXArrow];
    fourView.backgroundColor = [UIColor whiteColor];
    WEAK
    fourView.fourLevelAddressItemCollectionViewCellDidSelectBlock = ^(BOOL arrowOrNot, BOOL buttonSelect, YBLAddressAreaModel *model) {
        STRONG
        [self handleDataModel:model arrowOrNot:arrowOrNot buttonSelect:buttonSelect Index:1];
    };
    [self.contentView addSubview:fourView];
    self.shengTableView = fourView;
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, header_height-.5, YBLWindowWidth, .5)]];
    //
    [self checkDataIsExsitWithId:0 Index:0];
}


///数据update
- (void)checkDataIsExsitWithId:(NSInteger)Id Index:(NSInteger)index{
    
    NSMutableArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
    if (!dataArray) {
        ///请求数据
        [[self.viewModel areaListSignalWithId:Id Index:index] subscribeError:^(NSError *error) {
            
        } completed:^{
            NSMutableArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
            if (index == 0) {
                [self.shengTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
            } else {
                NSMutableArray *dataArray = self.viewModel.sxAreaDataDict[@(Id)];
                YBLFourLevelAddressItemCollectionView *sxTableView = (YBLFourLevelAddressItemCollectionView *)[self viewWithTag:tag_fourcollectionview+index];
                if (!sxTableView) {
                    YBLFourLevelAddressItemCollectionView *sxTableView = [self getSXTableViewWithIndex:index];
                    [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
                    [self.contentView addSubview:sxTableView];
                } else {
                    [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
                }
            }
        }];
    } else {
        ///取已储存数据
        if (index == 0) {
            [self.shengTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
        } else {
            YBLFourLevelAddressItemCollectionView *sxTableView = (YBLFourLevelAddressItemCollectionView *)[self viewWithTag:tag_fourcollectionview+index];
            [sxTableView updateArray:dataArray Dict:self.viewModel.selectAreaDataDict];
        }
    }
    
}

///获取YBLFourLevelAddressItemCollectionView
- (YBLFourLevelAddressItemCollectionView *)getSXTableViewWithIndex:(NSInteger)index{
    
//    CGFloat header_height = [YBLFourLevelAddressHeaderView getHeaderViewHeight];
    
    CGRect new_frame = CGRectMake(0, space/2+index*(self.shengTableView.height+space/2), YBLWindowWidth, self.shengTableView.height);
    TableType  type = tableTypeSXArrow;
    if (index == self.viewModel.countByAreaType-1) {
        type = tableTypeSXNoneArrow;
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    YBLFourLevelAddressItemCollectionView *fourView = [[YBLFourLevelAddressItemCollectionView alloc] initWithFrame:new_frame collectionViewLayout:layout collectionType:type];
    fourView.tag = tag_fourcollectionview+index;
    fourView.backgroundColor = [UIColor whiteColor];
    WEAK
    fourView.fourLevelAddressItemCollectionViewCellDidSelectBlock = ^(BOOL arrowOrNot, BOOL buttonSelect, YBLAddressAreaModel *model) {
        STRONG
        [self handleDataModel:model arrowOrNot:arrowOrNot buttonSelect:buttonSelect Index:index+1];
    };
    return fourView;
}

///处理数据
- (void)handleDataModel:(YBLAddressAreaModel *)model
             arrowOrNot:(BOOL)arrowOrNot
           buttonSelect:(BOOL)buttonSelect
                  Index:(NSInteger)index{
    
    if (arrowOrNot) {
        for (NSInteger i = index; i<self.viewModel.countByAreaType; i++) {
            YBLFourLevelAddressItemCollectionView *sxTableView = (YBLFourLevelAddressItemCollectionView *)[self viewWithTag:tag_fourcollectionview+i];
            [sxTableView updateArray:nil Dict:self.viewModel.selectAreaDataDict];
        }
        if (buttonSelect) {
            [self checkDataIsExsitWithId:model.id.integerValue Index:index];
        }
    } else {
        for (NSInteger i = index; i<self.viewModel.countByAreaType; i++) {
            YBLFourLevelAddressItemCollectionView *sxTableView = (YBLFourLevelAddressItemCollectionView *)[self viewWithTag:tag_fourcollectionview+i];
            [sxTableView updateArray:nil Dict:self.viewModel.selectAreaDataDict];
        }
        if (buttonSelect) {
            //储存
            [self.viewModel saveModel:model];
        } else {
            //删除
            [self.viewModel deleteModel:model];
        }
    }
    
}

+ (CGFloat)getHeaderViewHeight{
    
    return (Height_CollectionView+space/2)*4+space;
}

@end
