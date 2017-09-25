//
//  YBLCountDownButton.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountDownEndBlock)(void);

@interface YBLCountDownButton : UIButton

@property (nonatomic, copy  ) CountDownEndBlock countDownEndBlock;

@property (nonatomic, assign) NSInteger timeCount;

- (void)begainCountDown;

@end
