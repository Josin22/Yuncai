//
//  YBLSelectAreaCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectAreaCollectionView.h"
#import "YBLPayshipmentItemButtonCollectionView.h"
#import "YBLAddressAreaModel.h"

#define TOP  YBLWindowHeight/8

static YBLSelectAreaCollectionView *selectAreaCollectionView = nil;

@interface YBLSelectAreaCollectionView ()

@property (nonatomic, weak) UIViewController *Vc;

@property (nonatomic, strong) NSMutableArray *areaData;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, copy  ) SelectAreaCollectionViewDoneBlock doneBlock;

@property (nonatomic, assign) SelectAreaType selectAreaType;

@property (nonatomic, strong) YBLPayshipmentItemButtonCollectionView *areaCollectionView;

@end

@implementation YBLSelectAreaCollectionView

+ (void)showSelectAreaCollectionViewFromVC:(UIViewController *)Vc
                            selectAreaType:(SelectAreaType)selectAreaType
                                  areaData:(NSMutableArray *)areaData
                                doneHandle:(SelectAreaCollectionViewDoneBlock)doneBlock{
    
    if (!selectAreaCollectionView) {
        selectAreaCollectionView = [[YBLSelectAreaCollectionView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        selectAreaCollectionView.selectAreaType = selectAreaType;
        selectAreaCollectionView.areaData = areaData;
        selectAreaCollectionView.Vc = Vc;
        selectAreaCollectionView.areaCollectionView.dataArray = areaData;
        selectAreaCollectionView.doneBlock = doneBlock;
        if (selectAreaType==SelectAreaTypeSave) {
            [selectAreaCollectionView.doneButton setTitle:@"保存" forState:UIControlStateNormal];
        }
    }
    [YBLMethodTools transformOpenView:selectAreaCollectionView.contentView SuperView:selectAreaCollectionView fromeVC:selectAreaCollectionView.Vc Top:TOP];

}

+ (void)showSelectAreaCollectionViewFromVC:(UIViewController *)Vc areaData:(NSMutableArray *)areaData doneHandle:(SelectAreaCollectionViewDoneBlock)doneBlock;
{
    [self showSelectAreaCollectionViewFromVC:Vc selectAreaType:SelectAreaTypeShow areaData:areaData doneHandle:doneBlock];
}

- (void)addSubvieToContentView{
    
    self.contentView.height = YBLWindowHeight-TOP;
    self.bgView.alpha = 0.1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    titleLabel.text = @"已选地区";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, titleLabel.width, .5)]];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, titleLabel.height*2, titleLabel.height);
    editButton.right = self.contentView.width-space;
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"取消" forState:UIControlStateSelected];
    [editButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [editButton setTitleColor:BlackTextColor forState:UIControlStateSelected];
    editButton.titleLabel.font = YBLFont(16);
    [self.contentView addSubview:editButton];
    self.editButton = editButton;
    [[editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;

        [self resetIsShowDeleteButton:x.selected];
        
        self.areaCollectionView.dataArray = selectAreaCollectionView.areaData;
    }];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((YBLWindowWidth-space)/4, 30);
    layout.sectionInset = UIEdgeInsetsMake(space, 0, space, space);
    layout.minimumLineSpacing = space;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.areaCollectionView = [[YBLPayshipmentItemButtonCollectionView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.contentView.width, self.contentView.height-titleLabel.bottom-buttonHeight)
                                                                       collectionViewLayout:layout
                                                                  payShipMentItemButtonType:PayShipMentItemButtonTypeGoodShowMent];
    [self.contentView addSubview:self.areaCollectionView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, self.areaCollectionView.bottom, self.contentView.width, buttonHeight);
    doneButton.backgroundColor = YBLThemeColor;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = YBLFont(16);
    [self.contentView addSubview:doneButton];
    self.doneButton = doneButton;
    WEAK
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [self resetIsShowDeleteButton:NO];
        BLOCK_EXEC(selectAreaCollectionView.doneBlock,selectAreaCollectionView.areaData);
        [self dismiss];
    }];
}

- (void)resetIsShowDeleteButton:(BOOL)isShow{

    if (selectAreaCollectionView.areaData.count!=0) {
        for (YBLAddressAreaModel *model in selectAreaCollectionView.areaData) {
            model.isShowDeleteButton = isShow;
        }
    }

}

- (void)dismiss{
    //重置
    [self resetIsShowDeleteButton:NO];
    
    [YBLMethodTools transformCloseView:selectAreaCollectionView.contentView SuperView:selectAreaCollectionView fromeVC:selectAreaCollectionView.Vc Top:YBLWindowHeight completion:^(BOOL finished) {
        
        [selectAreaCollectionView removeFromSuperview];
        selectAreaCollectionView = nil;
    }];
    
}

@end
