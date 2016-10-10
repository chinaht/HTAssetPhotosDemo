//
//  AppDelegate.h
//  HTAssetPhotosDemo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 fht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

