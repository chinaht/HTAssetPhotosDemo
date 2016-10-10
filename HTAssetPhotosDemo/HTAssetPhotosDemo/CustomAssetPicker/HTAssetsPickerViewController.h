//
//  HTAssetsPickerViewController.h
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol HTAssetsPickerViewControllerDelegate <NSObject>
@optional
-(void)assetsPickerViewControllerFinishSelectPhotos:(NSArray<UIImage *> *)photos;

@end
@interface HTAssetsPickerViewController : UIViewController

//指定获取相册的类别
@property (nonatomic, copy) NSArray<NSNumber*> *assetCollectionSubtypes;
@property (nonatomic, strong) PHFetchOptions *assetsFetchOptions;
@property(nonatomic,assign) NSInteger maxSelectedCount;
@property (nonatomic,weak) id<HTAssetsPickerViewControllerDelegate> delegate;
@property (nonatomic,strong) void (^finishSelectPhotosCallBack)(NSArray<UIImage *> *photos);

@end
