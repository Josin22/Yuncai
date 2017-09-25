//
//  YBLSearchNavView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)();

@interface YBLSearchNavView : UIView

@property (nonatomic, retain) UILabel     *titleLabel;

@property (nonatomic, copy  ) SearchBlock searchBlock;

@end
