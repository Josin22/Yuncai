//
//  YBLMainViewController.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"
#import "TalkingData.h"

@interface YBLMainViewController ()

@end

@implementation YBLMainViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:YES];
    
    NSString *title = [self getSelfVcTitle];
    [TalkingData trackPageEnd:title];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *title = [self getSelfVcTitle];
    [TalkingData trackPageBegin:title];    
}

- (NSString *)getSelfVcTitle{
    
    NSString *selfVcTitle = self.title;
    if (!selfVcTitle) {
        selfVcTitle = self.navigationItem.title;
    }
    if (!selfVcTitle) {
        selfVcTitle = NSStringFromClass([self class]);
    }
    return selfVcTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"back_bt_7h"] style:UIBarButtonItemStyleDone target:self action:@selector(goback1)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)dealloc
{
    NSLog(@"%@---dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)goback1 {
    [self.navigationController popViewControllerAnimated:YES];
}

static bool myTranslucent = YES;

- (void)setMyTranslucent:(BOOL)translucent {
    if (myTranslucent == translucent) {
        return;
    }
    myTranslucent = translucent;
    self.navigationController.navigationBar.translucent = myTranslucent;
    if (translucent) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:YBLColor(255, 255, 255, 0.99) frame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)] forBarMetrics:UIBarMetricsDefault];
    }else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:YBLColor(255, 255, 255, 1.0) frame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)] forBarMetrics:UIBarMetricsDefault];
    }
}

- (UIBarButtonItem *)storeSettingButtonItem{
    
    if (!_storeSettingButtonItem) {
        UIImage *categoryImage = [UIImage newImageWithNamed:@"bar_store_setting" size:(CGSize){21,21}];
        UIBarButtonItem *storeButtonItem = [[UIBarButtonItem alloc] initWithImage:categoryImage
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self
                                                                           action:@selector(storeSettingButtonItemClick:)];
        storeButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _storeSettingButtonItem = storeButtonItem;
    }
    return _storeSettingButtonItem;
}

- (UIBarButtonItem *)explainButtonItem {
    if (!_explainButtonItem) {
        //
        UIImage *categoryImage = [UIImage newImageWithNamed:@"explain_icon" size:(CGSize){23,23}];
        UIBarButtonItem *categoryButtonItem = [[UIBarButtonItem alloc] initWithImage:categoryImage
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(explainButtonItemClick:)];
        categoryButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _explainButtonItem = categoryButtonItem;
    }
    return _explainButtonItem;
}
- (UIBarButtonItem *)addButtonItem {
    if (!_addButtonItem) {
        //
        UIBarButtonItem *add_item = [[UIBarButtonItem alloc] initWithImage:[UIImage newImageWithNamed:@"good_manage_add" size:CGSizeMake(26, 26)]
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(addClick:)];
        add_item.tintColor = YBLTextColor;
        _addButtonItem = add_item;
    }
    return _addButtonItem;
}

- (UIBarButtonItem *)nextButtonItem {
    if (!_nextButtonItem) {
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(nextClick:)];
        _nextButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _nextButtonItem = nextButtonItem;
    }
    return _nextButtonItem;
}


- (UIBarButtonItem *)shareBarButtonItem {
    if (!_shareBarButtonItem) {
        //分享
        UIImage *shareImage = [UIImage newImageWithNamed:@"bar_share" size:(CGSize){22,22}];
        UIBarButtonItem *shareBarButtonItem    = [[UIBarButtonItem alloc] initWithImage:shareImage
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(shareClick:)];
        shareBarButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _shareBarButtonItem = shareBarButtonItem;
    }
    return _shareBarButtonItem;
    
}

- (UIBarButtonItem *)newsBarButtonItem {
    if (!_newsBarButtonItem) {
        //消息
        UIImage *newImage = [UIImage newImageWithNamed:@"bar_news" size:(CGSize){22,22}];
        UIBarButtonItem *newsBarButtonItem    = [[UIBarButtonItem alloc] initWithImage:newImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(newsClick:)];
        newsBarButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _newsBarButtonItem = newsBarButtonItem;
    }
    return _newsBarButtonItem;
}

- (UIBarButtonItem *)moreBarButtonItem {
    if (!_moreBarButtonItem) {
        //更多
        UIImage *moreImage = [UIImage newImageWithNamed:@"bar_more" size:(CGSize){21,21}];
        UIBarButtonItem *moreBarButtonItem    = [[UIBarButtonItem alloc] initWithImage:moreImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(moreClick:)];
        moreBarButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _moreBarButtonItem = moreBarButtonItem;
    }
    return _moreBarButtonItem;
}


- (UIBarButtonItem *)remandBarButtonItem{
    if (!_remandBarButtonItem) {
        UIImage *remandImage = [UIImage newImageWithNamed:@"seckill_remand" size:(CGSize){21,21}];
        UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:remandImage
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(remandClick:)];
        moreBarButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _remandBarButtonItem = moreBarButtonItem;
    }
    return _remandBarButtonItem;
}

- (UIBarButtonItem *)saveButtonItem{
    if (!_saveButtonItem) {
        UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(saveClick:)];
        moreBarButtonItem.tintColor = YBLColor(130, 130, 130, 1);
        _saveButtonItem = moreBarButtonItem;
    }
    return _saveButtonItem;
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
}
- (void)shareClick:(UIBarButtonItem *)btn{
}
- (void)newsClick:(UIBarButtonItem *)btn{
}
- (void)moreClick:(UIBarButtonItem *)btn{
}
- (void)remandClick:(UIBarButtonItem *)btn{
}
- (void)nextClick:(UIBarButtonItem *)btn{
}
- (void)storeSettingButtonItemClick:(UIBarButtonItem *)btn{
}
- (void)addClick:(UIBarButtonItem *)btn{
}
- (void)saveClick:(UIBarButtonItem *)btn{
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


@end
