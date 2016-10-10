//
//  HTAssetGridCollectionViewCell.m
//  HelloWorld
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTAssetGridCollectionViewCell.h"

@interface HTAssetGridCollectionViewCell ()

@property (nonatomic,weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic,weak) IBOutlet UIButton *selectPhotoBtn;
@property (nonatomic,strong) NSMutableArray *selectPhassets;
@property (nonatomic,strong) PHAsset *photoAsset;
@end
@implementation HTAssetGridCollectionViewCell

-(instancetype)init{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HTAssetGridCollectionViewCell" owner:self options:nil] firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectPhotoBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3];
    self.selectPhotoBtn.layer.masksToBounds = YES;
    self.selectPhotoBtn.layer.cornerRadius = 12;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
}
-(void)updateWithAsset:(PHAsset *)photoAsset withItemSize:(CGSize)itemSize withSelectPhasset:(NSMutableArray *)selectPhassets{
    self.selectPhassets = selectPhassets;
    self.photoAsset = photoAsset;
    self.hadSelected = NO;
    for (PHAsset *selectAsset in selectPhassets) {
        if (selectAsset == photoAsset) {
            self.hadSelected = YES;
            break;
        }
    }
    [[PHImageManager defaultManager] requestImageForAsset:photoAsset targetSize:itemSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.photoImageView.image = result;
    }];
}
-(void)setHadSelected:(BOOL)hadSelected{
    _hadSelected = hadSelected;
    UIImage *btnImage;
    if (_hadSelected) {
        btnImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Check_photo_sel.png" ofType:nil]];

    }else{
        btnImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Check_photo_unSel.png" ofType:nil]];
    }
    [self.selectPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}
-(IBAction)selectPhotoBtn:(UIButton *)sender{
//    self.hadSelected = !self.hadSelected;
//    if (self.hadSelected) {
//        [self.selectPhassets addObject:self.photoAsset];
//    }else{
//        [self.selectPhassets removeObject:self.photoAsset];
//    }
    if (self.selectPhotoCallBack) {
        self.selectPhotoCallBack(self.photoAsset,self);
    }
}
@end
