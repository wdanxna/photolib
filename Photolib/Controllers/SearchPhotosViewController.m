//
//  SearchPhotosViewController.m
//  Photolib
//
//  Created by bravo on 14-6-28.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "SearchPhotosViewController.h"
#import "ExportArrayDataSource.h"
#import "WDSearchTableView.h"
#import "AppDelegate.h"
#import "ExportAlbumCell.h"

@interface SearchPhotosViewController ()<WDSearchTableViewDelegate>

@property(nonatomic,strong) ExportArrayDataSource* searchDataSource;
@property(nonatomic,weak) WDSearchTableView* searchController;
@end

@implementation SearchPhotosViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - WDSearchTableView Delegate
-(void) wdsearchview:(WDSearchTableView *)searchview didSelectWithItem:(id)item{
    [self.delegate searchPhotoController:self didSelectItem:item];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchControllerEmbed"]){
        self.searchController = [segue destinationViewController];
        self.searchController.delegate = self;
        NSArray* photos = [[AppDelegate sharedDelegate].Store getPhotos];
        self.searchDataSource = [[ExportArrayDataSource alloc] initWithItems:photos
                                                              cellIdentifier:@"ExportAlbumCell"
                                                          configureCellBlock:^(id cell, id item) {
                                                              [((ExportAlbumCell*)cell) configureCell:item];
        }];
        self.searchDataSource.target = self.searchController;
        self.searchController.tableView.dataSource = self.searchDataSource;
        self.searchController.searchDisplayController.searchResultsDataSource = self.searchDataSource;
    }
}


@end
