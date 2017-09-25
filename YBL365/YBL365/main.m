
//
//  main.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#if DEBUG
//#import <FBAllocationTracker/FBAllocationTrackerManager.h>
#endif

int main(int argc, char * argv[]) {
#if DEBUG
//    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
//    [[FBAllocationTrackerManager sharedManager] enableGenerations];
#endif
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
