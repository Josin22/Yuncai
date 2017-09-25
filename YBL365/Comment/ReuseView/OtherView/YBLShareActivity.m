//
//  YBLShareActivity.m
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShareActivity.h"

@implementation YBLShareActivity

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type withShareContext:(NSArray *)shareContexts{
    
    _title = title;
    _image = image;
    _url = url;
    _type = type;
    _shareContexts = shareContexts;
    
    return self;
    
}

+ (UIActivityCategory)activityCategory{
    
    // 决定在UIActivityViewController中显示的位置，最上面是AirDrop，中间是Share，下面是Action
    return UIActivityCategoryAction;
}

- (NSString *)activityType{
    return _type;
}

- (NSString *)activityTitle {
    return _title;
}

- (UIImage *)_activityImage {
    //这个得注意，当self.activityCategory = UIActivityCategoryAction时，系统默认会渲染图片，所以不能重写为 - (UIImage *)activityImage {return _image;}
    return _image;
}

- (NSURL *)activityUrl{
    return _url;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据
}

- (void)performActivity {
    
    //用safari打开网址
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
    
    //这里就可以关联外面的app进行分享操作了
    //也可以进行一些数据的保存等操作
    //操作的最后必须使用下面方法告诉系统分享结束了
    [self activityDidFinish:YES];
    
}

@end
