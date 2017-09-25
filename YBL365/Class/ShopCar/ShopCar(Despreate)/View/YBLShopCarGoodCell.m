//
//  YBLShopCarGoodCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarGoodCell.h"


@interface YBLShopCarGoodCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGFloat panOffSetX;

@end

@implementation YBLShopCarGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubviews {
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.backgroundColor = YBLColor(238, 51, 56, 1.0);
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = YBLFont(14);
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(@70);
    }];
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.backgroundColor = YBLColor(200, 200, 200, 1.0);
    self.collectionButton.titleLabel.numberOfLines = 2;
    [self.collectionButton setTitle:@"移入\n收藏" forState:UIControlStateNormal];
    self.collectionButton.titleLabel.font = YBLFont(14);
    [self.collectionButton setTitleColor:YBLColor(100, 100, 100, 1.0) forState:UIControlStateNormal];
    [self addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(self.deleteButton.mas_left);
        make.width.equalTo(@70);
    }];
    
    
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(@0);
    }];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    panGesture.delegate = self;
    [self.bgView addGestureRecognizer:panGesture];
    
    
    
    self.checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.checkAllButton];
    [self.checkAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@40);
        make.height.with.equalTo(@30);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    self.goodImageView = [[UIImageView alloc] init];
    self.goodImageView.layer.cornerRadius = 3;
    self.goodImageView.layer.borderColor = LINE_BASE_COLOR.CGColor;
    self.goodImageView.layer.borderWidth = 0.5;
    [self.bgView addSubview:self.goodImageView];
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkAllButton.mas_right);
        make.height.width.equalTo(@80);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    self.goodNameLabel = [[UILabel alloc] init];
    self.goodNameLabel.font = YBLFont(13);
    self.goodNameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.goodNameLabel.numberOfLines = 2;
    [self.bgView addSubview:self.goodNameLabel];
    [self.goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-20);
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.top.equalTo(@10);
    }];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = YBLFont(11);
    self.descLabel.textColor = YBLColor(140, 140, 140, 1.0);
    [self.bgView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-20);
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.top.equalTo(self.goodNameLabel.mas_bottom).with.offset(5);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = YBLFont(15);
    self.priceLabel.textColor = [UIColor redColor];
    [self.bgView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.bottom.equalTo(@-10);
    }];
    
#warning 加减号!!!!!!!
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"jdm_btn_addCount"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.height.equalTo(@24);
        make.width.equalTo(@26);
        make.right.equalTo(@-10);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = YBLFont(13);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = YBLColor(70, 70, 70, 1.0);
    [self.bgView addSubview:self.numberLabel];
    self.numberLabel.layer.borderColor = YBLColor(200, 200, 200, 1.0).CGColor;
    self.numberLabel.layer.borderWidth = 0.5;
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@24);
        make.width.equalTo(@35);
    }];
    
    self.subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subtractButton setImage:[UIImage imageNamed:@"jdm_btn_reduceCount"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.subtractButton];
    [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.height.equalTo(@24);
        make.width.equalTo(@26);
        make.right.equalTo(self.numberLabel.mas_left);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)swipeGesture:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    CGPoint point = [gesture translationInView:self.bgView];
    if (state == UIGestureRecognizerStateChanged) {
        CGFloat x = point.x - self.panOffSetX;
        if (x > 3) {
            return;
        }
        if (x < -144) {
            return;
        }
        if (x>0) {
            x = 0;
        }
        if (x < -140) {
            x = -140;
        }
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(@(x));
            make.left.equalTo(@(x));
        }];
    }else if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateFailed){
        if (point.x < -70) {
            point.x = -140;
            self.panOffSetX = 140;
        }else {
            point.x = 0;
            self.panOffSetX = 0;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.right.equalTo(@(point.x));
                make.left.equalTo(@(point.x));
            }];
            [self.bgView layoutIfNeeded];
        }];
    }
}


- (void)reloadBgView {
    if (self.panOffSetX == 0) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
        }];
        [self.bgView layoutIfNeeded];
    }];
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.bgView];
        if (point.x != 0) {
            return YES;
        }
        return NO;
    }
    return NO;
    
}


- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}



@end
