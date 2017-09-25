//
//  HMImageGridCell.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMImageGridCell.h"

@implementation HMImageGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedButton];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
    CGFloat offsetX = self.bounds.size.width - _selectedButton.bounds.size.width;
    _selectedButton.frame = CGRectOffset(_selectedButton.bounds, offsetX, 0);
}

#pragma mark - 监听方法
- (void)clickSelectedButton {
    [self.delegate imageGridCell:self didSelected:_selectedButton.selected];
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (HMImageSelectButton *)selectedButton {
    if (_selectedButton == nil) {
        _selectedButton = [[HMImageSelectButton alloc]
                           initWithImageName:@"check_box_default"
                           selectedName:@"check_box_right"];
        [_selectedButton addTarget:self action:@selector(clickSelectedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

@end
