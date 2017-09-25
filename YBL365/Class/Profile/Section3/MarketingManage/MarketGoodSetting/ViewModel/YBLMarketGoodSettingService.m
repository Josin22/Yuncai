//
//  YBLMarketGoodSettingService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMarketGoodSettingService.h"
#import "YBLMarketGoodSettingViewController.h"
#import "YBLEditPicCollectionView.h"
#import "YBLCopywriterTableView.h"
#import "YBLWriteTextView.h"
#import "LxGridViewFlowLayout.h"
#import "YBLWMarketViewModel.h"
#import "YBLWMarketGoodModel.h"

@interface YBLMarketGoodSettingService ()<YBLTextSegmentControlDelegate,YBLEditPicCollectionViewDelegate,UIScrollViewDelegate,YBLCopywriterTableViewDelegate>

@property (nonatomic, weak) YBLMarketGoodSettingViewController *selfVc;

@property (nonatomic, weak) YBLMarketGoodSettingViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) YBLEditPicCollectionView *editPicCollectionView;

@property (nonatomic, strong) YBLCopywriterTableView *copywriterTableView;

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation YBLMarketGoodSettingService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _selfVc = (YBLMarketGoodSettingViewController *)VC;
        _viewModel = (YBLMarketGoodSettingViewModel *)viewModel;
        
        _selfVc.navigationItem.titleView = self.titleViewSegment;
        
        [self.selfVc.view addSubview:self.contentScrollView];
        
        WEAK
        [[YBLWMarketViewModel siganlForWmarketGoodID:self.viewModel.marketGoodModel.id] subscribeNext:^(YBLWMarketGoodModel*  _Nullable x) {
            STRONG
            self.viewModel.marketGoodModel = x;
            [self reload];
        } error:^(NSError * _Nullable error) {
            STRONG
            [self reload];
        }];
    }
    return self;
}

- (void)reload{
    self.copywriterTableView.dataArray = self.viewModel.marketGoodModel.copywritings;
    [self.copywriterTableView jsReloadData];
}

- (YBLTextSegmentControl *)titleViewSegment{
    
    if (!_titleViewSegment) {
        _titleViewSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, 100, 44) TextSegmentType:TextSegmentTypeGoodsDetail];
        _titleViewSegment.delegate = self;
        [_titleViewSegment updateTitleData:[@[@"图片",@"文案"] mutableCopy]];
        _titleViewSegment.currentIndex = 1;
    }
    return _titleViewSegment;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:[self.selfVc.view bounds]];
        _contentScrollView.height -= kNavigationbarHeight;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.contentSize = CGSizeMake(YBLWindowWidth*2, _contentScrollView.height);
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.backgroundColor = self.selfVc.view.backgroundColor;
    }
    return _contentScrollView;
}

- (YBLEditPicCollectionView *)editPicCollectionView{
    
    if (!_editPicCollectionView) {
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        LxGridViewFlowLayout *layout = [LxGridViewFlowLayout new];
        layout.footerReferenceSize = CGSizeZero;
        layout.headerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        CGFloat itemWi = (YBLWindowWidth-5*space)/4;
        layout.itemSize = CGSizeMake(itemWi, itemWi+2*space);
        EditPicCollectionViewType type = EditPicCollectionViewTypeZSGKY;
        if (self.viewModel.marketGoodVcType == MarketGoodVCTypeChoose) {
            type = EditPicCollectionViewTypeJustSelect;
        }
        _editPicCollectionView = [[YBLEditPicCollectionView alloc] initWithFrame:[self.contentScrollView bounds]
                                                            collectionViewLayout:layout
                                                                  collectionType:type];
        _editPicCollectionView.left = 0;
        _editPicCollectionView.edit_delegate = self;
        _editPicCollectionView.isEditMode = YES;
        [self.contentScrollView addSubview:_editPicCollectionView];
    }
    return _editPicCollectionView;
}

- (YBLCopywriterTableView *)copywriterTableView{
    if (!_copywriterTableView) {
        CopywriterTableViewType type = CopywriterTableViewTypeEdit;
        if (self.viewModel.marketGoodVcType == MarketGoodVCTypeChoose) {
            type = CopywriterTableViewTypeChoose;
        }
        _copywriterTableView = [[YBLCopywriterTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                                       style:UITableViewStylePlain
                                                               tableViewType:type];
        _copywriterTableView.left = YBLWindowWidth;
        _copywriterTableView.cp_delegate = self;
        [self.contentScrollView addSubview:_copywriterTableView];
        if (self.viewModel.marketGoodVcType == MarketGoodVCTypeSetting) {
            _copywriterTableView.height -= self.addButton.height;
            [self.contentScrollView addSubview:self.addButton];
        }
    }
    return _copywriterTableView;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(YBLWindowWidth, 0, self.contentScrollView.width, buttonHeight)];
        _addButton.bottom = self.contentScrollView.height;
        [_addButton setTitle:@"添加文案" forState:UIControlStateNormal];
        WEAK
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self showTexztValue:nil indexp:nil];
        }];
    }
    return _addButton;
}

- (void)showTexztValue:(NSString *)value indexp:(NSIndexPath *)indexp{
    WEAK
    [YBLWriteTextView showWriteTextViewOnView:self.selfVc.navigationController
                                  currentText:value
                             LimmitTextLength:500
                                 completetion:^(NSString *text) {
                                     STRONG
                                     if (text.length==0) {
                                         return ;
                                     }
                                     NSInteger ubdex = 0;
                                     if (indexp) {
                                         NSInteger row = indexp.row;
                                         ubdex = row;
                                     }
                                     if (indexp) {
                                         [self.viewModel.marketGoodModel.copywritings replaceObjectAtIndex:ubdex withObject:text];
                                         self.copywriterTableView.dataArray = self.viewModel.marketGoodModel.copywritings;
                                         [self.copywriterTableView reloadRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     } else {
                                         [self.viewModel.marketGoodModel.copywritings insertObject:text atIndex:ubdex];
                                         self.copywriterTableView.dataArray = self.viewModel.marketGoodModel.copywritings;
                                         NSIndexPath *inserP = [NSIndexPath indexPathForRow:0 inSection:0];
                                         [self.copywriterTableView jsInsertRowIndexps:@[inserP] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     }
                                     
                                 }];
}

#pragma mark - delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.selfVc.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/YBLWindowWidth;
    self.titleViewSegment.currentIndex = index;
}

- (void)textSegmentControlIndex:(NSInteger)index{
    [self.contentScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    [self reloadPicWithIndex:index];
}

- (void)reloadPicWithIndex:(NSInteger)index{
    if (index == 0&&self.editPicCollectionView.picDataArray.count==0) {
        self.editPicCollectionView.picDataArray = self.viewModel.picDataArray;
    }
}

- (void)copywriterCellDidSelectIndexPath:(NSIndexPath *)indexPath selectValue:(NSString *)selectValue{
    
    if (self.viewModel.marketGoodVcType == MarketGoodVCTypeChoose) {
        self.viewModel.selectText = selectValue;
        return;
    }
    WEAK
    [YBLActionSheetView showActionSheetWithTitles:@[@"同步",@"置顶",@"删除"] handleClick:^(NSInteger index) {
        STRONG
        NSInteger row = indexPath.row;
        switch (index) {
            case 0:
            {
                //同步
               [self.viewModel siganlForSyncMarketText:selectValue];
            }
                break;
            case 1:
            {
                //置顶
                [self.viewModel.marketGoodModel.copywritings exchangeObjectAtIndex:row withObjectAtIndex:0];
                NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                [self.copywriterTableView reloadRowsAtIndexPaths:@[indexPath,firstIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
            case 2:
            {
                //删除
                [self.viewModel.marketGoodModel.copywritings removeObjectAtIndex:row];
                self.copywriterTableView.dataArray = self.viewModel.marketGoodModel.copywritings;
                [self.copywriterTableView beginUpdates];
                [self.copywriterTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.copywriterTableView endUpdates];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)copywriterCellButtonClickIndexPath:(NSIndexPath *)indexPath selectValue:(NSString *)selectValue{
    [self showTexztValue:selectValue indexp:indexPath];
}

#pragma mark - pic 

/**
 *  添加图片
 *
 *  @return return value
 */
- (NSInteger)getMaxCountBeforeClickAddImageButton{
    return 50;
}
/**
 *  查看大图
 *
 *  @return return value
 */
- (UIViewController *)getVcWithEditPicItemClickToLookPic{
    return self.selfVc;
}
/**
 *  点击删除
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToDeleteImageWithIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel{
    [self.viewModel.picDataArray removeObjectAtIndex:indexPath.row];
    [self.editPicCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.editPicCollectionView jsReloadData];
    });
}
/**
 *  替换图片
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToReplaceImageWithIndexPath:(NSIndexPath *)indexPath repalceImage:(UIImage *)repalceImage{
    WEAK
    [[self.viewModel siganlForUploadImage:repalceImage index:indexPath.row isAppending:NO] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.editPicCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    } error:^(NSError * _Nullable error) {
        
    }];
}
/**
 *  添加图片
 *
 *  @param images images
 */
- (void)editPicItemClickAddImages:(NSArray *)images{
    WEAK
    [[self.viewModel siganlForMutilUploadImage:images] subscribeNext:^(id  _Nullable x) {
        STRONG
        NSInteger count = self.viewModel.picDataArray.count;
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.editPicCollectionView insertItemsAtIndexPaths:@[indexp]];
    } error:^(NSError * _Nullable error) {
        
    }];
}


@end
