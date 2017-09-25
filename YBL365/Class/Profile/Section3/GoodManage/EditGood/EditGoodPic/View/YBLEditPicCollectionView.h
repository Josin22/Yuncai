//
//  YBLEditPicCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxGridViewFlowLayout.h"
#import "YBLEditPicItemModel.h"

@protocol YBLEditPicCollectionViewDelegate <NSObject>

@required
/**
 *  添加图片
 *
 *  @return return value
 */
- (NSInteger)getMaxCountBeforeClickAddImageButton;
/**
 *  查看大图
 *
 *  @return return value
 */
- (UIViewController *)getVcWithEditPicItemClickToLookPic;

@optional
/**
 *  点击删除
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToDeleteImageWithIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel;
/**
 *  替换图片
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToReplaceImageWithIndexPath:(NSIndexPath *)indexPath repalceImage:(UIImage *)repalceImage;
/**
 *  添加图片
 *
 *  @param images images
 */
- (void)editPicItemClickAddImages:(NSArray *)images;
/**
 *  保留已选图
 *
 *  @return return value 
 */
- (BOOL)isHasSelectAssetImage;

@end

typedef NS_ENUM(NSInteger,EditPicCollectionViewType) {
    /**
     *  增删改看移动
     */
    EditPicCollectionViewTypeZSGKY,
    /**
     *  选择
     */
    EditPicCollectionViewTypeJustSelect
};

@interface YBLEditPicCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
               collectionType:(EditPicCollectionViewType)collectionViewType;

@property (nonatomic, weak  ) id<YBLEditPicCollectionViewDelegate> edit_delegate;

@property (nonatomic, weak  ) NSMutableArray *picDataArray;

@property (nonatomic, assign) BOOL isEditMode;

@end
