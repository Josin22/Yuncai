//
//  ZJToolBar.h
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJToolBar : UIView
typedef void(^BtnAction)();
@property (strong, readonly, nonatomic) UIButton *doneBtn;
@property (strong, readonly, nonatomic) UIButton *cancelBtn;
@property (strong, readonly, nonatomic) UILabel *label;

- (instancetype)initWithToolbarText:(NSString *)toolBarText cancelAction:(BtnAction)cancelAction doneAction:(BtnAction)doneAction;
@end
