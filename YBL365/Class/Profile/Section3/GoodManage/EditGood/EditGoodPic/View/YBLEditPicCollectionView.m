//
//  YBLEditPicCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPicCollectionView.h"
#import "YBLEditPicItemCell.h"
#import "YBLFoundationMethod.h"
#import "KSPhotoBrowser.h"
#import "HMImagePickerController.h"
#import "YBLPhotoHeplerViewController.h"

@interface YBLEditPicCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,HMImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *selectAssetsArray;

@property (nonatomic, assign) EditPicCollectionViewType collectionViewType;

@end

@implementation YBLEditPicCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout{

    return [self initWithFrame:frame
          collectionViewLayout:layout
                collectionType:EditPicCollectionViewTypeZSGKY];
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
               collectionType:(EditPicCollectionViewType)collectionViewType{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _collectionViewType = collectionViewType;
        
        self.dataSource = self;
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:NSClassFromString(@"YBLEditPicItemCell") forCellWithReuseIdentifier:@"YBLEditPicItemCell"];
    }
    return self;
}

- (void)setPicDataArray:(NSMutableArray *)picDataArray{
    _picDataArray = picDataArray;
    
    [self jsReloadData];
}

- (void)setIsEditMode:(BOOL)isEditMode{
    _isEditMode = isEditMode;
    
    [self jsReloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger otherCount = 1;
    if (_collectionViewType == EditPicCollectionViewTypeJustSelect) {
        otherCount = 0;
    }
    return _picDataArray.count+otherCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLEditPicItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLEditPicItemCell" forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    //最后一个
    if (row == _picDataArray.count&&(_collectionViewType == EditPicCollectionViewTypeZSGKY)) {
        cell.iconImageView.image = [UIImage imageNamed:@"edit_pic_add"];
        cell.infoLabel.hidden = YES;
    } else {
        //图片
        YBLEditPicItemModel *itemModel = _picDataArray[row];
        [cell updateModel:itemModel row:row];
        if (self.collectionViewType == EditPicCollectionViewTypeJustSelect) {
            cell.selectButton.hidden = NO;
            cell.selectButton.selected = itemModel.isSelect;
//            WEAK
            [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
//                STRONG
                x.selected = !x.selected;
                itemModel.isSelect = x.selected;
            }];
        } else {
            cell.selectButton.hidden = YES;
        }
    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    YBLEditPicItemModel *itemModel;
    BOOL isClickAddButton = NO;
    if (row == _picDataArray.count&&_collectionViewType == EditPicCollectionViewTypeZSGKY) {
        isClickAddButton = YES;
    } else {
        itemModel = _picDataArray[indexPath.row];
    }
    UIViewController *selfvc = [self.edit_delegate getVcWithEditPicItemClickToLookPic];
    if (!selfvc) {
        return ;
    }
    if (_collectionViewType == EditPicCollectionViewTypeJustSelect) {
        //看图
        [self lookPicWithIndex:indexPath.row selfvc:selfvc];
        return;
    }
    
    WEAK
    if (!isClickAddButton) {
        /**
         *  替换 / 查看
         */
        [YBLActionSheetView showActionSheetWithTitles:@[@"替换图片",@"查看图片",@"删除图片"]
                                          handleClick:^(NSInteger index) {
                                              STRONG
                                              if (index == 0) {
                                                  /**
                                                   *  替换图片
                                                   */
                                                  if ([self.edit_delegate respondsToSelector:@selector(editPicItemClickToReplaceImageWithIndexPath:repalceImage:)]) {
                                                      /*
                                                      [[YBLFoundationMethod shareInstance] showDirectPickerWithVC:selfvc pickerDoneHandle:^(UIImage *image) {
                                                          if (image) {
                                                              STRONG
                                                              [self.edit_delegate editPicItemClickToReplaceImageWithIndexPath:indexPath repalceImage:image];
                                                          }

                                                      }];
                                                       */
                                                      [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
                                                          if (image) {
                                                              STRONG
                                                              [self.edit_delegate editPicItemClickToReplaceImageWithIndexPath:indexPath repalceImage:image];
                                                          }
                                                      }
                                                                                                                              isEdit:NO
                                                                                                                         isJustPhoto:YES];
                                                  }
                                              } else if (index == 1) {
                                                  /**
                                                   *  查看图片
                                                   */
                                                  [self lookPicWithIndex:indexPath.row selfvc:selfvc];
                                                  
                                              } else if (index == 2) {
                                                  /**
                                                   *  删除图片
                                                   */
                                                  if ([self.edit_delegate respondsToSelector:@selector(editPicItemClickToDeleteImageWithIndexPath:selectModel:)]) {
                                                      [self.edit_delegate editPicItemClickToDeleteImageWithIndexPath:indexPath selectModel:itemModel];
                                                  }
                                              }
                                          }];
    } else {
        /**
         *  填图
         */
        NSInteger maxCount = [self.edit_delegate getMaxCountBeforeClickAddImageButton];
        NSInteger lessCount = maxCount-self.picDataArray.count;
        if (lessCount==0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图片不能超过%ld张哟~",(long)maxCount]];
            return;
        }
        NSArray *selectAssetsArray = nil;
        if ([self.edit_delegate respondsToSelector:@selector(isHasSelectAssetImage)]) {
            BOOL isSelectAssets = [self.edit_delegate isHasSelectAssetImage];
            if (isSelectAssets) {
                selectAssetsArray = self.selectAssetsArray;
            }
        }
        HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:selectAssetsArray];
        // 设置图像选择代理
        picker.pickerDelegate = self;
        // 设置目标图片尺寸
        picker.targetSize = CGSizeMake(600, 600);
        // 设置最大选择照片数量
        picker.maxPickerCount = lessCount;
        [selfvc presentViewController:picker animated:YES completion:nil];
    }

}

- (void)lookPicWithIndex:(NSInteger)index selfvc:(UIViewController *)selfvc{
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.picDataArray.count; i++) {
        YBLEditPicItemModel *itemModel = self.picDataArray[i];
        if (itemModel.good_Image_url) {
            YBLEditPicItemCell *cell = (YBLEditPicItemCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            KSPhotoItem *item = nil;
            if ([itemModel.good_pure_url rangeOfString:@"http"].location!=NSNotFound&&itemModel.good_pure_url) {
                item = [KSPhotoItem itemWithSourceView:(UIImageView *)cell.iconImageView imageUrl:[NSURL URLWithString:itemModel.good_pure_url]];
            } else if (!itemModel.good_pure_url&&[itemModel.good_Image_url isKindOfClass:[UIImage class]]){
                item = [KSPhotoItem itemWithSourceView:(UIImageView *)cell.iconImageView image:itemModel.good_Image_url];
            }
            [items addObject:item];
        }
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    //                                                  browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:selfvc];
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    NSInteger row = indexPath.row;
    if (self.collectionViewType != EditPicCollectionViewTypeZSGKY) {
        return NO;
    }
    if (row == _picDataArray.count) {
        return NO;
    } else {
        return self.isEditMode;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _picDataArray.count && destinationIndexPath.item < _picDataArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _picDataArray[sourceIndexPath.item];
    [_picDataArray removeObjectAtIndex:sourceIndexPath.item];
    [_picDataArray insertObject:image atIndex:destinationIndexPath.item];
    [self jsReloadData];
}

- (void)imagePickerController:(HMImagePickerController *)picker didFinishSelectedImages:(NSArray<UIImage *> *)images selectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    UIViewController *selfvc = [self.edit_delegate getVcWithEditPicItemClickToLookPic];
    if (!selfvc) {
        return ;
    }
    [selfvc dismissViewControllerAnimated:YES completion:nil];
    self.selectAssetsArray = selectedAssets;
    if ([self.edit_delegate respondsToSelector:@selector(editPicItemClickAddImages:)]) {
        [self.edit_delegate editPicItemClickAddImages:images];
    }
}

@end
