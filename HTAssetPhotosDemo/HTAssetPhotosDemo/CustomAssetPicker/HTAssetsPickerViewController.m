//
//  HTAssetsPickerViewController.m
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTAssetsPickerViewController.h"
#import "HTAssetsAlbumTableViewController.h"
#import "HTAssetsCollectionViewController.h"

@interface HTAssetsPickerViewController ()<UISplitViewControllerDelegate>

@property (strong,nonatomic) UISplitViewController *splitVC;
@property (nonatomic,strong) HTAssetsAlbumTableViewController *assetsAlbumVC;
@property (nonatomic,strong) HTAssetsCollectionViewController *assetCollectionVC;
//是否直接显示相册详情
@property(nonatomic,assign) BOOL shouldCollapseDetailViewController;
@end

@implementation HTAssetsPickerViewController

-(instancetype)init{
    if (self = [super init]) {
        self.shouldCollapseDetailViewController = YES;
        [self initAssetCollectionSubtypes];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.shouldCollapseDetailViewController = YES;
    [self initAssetCollectionSubtypes];
}
- (void)initAssetCollectionSubtypes
{
    _assetCollectionSubtypes =
    @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
      @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
      @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
      @(PHAssetCollectionSubtypeSmartAlbumFavorites),
      @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
//      @(PHAssetCollectionSubtypeSmartAlbumVideos),
//      @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
      @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
      @(PHAssetCollectionSubtypeSmartAlbumBursts),
      @(PHAssetCollectionSubtypeSmartAlbumAllHidden),
      @(PHAssetCollectionSubtypeSmartAlbumGeneric),
      @(PHAssetCollectionSubtypeAlbumRegular),
      @(PHAssetCollectionSubtypeAlbumSyncedAlbum),
      @(PHAssetCollectionSubtypeAlbumSyncedEvent),
      @(PHAssetCollectionSubtypeAlbumSyncedFaces),
      @(PHAssetCollectionSubtypeAlbumImported),
      @(PHAssetCollectionSubtypeAlbumCloudShared)];
    
    // Add iOS 9's new albums
    if ([[PHAsset new] respondsToSelector:@selector(sourceType)])
    {
        NSMutableArray *subtypes = [NSMutableArray arrayWithArray:self.assetCollectionSubtypes];
        [subtypes insertObject:@(PHAssetCollectionSubtypeSmartAlbumSelfPortraits) atIndex:4];
        [subtypes insertObject:@(PHAssetCollectionSubtypeSmartAlbumScreenshots) atIndex:10];
        
        self.assetCollectionSubtypes = [NSArray arrayWithArray:subtypes];
    }
    //默认最多选择9张图片
    self.maxSelectedCount = 9;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupVC];
    [self checkPhotosAuthorization];
}

-(void)checkPhotosAuthorization{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusDenied||status == PHAuthorizationStatusRestricted) {
                [self alertUserSettingPhotoAuthorization];
                return;
            }
            
            [self setupVC];
        });
    }];
}
#pragma mark 提示用户设置相册权限
-(void)alertUserSettingPhotoAuthorization{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请求访问相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSURL *URL = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >=10) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
            };
        }else{
            [[UIApplication sharedApplication] openURL:URL];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)setupVC{
    self.assetsAlbumVC = [HTAssetsAlbumTableViewController new];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:self.assetsAlbumVC];
    self.assetsAlbumVC.title = @"相册";
    self.assetCollectionVC = [HTAssetsCollectionViewController new];
    self.assetsAlbumVC.showsEmptyAlbums = NO;
    self.splitVC = [[UISplitViewController alloc] init];
    self.splitVC.delegate = self;
    self.splitVC.viewControllers = @[masterNav,self.assetCollectionVC];
    [self addChildViewController:self.splitVC];
    self.splitVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.splitVC.view];
    
    [self.splitVC didMoveToParentViewController:self];
    [self setupLeftNavBar];
    [self.assetsAlbumVC reloadUserAlbum];
}


-(void)setupLeftNavBar{
    UIBarButtonItem *leftCancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.assetsAlbumVC.navigationItem.leftBarButtonItem = leftCancelBar;
}
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Split view controller delegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return self.shouldCollapseDetailViewController;
}

@end
