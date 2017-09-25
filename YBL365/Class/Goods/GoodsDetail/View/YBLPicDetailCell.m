//
//  YBLPicDetailCell.m
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPicDetailCell.h"
#import "YYWebImage.h"

@implementation PICModel

@end

@interface YBLPicDetailCell ()

@end

@implementation YBLPicDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = YBLColor(248, 248, 248, 1);
    self.goodDetailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 210)];
    [self.contentView addSubview:self.goodDetailImageView];
}

- (void)updateItemCellModel:(id)itemModel{
    
    PICModel *model = (PICModel *)itemModel;
    NSString *url = model.image_url;
    if (url.length==0) {
        return;
    }
    WEAK
    [self.goodDetailImageView js_alpha_setImageWithURL:[NSURL URLWithString:url]
                                      placeholderImage:middleImagePlaceholder
                                             completed:^(UIImage *image,NSURL *imageURL) {
                                                 STRONG
                                                 CGFloat imageWi = image.size.width;
                                                 if (imageWi==0) {
                                                     return ;
                                                 }
                                                 CGFloat scale = (double)image.size.height/imageWi;
                                                 CGFloat height = scale*self.width;
                                                 self.goodDetailImageView.height = height;
                                                 self.goodDetailImageView.image = image;
                                                 model.cell_height = @(height);
                                                 // 让 table view 重新计算高度
                                                 UITableView *tableView = [self getTableView];
                                                 [tableView beginUpdates];
                                                 [tableView endUpdates];
                                                 BLOCK_EXEC(self.picDetailHeightBlock,height)
                                             }];

    
}


@end
