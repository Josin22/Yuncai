//
//  YBLSelectAddressView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLBaseView.h"

@class YBLAddressModel;

typedef void(^SelectAddressViewDoneBlock)(YBLAddressModel *selectAddressModel);

@interface YBLSelectAddressView : YBLBaseView

+ (void)showSelectAddressViewFromVC:(UIViewController *)Vc
                        addressData:(NSMutableArray *)addressData
                       addressGenre:(AddressGenre)addressGenre
                         doneHandle:(SelectAddressViewDoneBlock)block;

@end
