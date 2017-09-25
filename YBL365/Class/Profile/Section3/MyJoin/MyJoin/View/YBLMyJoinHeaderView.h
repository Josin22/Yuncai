//
//  YBLMyJoinHeaderView.h
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLMyJoinHeaderView : UIView
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,copy)NSString*name;
@property (nonatomic,copy)NSString*imageName;
-(instancetype)initWithFrame:(CGRect)frame and:(NSString*)name and:(NSString*)pictureName;
@end
