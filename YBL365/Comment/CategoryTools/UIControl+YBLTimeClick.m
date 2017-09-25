//
//  UIControl+YBLTimeClick.m
//  YC168
//
//  Created by 乔同新 on 2017/5/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UIControl+YBLTimeClick.h"

@implementation UIControl (YBLTimeClick)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval )js_acceptEventInterval{
    return [objc_getAssociatedObject(self, &UIControl_acceptEventInterval) doubleValue];
}
- (void)setJs_acceptEventInterval:(NSTimeInterval)js_acceptEventInterval{
    objc_setAssociatedObject(self, &UIControl_acceptEventInterval, @(js_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval )js_acceptEventTime{
    return [objc_getAssociatedObject(self, &UIControl_acceptEventTime) doubleValue];
}
- (void)setJs_acceptEventTime:(NSTimeInterval)js_acceptEventTime{
    objc_setAssociatedObject(self, &UIControl_acceptEventTime, @(js_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//+ (void)load{
//    //获取着两个方法
//    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    SEL sysSEL = @selector(sendAction:to:forEvent:);
//    
//    Method myMethod = class_getInstanceMethod(self, @selector(js_sendAction:to:forEvent:));
//    SEL mySEL = @selector(js_sendAction:to:forEvent:);
//    
//    //添加方法进去
//    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
//    
//    //如果方法已经存在了
//    if (didAddMethod) {
//        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//    }else{
//        method_exchangeImplementations(systemMethod, myMethod);
//        
//    }
//    
//    //----------------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
//    
//}

- (void)js_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.js_acceptEventTime < self.js_acceptEventInterval) {
        return;
    }
    
    if (self.js_acceptEventInterval > 0) {
        self.js_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self js_sendAction:action to:target forEvent:event];
}

@end
