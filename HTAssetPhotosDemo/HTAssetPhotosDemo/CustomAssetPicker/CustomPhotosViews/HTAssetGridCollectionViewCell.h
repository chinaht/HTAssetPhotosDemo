//
//  HTAssetGridCollectionViewCell.h
//  HelloWorld
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HTAssetGridCollectionViewCell : UICollectionViewCell
//是否选择该图片
@property(nonatomic,assign) BOOL hadSelected;

-(void)updateWithAsset:(PHAsset *)photoAsset withItemSize:(CGSize)itemSize withSelectPhasset:(NSMutableArray *)selectPhassets;

@property (nonatomic,strong) void (^selectPhotoCallBack)(PHAsset * selectAsset,HTAssetGridCollectionViewCell *cell);

@end
