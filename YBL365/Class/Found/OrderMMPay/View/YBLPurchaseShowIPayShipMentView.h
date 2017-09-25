//
//  YBLPurchaseShowIPayShipMentView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowMentType) {
    ShowMentTypeNoAspfit = 0,
    ShowMentTypeAspfit
};

@interface YBLPurchaseShowIPayShipMentView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                 showMentType:(ShowMentType)showMentType
                textDataArray:(NSMutableArray *)textDataArray;

- (void)updateTextDataArray:(NSMutableArray *)textDataArray;

@end
