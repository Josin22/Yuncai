//
//  YBLAddNewGoodViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddNewGoodViewController.h"

static NSInteger add_button_tag = 101;

@interface YBLAddNewGoodViewController ()<UIScrollViewDelegate>

@end

@implementation YBLAddNewGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"申请添加商品";
    
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    //
    [self creatUI];
}

- (void)saveClick:(UIBarButtonItem *)btn{
    
    [SVProgressHUD showSuccessWithStatus:@"申请添加商品成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)creatUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    /* 分类选择 */
    CGFloat itemHi = 50;
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, itemHi)];
    [scrollView addSubview:categoryView];
    UILabel *categotyLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, categoryView.height)];
    categotyLabel.text = @"分类选择 :";
    categotyLabel.textColor = BlackTextColor;
    categotyLabel.font = YBLFont(16);
    [categoryView addSubview:categotyLabel];
    
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(categotyLabel.right, categotyLabel.top, categoryView.width-categotyLabel.right, categotyLabel.height);
    [categoryButton setTitle:@"请选择商品的类目" forState:UIControlStateNormal];
    [categoryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    categoryButton.titleLabel.font = YBLFont(16);
    [categoryButton setTitleColor:YBLColor(194, 194, 194, 1) forState:UIControlStateNormal];
    [categoryButton setTitleColor:BlackTextColor forState:UIControlStateSelected];
    [categoryButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    [categoryButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateSelected];
    [categoryButton setTitleRect:CGRectMake(0, 0, scrollView.width-categotyLabel.right-8-space-5, categotyLabel.height)];
    [categoryButton setImageRect:CGRectMake(scrollView.width-categotyLabel.right-8-space, 12, 8, 16)];
    [categoryView addSubview:categoryButton];
    
    [categoryView addSubview:[YBLMethodTools addLineView:CGRectMake(space, categoryView.height-0.5, categoryView.width, 0.5)]];
    
    /* 商品名称 */
    UIView *goodNameView = [[UIView alloc] initWithFrame:CGRectMake(categoryView.left, categoryView.bottom, categoryView.width, categoryView.height)];
    [scrollView addSubview:goodNameView];
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, categoryView.height)];
    goodNameLabel.text = @"商品名称 :";
    goodNameLabel.textColor = BlackTextColor;
    goodNameLabel.font = YBLFont(16);
    [goodNameView addSubview:goodNameLabel];
    
    UITextField *goodNameTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(goodNameLabel.right, goodNameLabel.top, goodNameView.width-goodNameLabel.right, goodNameLabel.height)];
    goodNameTextFeild.borderStyle = UITextBorderStyleNone;
    goodNameTextFeild.placeholder = @"请输入商品的名称";
    goodNameTextFeild.textColor = BlackTextColor;
    goodNameTextFeild.font = YBLFont(16);
    [goodNameView addSubview:goodNameTextFeild];
    
    [goodNameView addSubview:[YBLMethodTools addLineView:CGRectMake(space, goodNameView.height-0.5, goodNameView.width, 0.5)]];;
    
    /* 规格 */
    UIView *goodSpecView = [[UIView alloc] initWithFrame:CGRectMake(goodNameView.left, goodNameView.bottom, goodNameView.width, goodNameView.height)];
    [scrollView addSubview:goodSpecView];
    UILabel *goodSpecLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 50, goodSpecView.height)];
    goodSpecLabel.text = @"规格 :";
    goodSpecLabel.textColor = BlackTextColor;
    goodSpecLabel.font = YBLFont(16);
    [goodSpecView addSubview:goodSpecLabel];
    
    UITextField *goodSpecTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(goodSpecLabel.right, goodSpecLabel.top, goodSpecView.width-goodSpecLabel.right, goodSpecLabel.height)];
    goodSpecTextFeild.borderStyle = UITextBorderStyleNone;
    goodSpecTextFeild.placeholder = @"请输入产品的规格,例如:500ml*6瓶/箱";
    goodSpecTextFeild.textColor = BlackTextColor;
    goodSpecTextFeild.font = YBLFont(16);
    [goodSpecView addSubview:goodSpecTextFeild];
    
    [goodSpecView addSubview:[YBLMethodTools addLineView:CGRectMake(space, goodSpecView.height-0.5, goodSpecView.width, 0.5)]];;
    
    /* 商品条形码 */
    UIView *goodQrcView = [[UIView alloc] initWithFrame:CGRectMake(goodSpecView.left, goodSpecView.bottom, goodSpecView.width, goodSpecView.height)];
    [scrollView addSubview:goodQrcView];
    UILabel *goodQrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, goodQrcView.height)];
    goodQrcLabel.text = @"商品条码 :";
    goodQrcLabel.textColor = BlackTextColor;
    goodQrcLabel.font = YBLFont(16);
    [goodQrcView addSubview:goodQrcLabel];
    
    UITextField *goodQrcTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(goodQrcLabel.right, goodQrcLabel.top, goodQrcView.width-goodQrcLabel.right, goodQrcLabel.height)];
    goodQrcTextFeild.borderStyle = UITextBorderStyleNone;
    goodQrcTextFeild.placeholder = @"请输入商品的条形码";
    goodQrcTextFeild.textColor = BlackTextColor;
    goodQrcTextFeild.font = YBLFont(16);
    [goodQrcView addSubview:goodQrcTextFeild];
    
    [goodQrcView addSubview:[YBLMethodTools addLineView:CGRectMake(0, goodQrcView.height-0.5, goodQrcView.width, 0.5)]];;
    
    /*图片*/
    NSArray *titleArray = @[@"商品正面图片",@"商品背面图片",@"商品45度图片",@"商品名称图片",@"商品条形码图片",@"商品详情页"];
//    NSArray *zhanshiImageArray = @[@"商品正面图片",@"商品背面图片",@"商品45度图片",@"商品名称图片",@"商品条形码图片",@"商品详情页"];

    CGFloat imageWi = (scrollView.width/2-4*space)/2;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(0, goodQrcView.bottom+i*(imageWi+2*space), goodQrcView.width, imageWi+2*space)];
        [scrollView addSubview:picView];
        
        UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageButton.frame = CGRectMake(space,space, imageWi, imageWi);
        [addImageButton setBackgroundImage:[UIImage imageNamed:@"bg_photo_add"] forState:UIControlStateNormal];
        addImageButton.tag = add_button_tag+i;
        [picView addSubview:addImageButton];
        
        UIImageView *zhanshiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addImageButton.right+2*space, addImageButton.top, addImageButton.width, addImageButton.height)];
        zhanshiImageView.layer.borderColor = YBLColor(237, 141, 62, 1).CGColor;
        zhanshiImageView.layer.borderWidth = 1.5;
        zhanshiImageView.image = [UIImage imageNamed:smallImagePlaceholder];
        [picView addSubview:zhanshiImageView];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(zhanshiImageView.right+2*space, 0, picView.width-(zhanshiImageView.right+2*space), 20)];
        infoLabel.text = titleArray[i];
        infoLabel.font = YBLFont(16);
        infoLabel.textColor = BlackTextColor;
        infoLabel.centerY = picView.height/2;
        [picView addSubview:infoLabel];
        
        [picView addSubview:[YBLMethodTools addLineView:CGRectMake(0, picView.height-0.5, picView.width, 0.5)]];
        if (i == titleArray.count-1) {
            scrollView.contentSize = CGSizeMake(scrollView.width, picView.bottom+2*space+picView.height);
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

@end
