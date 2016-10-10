//
//  HTAssetsAlbumTableViewCell.m
//  HelloWorld
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTAssetsAlbumTableViewCell.h"


@interface HTAssetsAlbumTableViewCell ()

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UILabel *photoNameLabel;

@end
@implementation HTAssetsAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupViews];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupViews{
    
    self.photoImageView = [[UIImageView alloc] init];
    self.photoNameLabel = [UILabel new];
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.photoNameLabel];
    
    self.photoImageView.layer.masksToBounds = YES;
    self.photoNameLabel.font = [UIFont systemFontOfSize:17];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
}
-(void)updateWithAssetCollection:(PHAssetCollection *)assetCollection withTargetSize:(CGSize)targetSize{
    self.photoNameLabel.text = assetCollection.localizedTitle;
//    self.imageView.image
    [self.photoNameLabel sizeToFit];
    
    PHFetchResult *fetchResult =
    [PHAsset fetchAssetsInAssetCollection:assetCollection
                                  options:nil];
    
    if (fetchResult.count == 0) {
        
        
        return;
    }
    PHAsset *lastAsset = [fetchResult lastObject];
    [[PHImageManager defaultManager] requestImageForAsset:lastAsset targetSize:targetSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.photoImageView.image = result;
        self.photoImageView.frame = CGRectMake(0, 0, targetSize.width, targetSize.height);
        CGPoint labelCenterPoint = self.photoNameLabel.center;
        labelCenterPoint.y = targetSize.height/2;
        labelCenterPoint.x = targetSize.width+self.photoNameLabel.bounds.size.width/2+5;
        self.photoNameLabel.center = labelCenterPoint;
//        [self setNeedsDisplay];
//        [self setNeedsLayout];
        
    }];
    
}
@end
