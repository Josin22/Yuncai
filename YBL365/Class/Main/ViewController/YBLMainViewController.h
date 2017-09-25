//
//  YBLMainViewController.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YBLUserInfosParaModel;

@interface YBLMainViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YBLUserInfosParaModel *userInfosParModel;

@property (nonatomic, strong) UIBarButtonItem *storeSettingButtonItem;
@property (nonatomic, strong) UIBarButtonItem *addButtonItem;
@property (nonatomic, strong) UIBarButtonItem *explainButtonItem;
@property (nonatomic, strong) UIBarButtonItem *shareBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *newsBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *moreBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *remandBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *nextButtonItem;
@property (nonatomic, strong) UIBarButtonItem *historyButtonItem;
@property (nonatomic, strong) UIBarButtonItem *saveButtonItem;


- (void)explainButtonItemClick:(UIBarButtonItem *)btn;
- (void)storeSettingButtonItemClick:(UIBarButtonItem *)btn;
- (void)shareClick:(UIBarButtonItem *)btn;
- (void)newsClick:(UIBarButtonItem *)btn;
- (void)moreClick:(UIBarButtonItem *)btn;
- (void)remandClick:(UIBarButtonItem *)btn;
- (void)nextClick:(UIBarButtonItem *)btn;
- (void)addClick:(UIBarButtonItem *)btn;
- (void)saveClick:(UIBarButtonItem *)btn;

- (void)goback1;

- (void)setMyTranslucent:(BOOL)translucent;

@end
