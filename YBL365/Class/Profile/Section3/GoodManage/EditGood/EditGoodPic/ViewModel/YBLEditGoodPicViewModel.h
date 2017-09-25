//
//  YBLEditGoodPicViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLGoodModel,YBLEditPicItemModel;

typedef NS_ENUM(NSInteger, EditPicType) {
    /**
     *  修改主图
     */
    EditPicTypeMain = 0,
    /**
     *  修改长图
     */
    EditPicTypeDecs
};

@interface YBLEditGoodPicViewModel : NSObject

@property (nonatomic, weak  ) YBLGoodModel *editGoodModel;

@property (nonatomic, assign) EditPicType editPicType;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) NSMutableArray *picDataArray;

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index;

- (RACSignal *)siganlForMutilUploadImage:(NSArray *)imageArray;

- (NSString *)getUpdatePicURLWith:(NSInteger)index;

- (RACSignal *)siganlForDeleteImageWithIndex:(NSInteger)index;

- (RACSignal *)siganlForSortImage;

- (BOOL)isMaxCount;

@end
