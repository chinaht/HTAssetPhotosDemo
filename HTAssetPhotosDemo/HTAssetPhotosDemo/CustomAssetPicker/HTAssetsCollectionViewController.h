//
//  HTAssetsCollectionViewController.h
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HTAssetsCollectionViewController : UICollectionViewController

@property (nonatomic,strong) PHAssetCollection *assetCollection;
-(void)reloadAlbumPhotos;

@end
