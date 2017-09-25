//
//  YBLOrderMakeCommentsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLOrderCommentsItemModel.h"

@interface YBLOrderMakeCommentsViewModel : NSObject

@property (nonatomic, assign) CGFloat ratingCount;

@property (nonatomic, assign) BOOL isNiMing;

@property (nonatomic, strong) NSMutableArray *picDataArray;

@property (nonatomic, strong) YBLOrderCommentsItemModel *commentsModel;

- (RACSignal *)siganlForCreateCommentsWithContentText:(NSString *)contentText;

- (RACSignal *)siganlForMutilUploadImage:(NSArray *)imageArray;

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index;

@end
