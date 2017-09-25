//
//  YBLWriteInfoViewController.h
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef void(^WriteInfoValueBlock)(NSString *value);

@interface YBLWriteInfoViewController : YBLMainViewController

@property (nonatomic, copy) WriteInfoValueBlock writeInfoValueBlock;

@property (nonatomic, copy) NSString *infoString;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic,) id undefineValue;

@property (nonatomic, copy) NSString *textValue;

@end
