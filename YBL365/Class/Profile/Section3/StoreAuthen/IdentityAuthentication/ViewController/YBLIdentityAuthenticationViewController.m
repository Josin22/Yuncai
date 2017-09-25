//
//  YBLIdentityAuthenticationViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLIdentityAuthenticationViewController.h"
#import "YBLBaseInfoViewController.h"
#import "YBLUserInfosParaModel.h"

#import "YBLPhotoHeplerViewController.h"

static NSInteger add_button_tag = 8287;

@interface YBLIdentityAuthenticationViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *isSuccessArray;

@property (nonatomic, strong) NSMutableArray *echoImageArray;

@end

@implementation YBLIdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"身份验证";
    
    [self createUI];
    
    self.navigationItem.rightBarButtonItem = self.nextButtonItem;
    
}

- (NSMutableArray *)isSuccessArray{
    
    if (!_isSuccessArray) {
        _isSuccessArray = [NSMutableArray arrayWithCapacity:self.titleArray.count];
        for (int i = 0; i<self.titleArray.count; i++) {
            if ([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected) {
                [_isSuccessArray addObject:@YES];
            } else {
                [_isSuccessArray addObject:@NO];
            }
        }
    }
    return _isSuccessArray;
}

- (void)nextClick:(UIBarButtonItem *)btn{

    BOOL isSuccess = YES;
    for (int i = 0; i < 4; i++) {
        BOOL _isSuccess = [self.isSuccessArray[i] boolValue];
        if (!_isSuccess) {
            isSuccess = NO;
        }
    }
    if (isSuccess) {
        YBLBaseInfoViewController *vc = [YBLBaseInfoViewController new];
        vc.userInfosParModel = self.userInfosParModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还有未上传的图片~"];
    }
}

- (void)createUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    CGFloat imageWi = (scrollView.width/2-4*space)/2;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        NSMutableArray *itemArray = self.titleArray[i];
        
        UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(0, space+i*(imageWi+2*space), scrollView.width, imageWi+2*space)];
        [scrollView addSubview:picView];
        
        UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageButton.frame = CGRectMake(space,space, imageWi, imageWi);
        [addImageButton setBackgroundImage:[UIImage imageNamed:@"bg_photo_add"] forState:UIControlStateNormal];
        addImageButton.tag = add_button_tag+i;
        [addImageButton addTarget:self action:@selector(SelectImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [picView addSubview:addImageButton];
        if ([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected) {
            NSString *imageURL = self.echoImageArray[i];
            [addImageButton sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];
        }
        
        UIImageView *zhanshiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addImageButton.right+2*space, addImageButton.top, addImageButton.width, addImageButton.height)];
        zhanshiImageView.image = [UIImage imageNamed:itemArray[2]];
        [picView addSubview:zhanshiImageView];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(zhanshiImageView.right+2*space, 0, picView.width-(zhanshiImageView.right+2*space), 20)];
        infoLabel.text = itemArray[0];
        infoLabel.font = YBLFont(15);
        infoLabel.textColor = BlackTextColor;
        infoLabel.centerY = picView.height/2;
        [picView addSubview:infoLabel];
        
        [picView addSubview:[YBLMethodTools addLineView:CGRectMake(0, picView.height-0.5, picView.width, 0.5)]];
        if (i == self.titleArray.count-1) {
            scrollView.contentSize = CGSizeMake(scrollView.width, picView.bottom+2*space+picView.height);
            UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, picView.bottom, 200, 30)];
            warningLabel.text = @"* 为必上传图片项";
            warningLabel.textColor = YBLThemeColor;
            warningLabel.font = YBLFont(13);
            [scrollView addSubview:warningLabel];
        }
        
    }

}

- (NSArray *)titleArray{
    
    if (!_titleArray) {
        if ([self.userInfosParModel.usertype isEqualToString:user_type_buyer_key]) {
        
            _titleArray = @[@[@"* 身份证正面照片",@"idpf",@"idpf"]
                        ,@[@"* 身份证反面照片",@"idpb",@"idpb"]
                        ,@[@"* 手持证件拍照片",@"shouchi",@"shouchi"]
                        ,@[@"* 营业执照照片",@"busp",@"busp"]
                        ,@[@"店铺门头照片",@"mentou",@"mentou"]];
            
        } else if ([self.userInfosParModel.usertype isEqualToString:user_type_seller_key]) {
        
            _titleArray = @[@[@"* 身份证正面照片",@"idpf",@"idpf"]
                        ,@[@"* 身份证反面照片",@"idpb",@"idpb"]
                        ,@[@"* 手持证件拍照片",@"shouchi",@"shouchi"]
                        ,@[@"* 营业执照照片",@"busp",@"busp"]
                        ,@[@"厂门照照片",@"mentou",@"chang_mentou"]
                        ,@[@"生产许可证照片",@"shengchan",@"shengchan"]
                        ,@[@"食品流通许可证照片",@"liutong",@"liutong"]];
        }
    }
    return _titleArray;
}

- (NSMutableArray *)echoImageArray{
    
    if (!_echoImageArray) {
        _echoImageArray = [NSMutableArray array];
        YBLUserInfoModel *userInfoModel = [YBLUserManageCenter shareInstance].userInfoModel;
        if ([self.userInfosParModel.usertype isEqualToString:user_type_buyer_key]) {
            
        _echoImageArray = [@[userInfoModel.idpf
                            ,userInfoModel.idpb
                            ,userInfoModel.shouchi
                            ,userInfoModel.busp
                            ,userInfoModel.mentou] mutableCopy];
            
        } else if ([self.userInfosParModel.usertype isEqualToString:user_type_seller_key]) {
            
        _echoImageArray = [@[userInfoModel.idpf,
                             userInfoModel.idpb,
                             userInfoModel.shouchi,
                             userInfoModel.busp,
                             userInfoModel.mentou,
                             userInfoModel.shengchan,
                             userInfoModel.liutong] mutableCopy];
        }
    }
    return _echoImageArray;
}

- (void)SelectImageClick:(UIButton *)btn{
    
    NSInteger button_index = btn.tag-add_button_tag;
    if (btn.currentImage) {
        
        [YBLActionSheetView showActionSheetWithTitles:@[@"删除"] handleClick:^(NSInteger index) {
            if (index == 0) {
                [btn setImage:nil forState:UIControlStateNormal];
                [self.isSuccessArray replaceObjectAtIndex:button_index withObject:@(NO)];
            }
        }];
        
    } else {
        WEAK
        [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *selectImage) {
            STRONG
            if (selectImage) {
                NSString *key = self.titleArray[button_index][1];
                [self uploadPicWithImage:selectImage Key:key index:button_index];
            }
        }
                                                                                isEdit:NO
                                                                           isJustPhoto:NO];
        /*
        [YBLTakePhotoSheetPhotoView showPickerWithVC:self PikerDoneHandle:^(UIImage *image) {
            if (image) {
                NSString *key = self.titleArray[button_index][1];
                [self uploadPicWithImage:image Key:key index:button_index];
            }
        }];
         */
    }

}

- (void)uploadPicWithImage:(UIImage *)image Key:(NSString *)key index:(NSInteger)index{
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                fileConfigWithfileData:thumbImageData
                                name:@"filevalue"
                                fileName:key
                                mimeType:@"image/png"];
    dispatch_async(dispatch_get_main_queue(), ^{
       [SVProgressHUD showWithStatus:@"上传中..."];
    });
    [YBLRequstTools updateRequest:url_setuserinfopricture
                           params:[@{@"key":key} mutableCopy]
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              UIButton *currentButton = (UIButton *)[self.view viewWithTag:add_button_tag+index];
                              [currentButton setImage:image forState:UIControlStateNormal];
                              [self.isSuccessArray replaceObjectAtIndex:index withObject:@(YES)];

                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              
                          }];
    
}

@end
