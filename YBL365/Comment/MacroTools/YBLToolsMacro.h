//
//  YBLToolsMacro.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#ifndef YBLToolsMacro_h
#define YBLToolsMacro_h

/**
 *  预处理工具
 */

//** DEBUG LOG *********************************************************************************
#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

///结束svp的展示
#define NOSHOWSVP(time) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
[SVProgressHUD dismiss]; \
});
#define SVPSHOWWITHSTATUS(info); [SVProgressHUD showWithStatus:info];
#define SVPSHOWINFO(info)  [SVProgressHUD showInfoWithStatus:info];
#define SVPSHOWSUCCESS(info) [SVProgressHUD showSuccessWithStatus:info];
#define SVPSHOWERROR(info) [SVProgressHUD showErrorWithStatus:info];

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)

#define pi 3.14159265359
///度数
#define DEGREES_TO_RADIANS(degress) ((pi * degress)/180)

//宏定义检测block是否可用
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

//首页导航栏滚动距离
#define NAVBAR_CHANGE_POINT 50
//tabbar 5个item 基础tag
#define TABBAR_ITEM_BASETAG 900

#define SCREEN_SCALE ((double)[ UIScreen mainScreen ].bounds.size.width/320)

#define SCREEN_SCALE_Iphone6 ((double)[ UIScreen mainScreen ].bounds.size.width/375)

//主题色
#define YBLThemeColor           YBLThemeColorAlp(1)

#define YBLThemeColorAlp(x)     YBLColor(249, 49, 52, x)

#define YBLTextColor            YBLColor(126, 126, 126, 1)

#define YBLTextLightColor       YBLColor(170, 170, 170, 1)

#define YBLLineColor            YBLColor(230, 230, 230, 1)

#define YBLLineColorAlph(x)     YBLColor(230, 230, 230, x)

#define YBLViewBGColor          VIEW_BASE_COLOR

#define YBBGViewColor           VIEW_BASE_COLOR

//基础线的设置
#define LINE_BASE_COLOR YBLLineColor
//页面的基础背景色
#define VIEW_BASE_COLOR YBLColor(243, 243, 246, 1.0)
//tableView的区头 区尾 基本颜色
#define TABLEVIEW_HEAD_FOOT_COLOR YBLColor(242, 242, 242, 1.0)
//云采红
#define YBL_RED YBLColor(239, 51, 56, 1.0)

#define WEAK  @weakify(self);

#define STRONG  @strongify(self);

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define YBLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BlackTextColor YBLColor(40,40,40,1)

#define YBLFont(font) [UIFont systemFontOfSize:(font)]

#define YBLBFont(font) [UIFont boldSystemFontOfSize:(font)]

#define YBLWindowWidth ([[UIScreen mainScreen] bounds].size.width)

#define YBLWindowHeight ([[UIScreen mainScreen] bounds].size.height)

#define YBLWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

#define ZOOM_SCALE (float) ([[UIScreen mainScreen] bounds].size.width/320.0)

#define Iphone6ScaleWidth YBLWindowWidth/375.0

#define Iphone6ScaleHeight YBLWindowHeight/667.0

// 在宏的参数前加上一个#，宏的参数会自动转换成c语言的字符串
#define MRKeyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))

//** 加载xib ***********************************************************************************
#define YBL_LoadNib(x) [[NSBundle mainBundle] loadNibNamed:@(x) owner:nil options:nil][0]

#define YBL_Nib(x) [UINib nibWithNibName:x bundle:nil]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

//** 沙盒路径 ***********************************************************************************
#define YBL_PATH_OF_APP_HOME                NSHomeDirectory()
#define YBL_PATH_OF_APP_TEMP                NSTemporaryDirectory()
#define YBL_PATH_OF_APP_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// PNG JPG 图片路径
#define YBL_GetImagePathFromBundle(NAME)            [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:nil]
#define YBL_GetExtPathFromBundle(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif

#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif


//颜色
#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
//#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

#endif /* YBLToolsMacro_h */
