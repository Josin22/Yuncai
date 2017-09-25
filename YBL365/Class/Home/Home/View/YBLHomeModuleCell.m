//
//  YBLHomeModuleCell.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeModuleCell.h"
#import "YBLFloorsModel.h"
#import "YBLListBaseModel.h"

typedef NS_ENUM(NSInteger,ModuleItemImageButtonDirection) {
    ModuleItemImageButtonDirectionHorizontal = 0,//水平方向
    ModuleItemImageButtonDirectionVertical  //垂直方向
};

@interface ModuleItemImageButton : UIButton

@property (nonatomic, assign) ModuleItemImageButtonDirection direction;

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

- (instancetype)initWithFrame:(CGRect)frame Direction:(ModuleItemImageButtonDirection)direction;

@end

@implementation ModuleItemImageButton

- (instancetype)initWithFrame:(CGRect)frame Direction:(ModuleItemImageButtonDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        
        _direction = direction;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = BlackTextColor;
    self.textLabel.font = YBLBFont(16);
    [self addSubview:self.textLabel];
    
    self.goodImageView = [[UIImageView alloc] init];
    self.goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.goodImageView];
    
    if (_direction == ModuleItemImageButtonDirectionHorizontal){
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.frame = CGRectMake(5, space, self.width/2-5, 20);
        self.goodImageView.frame = CGRectMake(self.textLabel.right, 0, self.width/2, self.height);
        
    } else {

        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.frame = CGRectMake(5, space, self.width-10, 20);
        self.goodImageView.frame = CGRectMake(0, self.textLabel.bottom+space, self.width, self.height-(self.textLabel.bottom+space));
        
    }
}

@end


static const NSInteger row_tag = 73636;

@interface YBLHomeModuleCell (){
    
    BOOL isRow2;
    BOOL isRow3;
}
@end

@implementation YBLHomeModuleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self createModuleUI];
    }
    return self;
}

- (CGFloat)row2_wi{
    return YBLWindowWidth/2;
}

- (CGFloat)row2_hi{
    return (double)210/375 * [self row2_wi];
}

- (CGFloat)row3_wi{
    return YBLWindowWidth/3;
}

- (CGFloat)row3_hi{
    return (double)300/250 * [self row3_wi];
}


- (void)createModuleUI{

    self.contentView.backgroundColor = [UIColor whiteColor];
    
    isRow2 = NO;
    isRow3 = NO;
}

- (void)updateFloorsModuleArray:(NSMutableArray *)array{
    
    NSArray *rowArray = [YBLMethodTools getRowCount:array.count];
    NSInteger row2 = [rowArray[0] integerValue];
    NSInteger row3 = [rowArray[1] integerValue];
    if (row3==0&&row2==0) {
        return ;
    }
    if (row2 == 0) {
        row2 = 1;
    }
    CGFloat row2Wi = [self row2_wi];
    CGFloat row2Hi = [self row2_hi];
    CGFloat row3Wi = [self row3_wi];
    CGFloat row3Hi = [self row3_hi];

    if (isRow2||isRow3) {
        
        for (id subView in self.contentView.subviews) {
            [subView removeFromSuperview];
        }

    }
    /*content*/
    for (NSInteger i = 0; i<row2*2; i++) {
        isRow2 = YES;
        NSInteger row = i/2;
        NSInteger col = i%2;
        
        YBLFloorsModel *model = array[i];
        ModuleItemImageButton *button = [[ModuleItemImageButton alloc] initWithFrame:CGRectMake(col*row2Wi, row*row2Hi, row2Wi, row2Hi)
                                                                           Direction:ModuleItemImageButtonDirectionHorizontal];
        button.textLabel.text = model.title;
        [button.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.avatar]
                                       placeholderImage:middleImagePlaceholder];
        
        button.tag = row_tag+i;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(rowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    for (NSInteger x = 0; x<row3*3; x++) {
        isRow3 = YES;
        YBLFloorsModel *model = array[x+row2*2];
        NSInteger row = x/3;
        NSInteger col = x%3;
        
        ModuleItemImageButton *button = [[ModuleItemImageButton alloc] initWithFrame:CGRectMake(col*row3Wi, (row2*[self row2_hi])+row*row3Hi, row3Wi, row3Hi)
                                                                           Direction:ModuleItemImageButtonDirectionVertical];
        button.textLabel.text = model.title;
        [button.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.avatar]
                                       placeholderImage:middleImagePlaceholder];
        button.tag = x+row_tag+row2*2;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(rowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    /*line*/
    if (row2!=0&&row2!=1) {
        for (int a = 0; a < row2-1; a++) {
            [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, (a+1)*row2Hi, self.width, 0.5)]];
        }
    }
    if (row3!=0) {
        [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, row2*row2Hi, self.width, 0.5)]];

        for (int a = 0; a < 3; a++) {
            [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(a*[self row3_wi], row2*row2Hi, 0.5,row3Hi)]];
        }
    }
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(self.width/2, 0, 0.5,row2*row2Hi)]];
}

- (void)rowButtonClick:(ModuleItemImageButton *)btn{
    
    NSInteger index = btn.tag-row_tag;
    
    BLOCK_EXEC(self.moduleClickblock,index);
}

- (void)updateItemCellModel:(id)itemModel{
    YBLListCellItemModel *cellModel = (YBLListCellItemModel *)itemModel;
    [self updateFloorsModuleArray:cellModel.valueOfRowItemCellData];
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLListCellItemModel *model =(YBLListCellItemModel *)itemModel;
    return [self getModuleCellHeight:[model.valueOfRowItemCellData count]];
}

+ (CGFloat)getModuleCellHeight:(NSInteger)count{
    
    NSArray *rowArray = [YBLMethodTools getRowCount:count];
    NSInteger row2 = [rowArray[0] integerValue];
    NSInteger row3 = [rowArray[1] integerValue];
    if (row3==0&&row2==0) {
        return 10;
    }
    YBLHomeModuleCell *cell1 = [YBLHomeModuleCell new];
    CGFloat hi = row2*[cell1 row2_hi]+row3*[cell1 row3_hi];;
    
    return hi;
}

@end
