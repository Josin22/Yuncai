#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BGModelInfo.h"
#import "BGPropertyInfo.h"
#import "BGSqlite.h"
#import "BGSqliteConfig.h"
#import "BGTool.h"
#import "NSObject+BGModel.h"

FOUNDATION_EXPORT double BGDB_OCVersionNumber;
FOUNDATION_EXPORT const unsigned char BGDB_OCVersionString[];

