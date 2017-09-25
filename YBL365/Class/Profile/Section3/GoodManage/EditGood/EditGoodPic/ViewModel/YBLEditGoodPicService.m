//
//  YBLEditGoodPicService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodPicService.h"
#import "YBLEditGoodPicViewController.h"
#import "YBLEditPicCollectionView.h"

#import "YBLEditPicItemModel.h"
#import "KSPhotoBrowser.h"
#import "YBLEditPicItemCell.h"
#import "YBLNavigationViewController.h"
#import "HMImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "YBLFoundationMethod.h"

@interface YBLEditGoodPicService ()<YBLEditPicCollectionViewDelegate>

@property (nonatomic, weak  ) YBLEditGoodPicViewController *Vc;

@property (nonatomic, weak  ) YBLEditGoodPicViewModel *viewModel;

@property (nonatomic, strong) YBLEditPicCollectionView *editPicCollectionView;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation YBLEditGoodPicService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLEditGoodPicViewController *)VC;
        _viewModel = (YBLEditGoodPicViewModel *)viewModel;
        
        [_Vc.view addSubview:self.editPicCollectionView];
       
    }
    return self;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
        _saveButton.bottom = YBLWindowHeight-kNavigationbarHeight;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        WEAK
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [[self.viewModel siganlForSortImage] subscribeError:^(NSError * _Nullable error) {
            } completed:^{
            }];
        }];
        [self.Vc.view addSubview:_saveButton];
    }
    return _saveButton;
}

- (void)resetButton:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.editPicCollectionView.isEditMode = btn.selected;
    self.saveButton.hidden = !btn.selected;
    if (self.saveButton.isHidden) {
        self.editPicCollectionView.height -= self.saveButton.height;
    } else {
        self.editPicCollectionView.height += self.saveButton.height;
    }
}

- (YBLEditPicCollectionView *)editPicCollectionView{
    
    if (!_editPicCollectionView) {
        LxGridViewFlowLayout *layout = [LxGridViewFlowLayout new];
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.footerReferenceSize = CGSizeZero;
        layout.headerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        CGFloat itemWi = (YBLWindowWidth-5*space)/4;
        layout.itemSize = CGSizeMake(itemWi, itemWi+2*space);
        _editPicCollectionView = [[YBLEditPicCollectionView alloc] initWithFrame:[self.Vc.view bounds]
                                                            collectionViewLayout:layout];
        _editPicCollectionView.picDataArray = self.viewModel.picDataArray;
        _editPicCollectionView.height -= kNavigationbarHeight+buttonHeight;
        _editPicCollectionView.edit_delegate = self;
        _editPicCollectionView.isEditMode = YES;
        self.saveButton.hidden = NO;
    }
    return _editPicCollectionView;
}
/**
 *  替换
 *
 *  @param indexPath   indexParth
 *  @param repalceImage repalceImage
 */
- (void)editPicItemClickToReplaceImageWithIndexPath:(NSIndexPath *)indexPath repalceImage:(UIImage *)repalceImage{
    WEAK
    NSInteger row = indexPath.row;
    [[self.viewModel siganlForUploadImage:repalceImage index:row] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.editPicCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    } error:^(NSError * _Nullable error) {
        
    }];
}
/**
 *  删除
 *
 *  @param indexPath  indexParth
 *  @param selectModel selectModel
 */
- (void)editPicItemClickToDeleteImageWithIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel{
    NSInteger row = indexPath.row;
    WEAK
    [[self.viewModel siganlForDeleteImageWithIndex:row] subscribeError:^(NSError * _Nullable error) {
    } completed:^{
        STRONG
        [self.editPicCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.editPicCollectionView jsReloadData];
        });
    }];
}

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

- (UIViewController *)getVcWithEditPicItemClickToLookPic{
    return self.Vc;
}

- (NSInteger)getMaxCountBeforeClickAddImageButton{
    
    return self.viewModel.maxCount;
}

/*
- (void)EditPicCollectionViewItemDidClickAtIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel isClickAddButton:(BOOL)isClickAddButton{
    WEAK
    if (!isClickAddButton) {
 
        if (self.editPicCollectionView.isEditMode) {
            [YBLActionSheetView showActionSheetWithTitles:@[@"删除图片"]
                                              handleClick:^(NSInteger index) {
                                                  STRONG
                                                  NSInteger row = indexPath.row;
                                                  [[self.viewModel siganlForDeleteImageWithIndex:row] subscribeError:^(NSError * _Nullable error) {
                                                  } completed:^{
                                                      STRONG
                                                      [self.editPicCollectionView deleteItemsAtIndexPaths:@[indexPath]];
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          [self.editPicCollectionView jsReloadData];
                                                      });
                                                  }];
                                              }];
            return;
        }
 
        [YBLActionSheetView showActionSheetWithTitles:@[@"替换图片",@"查看图片"]
                                          handleClick:^(NSInteger index) {
                                              STRONG
                                              if (index == 0) {
                                                  [self pushPickerPhotoAtIndexPath:indexPath selectModel:selectModel];
                                              } else {
                                                  [self pushPhotoBrowserVCWithIndex:indexPath.row];
                                              }
                                          }];
    } else {
 
        if ([self.viewModel isMaxCount]) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图片不能超过%ld张哟~",(long)self.viewModel.maxCount]];
            return;
        }
        NSInteger lessCount = self.viewModel.maxCount-self.viewModel.picDataArray.count;
        HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:nil];
        // 设置图像选择代理
        picker.pickerDelegate = self;
        // 设置目标图片尺寸
        picker.targetSize = CGSizeMake(600, 600);
        // 设置最大选择照片数量
        picker.maxPickerCount = lessCount;
        [self.Vc presentViewController:picker animated:YES completion:nil];
    }
}

- (void)pushPickerPhotoAtIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel {
    WEAK
    NSInteger row = indexPath.row;
    [YBLFoundationMethod showDirectPickerWithVC:self.Vc pickerDoneHandle:^(UIImage *image) {
        if (image) {
            STRONG
            [[self.viewModel siganlForUploadImage:image index:row] subscribeNext:^(id  _Nullable x) {
                STRONG
                [self.editPicCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            } error:^(NSError * _Nullable error) {

            }];
        }
    }];

}

 
- (void)pushPhotoBrowserVCWithIndex:(NSInteger)index{
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.viewModel.picDataArray.count; i++) {
        YBLEditPicItemModel *itemModel = self.viewModel.picDataArray[i];
        if (itemModel.good_Image_url) {
            YBLEditPicItemCell *cell = (YBLEditPicItemCell *)[self.editPicCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)cell.iconImageView imageUrl:[NSURL URLWithString:itemModel.good_pure_url]];
            [items addObject:item];
        }
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self.Vc];
}
 
- (void)imagePickerController:(HMImagePickerController *)picker didFinishSelectedImages:(NSArray<UIImage *> *)images selectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    [self.Vc dismissViewControllerAnimated:YES completion:nil];
    
    [[self.viewModel siganlForMutilUploadImage:images] subscribeNext:^(id  _Nullable x) {
        
        NSInteger count = self.viewModel.picDataArray.count;
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.editPicCollectionView insertItemsAtIndexPaths:@[indexp]];
        
    } error:^(NSError * _Nullable error) {
        
    }];
    
}
*/
@end
