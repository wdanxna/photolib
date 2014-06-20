//
//  MainViewController.m
//  Photolib
//
//  Created by bravo on 14-6-11.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "MainViewController.h"
#import "BrowserViewCotroller.h"
#import "DictionaryDataSource.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "Card.h"
#import "itemCell.h"
#import "AlbumCell.h"
#import "PhotoCell.h"
#import "MWPhotoBrowser.h"
#import "PhotoDataSource.h"
#import "NewAlbumController.h"
/*
 This class should work as embaded browser's delegate.
 */
@interface MainViewController ()<WDBrowserDelegate,NewAlbumDelegate>
@property (weak, nonatomic) IBOutlet UIView *browserView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,weak) BrowserViewCotroller* browser;
@property (nonatomic,strong) DictionaryDataSource* dicDataSource;
@property (nonatomic,strong) PhotoDataSource* photoDataSource;
@property (nonatomic,strong) MWPhotoBrowser* photoViewer;

@end

@implementation MainViewController{
    BOOL backHidden;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBackHidden:YES];
    NSDictionary* initData = [[AppDelegate sharedDelegate].Store dataAtFirstLevel];
    self.dicDataSource = [[DictionaryDataSource alloc]
                                        initWithItems:initData cellIdentifier:@[@"AlbumCell",@"PhotoCell"]
                                        configureCellBlock:^(itemCell* cell, Card* item) {
                                            cell.browserController = self.browser;
                                            [cell configreCell:item];}];
    
    self.browser = [[self childViewControllers] firstObject];
    self.browser.current_path = [[AppDelegate sharedDelegate].Store rootPath];
    [self.browser setDataSource:self.dicDataSource];
    self.browser.delegate = self;
    
    NSArray* photos = [[AppDelegate sharedDelegate].Store photosArray];
    self.photoDataSource = [[PhotoDataSource alloc] initWithItems:photos];
    self.photoViewer = [[MWPhotoBrowser alloc] initWithDelegate:self.photoDataSource];
    self.photoViewer.displayActionButton = YES;
    self.photoViewer.displayNavArrows = YES;
    self.photoViewer.alwaysShowControls = YES;
}

-(void) backBackHidden:(BOOL)hidden{
    if (backHidden == hidden) return;
    backHidden = hidden;
    NSMutableArray *rightButtons  = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (hidden){
        [rightButtons removeObject:self.backButton];
    }else{
        [rightButtons addObject:self.backButton];
    }
    [self.navigationItem setLeftBarButtonItems:rightButtons];
}

#pragma mark - WDBrowser
-(void) WDBrowser:(BrowserViewCotroller *)browser didEnterFolder:(NSString *)path isRoot:(BOOL)root{
    NSLog(@"Did enter Folder: %@", path);
    NSArray* coms = [path componentsSeparatedByString:@"/"];
    self.navigationItem.title = [coms lastObject];
    if (root){
        [self backBackHidden:YES];
    }else{
        [self backBackHidden:NO];
    }
}

-(void) WDBrowser:(BrowserViewCotroller *)browser didViewPhotoAtIndex:(NSInteger)index{
    NSLog(@"view photo at: %d",index);
    [self startPhotoViewAtIndex:index];
}

-(void) WDBrowser:(BrowserViewCotroller *)browser didUpdateDataWithPath:(NSString *)path{
    NSDictionary* newData = [[AppDelegate sharedDelegate].Store dataWithPath:path];
    [self.dicDataSource updateItems:newData];
    [self.photoDataSource updateItems:[[AppDelegate sharedDelegate].Store photosArray]];
}


#pragma mark -
#pragma mark - NewAlbum
-(void) newAlbumController:(NewAlbumController *)controller didDoneWithName:(NSString *)name passwd:(NSString *)passwd {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"create album:%@ pwd: %@",name,passwd);
    [[AppDelegate sharedDelegate].Store createAlbumAtPath:self.browser.current_path name:name passwd:passwd complete:^(NSError* error){
        NSDictionary* curData = [[AppDelegate sharedDelegate].Store curdata];
        [self.dicDataSource updateItems:curData];
        [self.browser refresh];
    }];
}
-(void) newAlbumControllerDidCancle:(NewAlbumController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) startPhotoViewAtIndex:(NSInteger)index{
    //issue here: https://github.com/mwaterfall/MWPhotoBrowser/issues/208
    MWPhotoBrowser* temp_b = [[MWPhotoBrowser alloc] initWithDelegate:self.photoDataSource];
    temp_b.displayActionButton = YES;
    temp_b.displayNavArrows = YES;
    temp_b.alwaysShowControls = YES;
    [temp_b setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:temp_b animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)performBack:(id)sender{
    [self.browser back];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"hi");
    if ([segue.identifier isEqualToString:@"newAlbum"]){
        ((NewAlbumController*)((UINavigationController*)[segue destinationViewController]).viewControllers[0]).delegate = self;
    }
}


@end
