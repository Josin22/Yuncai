![](http://www.itheima.com/uploads/2015/08/198x57.png)

# HMImagePicker
[![Build Status](https://travis-ci.org/itheima-developer/HMImagePicker.svg?branch=master)](https://travis-ci.org/itheima-developer/HMImagePicker)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/HMImagePicker.svg)](https://img.shields.io/cocoapods/v/HMImagePicker.svg)
[![Platform](https://img.shields.io/cocoapods/p/HMImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/HMImagePicker)

轻量级图像选择框架

## 功能

* 仿微信照片选择功能，支持横竖屏
* 与 `UIImagePickerController` 几乎完全一致的接口调用方式，上手容易
* 使用 `Photos` 框架异步加载图片，内存消耗低

## 屏幕截图

![](https://github.com/itheima-developer/HMImagePicker/blob/master/screenshots/screenshots01.gif?raw=true">)
![](https://github.com/itheima-developer/HMImagePicker/blob/master/screenshots/screenshots02.gif?raw=true">)

## 系统支持

* iOS 8.0+
* Xcode 7.0

## 安装 

### CocoaPods

* 进入终端，`cd` 到项目目录，输入以下命令，建立 `Podfile`

```bash
$ pod init
```

* 在 Podfile 中输入以下内容：

```
platform :ios, '8.0'
use_frameworks!

target 'ProjectName' do
pod 'HMImagePicker'
end
```

* 在终端中输入以下命令，安装或升级 Pod

```bash
# 安装 Pod，第一次使用
$ pod install

# 升级 Pod，后续使用
$ pod update
```

## 使用

### Objective-C

* 导入框架

```objc
@import HMImagePicker;
```

* 在私有扩展中定义属性

```objc
@interface MainViewController () <HMImagePickerControllerDelegate>
/// 选中照片数组
@property (nonatomic) NSArray *images;
/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic) NSArray *selectedAssets;
@end
```

* 在选择按钮的方法中，实现以下代码

```objc
- (IBAction)clickSelectPhotoButton {
    HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];

    // 设置图像选择代理
    picker.pickerDelegate = self;
    // 设置目标图片尺寸
    picker.targetSize = CGSizeMake(600, 600);
    // 设置最大选择照片数量
    picker.maxPickerCount = 9;

    [self presentViewController:picker animated:YES completion:nil];
}
```

* 遵守协议

```objc
@interface MainViewController () <HMImagePickerControllerDelegate>
```

* 实现协议方法

```objc
#pragma mark - HMImagePickerControllerDelegate
- (void)imagePickerController:(HMImagePickerController *)picker
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets {

    // 记录图像，方便在 CollectionView 显示
    self.images = images;
    // 记录选中资源集合，方便再次选择照片定位
    self.selectedAssets = selectedAssets;

    [self.collectionView reloadData];

    [self dismissViewControllerAnimated:YES completion:nil];
}
```
