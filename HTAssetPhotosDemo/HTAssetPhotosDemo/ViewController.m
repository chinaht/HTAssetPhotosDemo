//
//  ViewController.m
//  HTAssetPhotosDemo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 fht. All rights reserved.
//

#import "ViewController.h"
#import "HTAssetsPickerViewController.h"
#import "ShowImageTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *selectImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 选择照片
-(IBAction)chooseImages:(UIButton *)sender{
    HTAssetsPickerViewController *assetVC = [[HTAssetsPickerViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    assetVC.finishSelectPhotosCallBack = ^(NSArray<UIImage *> *photos){
        weakSelf.selectImages = photos;
        [weakSelf.tableView reloadData];
    };
    [self presentViewController:assetVC animated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectImages.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowImageTableViewCell"];
    cell.iconView.image = self.selectImages[indexPath.row];
    return cell;
}
@end
