//
//  HTAssetsAlbumTableViewController.m
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTAssetsAlbumTableViewController.h"
#import "HTAssetsPickerViewController.h"
#import "HTAssetsAlbumTableViewCell.h"
#import "HTAssetsCollectionViewController.h"


#define KALBUMTABLEVIEWCELLHEIGHT 60
@interface HTAssetsAlbumTableViewController ()<PHPhotoLibraryChangeObserver>
@property (strong,nonatomic) NSMutableArray *fetchResults;
@property (nonatomic,strong) NSMutableArray *assetCollections;
@property (nonatomic,weak) HTAssetsPickerViewController *picker;

@end


@implementation HTAssetsAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerChangeObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(HTAssetsPickerViewController *)picker{
    if (_picker == nil) {
        _picker = (HTAssetsPickerViewController *)self.splitViewController.parentViewController;
        
    }
    return _picker;
}
-(void)reloadUserAlbum{
    HTAssetsPickerViewController *pickerVC = (HTAssetsPickerViewController *)self.splitViewController.parentViewController;
    NSMutableArray *fetchResults = [NSMutableArray new];
    
    for (NSNumber *subtypeNumber in pickerVC.assetCollectionSubtypes) {
        
        
        PHAssetCollectionType type = (subtypeNumber.integerValue >= PHAssetCollectionSubtypeSmartAlbumGeneric) ? PHAssetCollectionTypeSmartAlbum : PHAssetCollectionTypeAlbum;
        PHAssetCollectionSubtype subtype = subtypeNumber.integerValue;
        PHFetchResult *fetchResult =
        [PHAssetCollection fetchAssetCollectionsWithType:type
                                                 subtype:subtype
                                                 options:nil];
        
        [fetchResults addObject:fetchResult];
    }
    self.fetchResults = fetchResults;
    
    [self updateAssetCollections];
}

- (void)updateAssetCollections
{
    NSMutableArray *assetCollections = [NSMutableArray new];
    
    for (PHFetchResult *fetchResult in self.fetchResults)
    {
        for (PHAssetCollection *assetCollection in fetchResult)
        {
            BOOL showsAssetCollection = YES;
//            BOOL showsEmptyAlbums = NO;
            if (!self.showsEmptyAlbums)
            {
                PHFetchOptions *options = [PHFetchOptions new];
                options.predicate = self.picker.assetsFetchOptions.predicate;
                
                if ([options respondsToSelector:@selector(setFetchLimit:)])
                    options.fetchLimit = 1;
                
//                NSInteger count = [assetCollection ctassetPikcerCountOfAssetsFetchedWithOptions:options];
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                NSInteger count = result.count;
                showsAssetCollection = (count > 0);
                NSLog(@"count:%ld\n",count);

            }
            
            if (showsAssetCollection)
                [assetCollections addObject:assetCollection];
        }
    }
    
    self.assetCollections = [NSMutableArray arrayWithArray:assetCollections];
    [self.tableView reloadData];
}

#pragma mark - Photo library changed

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedFetchResults = nil;
        
        for (PHFetchResult *fetchResult in self.fetchResults)
        {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:fetchResult];
            
            if (changeDetails)
            {
                if (!updatedFetchResults)
                    updatedFetchResults = [self.fetchResults mutableCopy];
                
                updatedFetchResults[[self.fetchResults indexOfObject:fetchResult]] = changeDetails.fetchResultAfterChanges;
            }
        }
        
        if (updatedFetchResults)
        {
            self.fetchResults = updatedFetchResults;
            [self updateAssetCollections];
//            [self reloadData];
        }
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.assetCollections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KALBUMTABLEVIEWCELLHEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = @"HTAssetsAlbumTableViewCellID";
    
    HTAssetsAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[HTAssetsAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    PHAssetCollection *asset = [self.assetCollections objectAtIndex:indexPath.section];
    [cell updateWithAssetCollection:asset withTargetSize:CGSizeMake(KALBUMTABLEVIEWCELLHEIGHT, KALBUMTABLEVIEWCELLHEIGHT)];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTAssetsCollectionViewController *collectionVC = [[HTAssetsCollectionViewController alloc] init];
    PHAssetCollection *assetCollection = [self.assetCollections objectAtIndex:indexPath.section];
    collectionVC.assetCollection = assetCollection;
    collectionVC.title = assetCollection.localizedTitle;
    [collectionVC reloadAlbumPhotos];
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (void)registerChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)unregisterChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

-(void)dealloc{
    [self unregisterChangeObserver];
}
@end
