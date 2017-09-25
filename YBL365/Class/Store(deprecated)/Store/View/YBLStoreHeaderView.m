//
//  YBLStoreHeaderView.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreHeaderView.h"
#import "YBLStoreLogoView.h"

static NSInteger const BTN_TAG = 101;

@interface YBLStoreHeaderView ()
{
    NSInteger selectBtnTag;
}
@property (nonatomic, strong) UIImageView * backgroundImage;
@property (nonatomic, strong) YBLStoreLogoView * storeLogoView;
@end

@implementation YBLStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
        [self addsubButton];
    }
    return self;
}


- (void)createSubViews {
    UIImage *image = [UIImage imageNamed:@"store_bg"];
    CGFloat hi =  (double)image.size.height/image.size.width *YBLWindowWidth;
    _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, hi)];
    _backgroundImage.image = image;
//    _backgroundImage.backgroundColor = [UIColor blueColor];
    [self addSubview:_backgroundImage];
    
    
    self.storeLogoView = [[YBLStoreLogoView alloc]initWithFrame:CGRectMake(0, self.height-60-50, self.width, 60)];
    [self addSubview:self.storeLogoView];
    
    WEAK
    self.storeLogoView.storeDetailBlock = ^(){
        STRONG
        if (self.storeDetailBlock) {
            self.storeDetailBlock();
        }
    };
    
}

- (void)addsubButton {
    NSArray * titleArray = [NSArray arrayWithObjects:@"全部商品",@"热销",@"上新", nil];
    
    CGFloat buttonW = YBLWindowWidth/(titleArray.count+1);
    CGFloat buttonH = 49;
    
    UIButton * categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.backgroundColor = [UIColor whiteColor];
    categoryButton.frame = CGRectMake(YBLWindowWidth-buttonW, self.height-50, buttonW, buttonH);
    [categoryButton setImage:[UIImage newImageWithNamed:@"store_list_change" size:CGSizeMake(22, 22)] forState:UIControlStateNormal];
    [categoryButton setImage:[UIImage newImageWithNamed:@"store_list" size:CGSizeMake(22, 22)] forState:UIControlStateSelected];
    categoryButton.tag = BTN_TAG+3;
    [categoryButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:categoryButton];
    
    [titleArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+buttonW*idx, self.height-50, buttonW, buttonH);
        button.tag = BTN_TAG + idx;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[NSString stringWithFormat:@"50\n%@",titleArray[idx]] forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(13);
        [button setTitleColor:YBLColor(70, 70, 70, 1) forState:UIControlStateNormal];
        [button setTitleColor:YBLThemeColor forState:UIControlStateSelected];

        if (idx == 0) {
            button.selected = YES;
        }
        
    }];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)buttonClick:(UIButton *)button {
    NSInteger tag = button.tag-BTN_TAG;
    if (tag == 3 ) {
        if (selectBtnTag == 0) {
            button.selected = !button.selected;
            if (self.classifyButtonBlock) {
                self.classifyButtonBlock(tag,button.selected);
            }
        }
    }else {
        if (tag != selectBtnTag) {
            [self changeFrameWithTag:tag];
        }
    }
    
    
}

- (void)changeFrameWithTag:(NSInteger )tag {
    
    if (selectBtnTag != 3) {
        UIButton * agoButton = [self viewWithTag:BTN_TAG + selectBtnTag];
        agoButton.selected = NO;
    }
    UIButton * selectButton = [self viewWithTag:BTN_TAG + tag];
    selectButton.selected = YES;
    selectBtnTag = tag;
    if (self.classifyButtonBlock) {
        self.classifyButtonBlock(tag,selectButton.selected);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectBtnTag != selectIndex) {
        [self changeFrameWithTag:selectIndex];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
