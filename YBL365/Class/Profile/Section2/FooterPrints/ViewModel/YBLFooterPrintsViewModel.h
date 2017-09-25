//
//  YBLFooterPrintsViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLFooterPrintsViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *footerPrintData;

- (void)reGetFooterPrintsData;

- (void)cleanAllFooterPrintsData;

- (void)deleteFooterPrintsGoodWithID:(NSString *)goodID index:(NSInteger)index;

@end
