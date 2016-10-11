//
//  HTDisplayOriginalImageViewController.m
//  HelloWorld
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTDisplayOriginalImageViewController.h"

@interface HTDisplayOriginalImageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation HTDisplayOriginalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self addTapGesture];
}

-(void)setupViews{
    self.backScrollView = [[UIScrollView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.imageView];
    
    self.backScrollView.delegate = self;
    self.backScrollView.maximumZoomScale = 2;
    self.backScrollView.minimumZoomScale = 1;
    self.backScrollView.frame = [UIScreen mainScreen].bounds;
    self.imageView.frame = self.backScrollView.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToExitCurrentVC)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.imageView.image = result;
    }];
}

-(void)tapToExitCurrentVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
