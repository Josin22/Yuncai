//
//  YBLLabelsCell.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLLabelsCell : UITableViewCell

@property (nonatomic, retain) UILabel *ttLabel;

@property (nonatomic, strong) UIButton *moreButton;

- (void)handleTextLabel:(NSString *)text;

@end
