//
//  HTAssetsCollectionViewController.m
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTAssetsCollectionViewController.h"
#import "HTAssetsPickerViewController.h"
#import "HTAssetGridCollectionViewCell.h"
#import "HTDisplayOriginalImageViewController.h"

@interface HTAssetsCollectionViewController ()<PHPhotoLibraryChangeObserver>

@property (nonatomic,weak) HTAssetsPickerViewController *picker;
@property (nonatomic,strong) PHFetchResult *fetchResult;
@property (nonatomic,strong) NSMutableArray<PHAsset *> *selectPhotos;
@property (nonatomic,strong) UIBarButtonItem *rightBar;

@end

@implementation HTAssetsCollectionViewController
{
    CGSize itemSize;
}
static NSString * const reuseIdentifier = @"HTAssetGridCollectionViewCell";

-(HTAssetsPickerViewController *)picker{
    if (_picker == nil) {
        _picker = (HTAssetsPickerViewController *)self.splitViewController.parentViewController;
        
    }
    return _picker;
}
-(NSMutableArray<PHAsset *> *)selectPhotos{
    if (_selectPhotos == nil) {
        _selectPhotos = (NSMutableArray<PHAsset *> *)[[NSMutableArray alloc] init];
    }
    return _selectPhotos;
}
- (instancetype)init
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width/4-1;
    itemSize = CGSizeMake(width, width);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = itemSize;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    if (self = [super initWithCollectionViewLayout:layout])
    {
//        _imageManager = [PHCachingImageManager new];
        
        self.extendedLayoutIncludesOpaqueBars = YES;
        
        self.collectionView.allowsMultipleSelection = NO;
//        [self.collectionView registerClass:CTAssetsGridViewCell.class
//                forCellWithReuseIdentifier:CTAssetsGridViewCellIdentifier];
//        
//        [self.collectionView registerClass:CTAssetsGridViewFooter.class
//                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                       withReuseIdentifier:CTAssetsGridViewFooterIdentifier];
//        
//        [self addNotificationObserver];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundColor];
    [self setupRightNavigationBar];
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"HTAssetGridCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self setupAssets];
    [self registerChangeObserver];
}

-(void)setupBackgroundColor{
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark 导航条右边的完成按钮
-(void)setupRightNavigationBar{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelectPhoto)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.rightBar = rightBar;
    [self.rightBar setTintColor:[UIColor grayColor]];
    self.rightBar.enabled = NO;

}

-(void)setupAssets{
    
    [self.selectPhotos removeAllObjects];
    PHFetchResult *fetchResult =
    [PHAsset fetchAssetsInAssetCollection:self.assetCollection
                                  options:self.picker.assetsFetchOptions];
    self.fetchResult = fetchResult;
    [self.collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTAssetGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [cell updateWithAsset:self.fetchResult[indexPath.item] withItemSize:(CGSize)itemSize withSelectPhasset:self.selectPhotos];
    __weak typeof(self)weakSelf = self;
    cell.selectPhotoCallBack = ^(PHAsset * selectAsset,HTAssetGridCollectionViewCell *cell){
        
        [weakSelf handleImageSelectCell:cell phasset:selectAsset];
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select");
    HTDisplayOriginalImageViewController *originalImageVC = [HTDisplayOriginalImageViewController new];
    originalImageVC.asset = self.fetchResult[indexPath.item];
    [self.navigationController presentViewController:originalImageVC animated:YES completion:nil];
    
}
#pragma mark <UICollectionViewDelegate>

- (void)registerChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)unregisterChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupAssets];
    });
}


#pragma mark 刷新相册内容
-(void)reloadAlbumPhotos{
    [self setupAssets];
    [self.collectionView reloadData];
}
#pragma mark 处理照片被选择
-(void)handleImageSelectCell:(HTAssetGridCollectionViewCell *)cell phasset:(PHAsset *)asset{
    
    if (self.selectPhotos.count >= self.picker.maxSelectedCount&&!cell.hadSelected) {
        NSString *alertMessage = [NSString stringWithFormat:@"您最多选择%ld张照片",self.picker.maxSelectedCount];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    cell.hadSelected = !cell.hadSelected;
    if (cell.hadSelected) {
        [self.selectPhotos addObject:asset];
    }else{
        [self.selectPhotos removeObject:asset];
    }
    
    if (self.selectPhotos.count == 0) {
        self.rightBar.enabled = NO;
        [self.rightBar setTintColor:[UIColor grayColor]];
    }else{
        [self.rightBar setTintColor:[UIColor blueColor]];
        self.rightBar.enabled = YES;
    }
}
#pragma mark 完成选择
-(void)finishSelectPhoto{
    NSMutableArray *tempPhotos = [NSMutableArray new];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = YES;
    for (PHAsset *asset in self.selectPhotos) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [tempPhotos addObject:result];
            
        }];
    }
    [self returnSelectPhotos:tempPhotos];

}
-(void)returnSelectPhotos:(NSArray *)photos{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerViewControllerFinishSelectPhotos:)]) {
        [self.picker.delegate assetsPickerViewControllerFinishSelectPhotos:photos];
    }
    if (self.picker.finishSelectPhotosCallBack) {
        self.picker.finishSelectPhotosCallBack(photos);
    }
}

#pragma mark dealloc
-(void)dealloc{
    [self unregisterChangeObserver];
}
@end
