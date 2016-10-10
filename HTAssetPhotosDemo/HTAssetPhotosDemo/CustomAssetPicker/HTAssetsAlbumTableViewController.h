//
//  HTAssetsAlbumTableViewController.h
//  HelloWorld
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAssetsAlbumTableViewController : UITableViewController
@property(nonatomic,assign) BOOL showsEmptyAlbums;

-(void)reloadUserAlbum;
@end
