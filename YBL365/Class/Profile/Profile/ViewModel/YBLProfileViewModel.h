//
//  YBLProfileViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLProfileItemModel : NSObject

@property (nonatomic, copy  ) NSString *profile_item_text;
@property (nonatomic, strong) NSNumber *profile_item_value;
@property (nonatomic, copy  ) NSString *profile_item_self_vc;
@property (nonatomic)         id        profile_item_image_or_value;
@property (nonatomic, strong) NSNumber *profile_orderBadgeValue;

+ (YBLProfileItemModel *)getItemModelWithText:(NSString *)text
                                        image:(id)image
                                        value:(NSNumber *)value
                                      self_vc:(NSString *)self_vc;

@end

@interface YBLProfileViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *profile_cell_data_array;

- (void)pushVCWithItemModel:(YBLProfileItemModel *)itemModel WithNavigationVC:(UIViewController *)profileVC;

@end
