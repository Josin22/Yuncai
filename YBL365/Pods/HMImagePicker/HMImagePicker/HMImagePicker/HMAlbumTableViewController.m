//
//  HMAlbumTableViewController.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/26.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMAlbumTableViewController.h"
#import "HMAlbum.h"
#import "HMAlbumTableViewCell.h"
#import "HMImageGridViewController.h"

static NSString *const HMAlbumTableViewCellIdentifier = @"HMAlbumTableViewCellIdentifier";

@interface HMAlbumTableViewController ()

@end

@implementation HMAlbumTableViewController {
    /// 相册资源集合
    NSArray<HMAlbum *> *_assetCollection;
    /// 选中素材数组
    NSMutableArray <PHAsset *> *_selectedAssets;
}

- (instancetype)initWithSelectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets {
    self = [super init];
    if (self) {
        _selectedAssets = selectedAssets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏
    self.title = @"照片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    
    // 获取相册
    [self fetchAssetCollectionWithCompletion:^(NSArray<HMAlbum *> *assetCollection, BOOL isDenied) {
        if (isDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有权限访问相册，请先在设置程序中授权访问" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
        _assetCollection = assetCollection;
        
        [self.tableView reloadData];
        
        // 默认显示第一个相册
        if (_assetCollection.count > 0) {
            HMImageGridViewController *grid = [[HMImageGridViewController alloc]
                                               initWithAlbum:_assetCollection[0]
                                               selectedAssets:_selectedAssets
                                               maxPickerCount:_maxPickerCount];
            
            [self.navigationController pushViewController:grid animated:NO];
        }
    }];
    
    // 设置表格
    [self.tableView registerClass:[HMAlbumTableViewCell class] forCellReuseIdentifier:HMAlbumTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
}

- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 加载相册
- (void)fetchAssetCollectionWithCompletion:(void (^)(NSArray<HMAlbum *> *, BOOL))completion {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            [self fetchResultWithCompletion:completion];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self fetchResultWithCompletion:completion];
            }];
        }
            break;
        default:
            NSLog(@"拒绝访问相册");
            completion(nil, YES);
            
            break;
    }
}

- (void)fetchResultWithCompletion:(void (^)(NSArray<HMAlbum *> *, BOOL))completion {
    // 相机胶卷
    PHFetchResult *userLibrary = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                  options:nil];
    
    // 同步相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:NO]];
    
    PHFetchResult *syncedAlbum = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                  subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum
                                  options:options];
    
    NSMutableArray *result = [NSMutableArray array];
    [userLibrary enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[HMAlbum albumWithAssetCollection:obj]];
    }];
    [syncedAlbum enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[HMAlbum albumWithAssetCollection:obj]];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{ completion(result.copy, NO); });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HMAlbumTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.album = _assetCollection[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HMAlbum *album = _assetCollection[indexPath.row];
    HMImageGridViewController *grid = [[HMImageGridViewController alloc]
                                       initWithAlbum:album
                                       selectedAssets:_selectedAssets
                                       maxPickerCount:_maxPickerCount];
    
    [self.navigationController pushViewController:grid animated:YES];
}

@end
