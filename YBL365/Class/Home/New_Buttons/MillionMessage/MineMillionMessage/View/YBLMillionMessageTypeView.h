//
//  YBLMillionMessageTypeView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLMillionMessageTypeItemModel : NSObject

@property (nonatomic, copy  ) NSString *itemName;

@property (nonatomic, copy  ) NSString *itemImage;

@end

@protocol YBLMillionMessageTypeDelegate <NSObject>

- (void)millionMessageItemClickModel:(YBLMillionMessageTypeItemModel *)clickModel;

@end

@interface YBLMillionMessageTypeView : UIView

@property (nonatomic, weak  ) id<YBLMillionMessageTypeDelegate> delegate;

@end
