//
//  ViewController.m
//  Photolib
//
//  Created by bravo on 14-5-22.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "BrowserViewCotroller.h"
#import "DictionaryDataSource.h"
#import "Card.h"
#import "DictionaryDataSource.h"
/*
 This class should handle function himself, like
 navigation, refresh, stack managing..etc
 */
@interface BrowserViewCotroller ()<UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableArray* stack;

@end

@implementation BrowserViewCotroller

@synthesize current_path,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
}

-(void) setDataSource:(id)dataSource{
    self.collectionView.dataSource = dataSource;
}

- (void)setupCollectionView{
    self.stack = [[NSMutableArray alloc] init];
    self.collectionView.allowsMultipleSelection = YES;
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0);
}

-(void) changeSelection:(BOOL)selected onCell:(UICollectionViewCell *)cell{
    NSIndexPath* indexpath = [self.collectionView indexPathForCell:cell];
    [self.collectionView deselectItemAtIndexPath:indexpath animated:NO];
}

-(void) enterCell:(UICollectionViewCell *)cell{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    Card* current_data = [((DictionaryDataSource*)self.collectionView.dataSource) itemAtIndex:indexPath];
    if (current_data.isAlbum){
        [self enterAlbumWithData:current_data atIndexPath:indexPath];
    }else {
        [self viewPhotoWithData:current_data atIndexPath:indexPath];
    }
}

#pragma mark - CollectionView Delegate
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Card* current_data = [((DictionaryDataSource*)self.collectionView.dataSource) itemAtIndex:indexPath];
    
//    if (current_data.isAlbum){
//        [self enterAlbumWithData:current_data atIndexPath:indexPath];
//    }else {
//        [self viewPhotoWithData:current_data atIndexPath:indexPath];
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView numberOfSections] < 2){
        return CGSizeZero;
    }
    return CGSizeMake(self.collectionView.bounds.size.width, 50);
}

-(void) enterAlbumWithData:(Card*)data atIndexPath:(NSIndexPath*)indexPath{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(WDBrowserDelegate)]){
        [self.delegate WDBrowser:self didEnterFolder:data.path.path];
    }
}

-(void) viewPhotoWithData:(Card*)data atIndexPath:(NSIndexPath*)indexPath{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(WDBrowserDelegate)]){
        [self.delegate WDBrowser:self didViewPhotoAtIndex:indexPath.row];
    }
}

-(void) pushPath:(NSString *)path{
    [self.stack addObject:[self.current_path copy]];
    self.current_path = path;
    [self.delegate WDBrowser:self didUpdateDataWithPath:path];
    [self.collectionView reloadData];
}
-(void) back{
    self.current_path = [self.stack lastObject];
    [self.stack removeLastObject];
    [self.delegate WDBrowser:self didUpdateDataWithPath:self.current_path];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
