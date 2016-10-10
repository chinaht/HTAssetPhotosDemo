//
//  HTAssetsAlbumTableViewCell.h
//  HelloWorld
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HTAssetsAlbumTableViewCell : UITableViewCell

-(void)updateWithAssetCollection:(PHAssetCollection *)assetCollection withTargetSize:(CGSize)targetSize;

@end
