//
//  YBLGridView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGridView.h"
#import "YBLOrderCommentsItemModel.h"

static NSInteger const  TAG_Grid_image = 9401339711;

@interface YBLGridView ()
{
    NSInteger allCount;
}
@property (nonatomic, assign) GridViewType gridViewType;

@end

@implementation YBLGridView

- (instancetype)initWithFrame:(CGRect)frame
                 gridViewType:(GridViewType)gridViewType{
    
    self = [super initWithFrame:frame];
    if (self) {
        _gridViewType = gridViewType;
        [self createUI];
    }
    return self;
}

- (void)createUI {

    NSLog(@"_gridViewType:%@",@(_gridViewType));
    
    NSInteger lie = 0;
    allCount = 0;
    CGFloat item_space = space/2;
    CGFloat itemWi = (self.width-item_space)/lie;
    
    if (_gridViewType==GridViewTypeOne) {
        
        lie = 1;
        allCount = 1;
        item_space = 0;
        itemWi = self.width/2;
        
    } else if (_gridViewType==GridViewTypeFour){
        
        lie = 2;
        allCount = 4;
        itemWi = (self.width-item_space)/lie;
     
    } else if (_gridViewType==GridViewTypeNineSort) {
        lie = 3;
        allCount = 9;
        itemWi = (self.width-item_space*2)/lie;
    }
    for (NSInteger i = 0; i < allCount; i++) {
        
        NSInteger row = i/lie;
        NSInteger col = i%lie;
        
        UIImageView *gridImageView = [self getImageView];
        gridImageView.tag = TAG_Grid_image+i;
        gridImageView.userInteractionEnabled = YES;
        gridImageView.frame = CGRectMake(col*(itemWi+item_space), row*(item_space+itemWi), itemWi, itemWi);
        [self addSubview:gridImageView];
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
        [gridImageView addGestureRecognizer:tapG];
        
        if (i==allCount-1) {
            self.height = gridImageView.bottom;
        }
    }
}

- (UIImageView *)getImageView{
    
    UIImageView *gridImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    gridImageView.clipsToBounds = YES;
    gridImageView.backgroundColor = YBLColor(220, 220, 220, 1);
    gridImageView.userInteractionEnabled = YES;
    return gridImageView;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    allCount = _dataArray.count;
    if (_dataArray.count==0) {
        self.hidden = YES;
        self.height = 0;
        return;
    } else {
        self.hidden = NO;
    }
    if (_gridViewType==GridViewTypeNineSort) {
        for (int i = 0; i < 9; i++) {
            UIImageView *gridImageView = (UIImageView *)[self viewWithTag:TAG_Grid_image+i];
            gridImageView.hidden = YES;
        }
    }
    for (int i = 0; i < allCount; i++) {
        id value = _dataArray[i];
        UIImageView *gridImageView = (UIImageView *)[self viewWithTag:TAG_Grid_image+i];
        gridImageView.hidden = NO;
        if ([value isKindOfClass:[YBLOrderCommentsItemModel class]]) {
//            YBLOrderCommentsModel *model = (YBLOrderCommentsModel *)value;
            
        } else if ([value isKindOfClass:[NSString class]]){
            [gridImageView js_alpha_setImageWithURL:[NSURL URLWithString:value] placeholderImage:smallImagePlaceholder];
        }
        if (i==allCount-1) {
            self.height = gridImageView.bottom;
        }
    }
    
}

- (void)tapGestureClick:(UITapGestureRecognizer *)sender {

    UIImageView *imageView = (UIImageView *)sender.view;
    
    NSInteger index = imageView.tag-TAG_Grid_image;
    
    BLOCK_EXEC(self.itemClickBlock,index,imageView);
}

@end
