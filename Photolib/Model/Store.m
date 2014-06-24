//
//  Store.m
//  Photolib
//
//  Created by bravo on 14-6-11.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "Store.h"
#import "Card.h"

@interface Store()
@property (nonatomic,strong) NSDictionary* rawData;
@property (nonatomic, strong) NSArray* albums;
@property (nonatomic, strong) NSArray* photos;

@end

@implementation Store{
    NSString* _curlevelPath;
    NSMutableDictionary* _curlevelDic;
    NSMutableDictionary* _mutableData;
    
    NSMutableArray* _curAlbums;
    NSMutableArray* _curPhotos;
}

-(id) init{
    self = [super init];
    if (self){
//        self.rawData = [[NSMutableDictionary alloc] init];
        NSString* json = @"{\"BusinessCards\":{\"date\":null,\"path\":\"BusinessCards\",\"pwd\":null,\"content\":{\"Tough\":{\"date\":null,\"path\":\"BusinessCards/Tough\",\"pwd\":null,\"content\":{\"Gogo\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"Gogo\"}},\"name\":\"Tough\"},\"nihao\":{\"date\":null,\"path\":\"BusinessCards/nihao\",\"pwd\":null,\"content\":{\"Paper\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"Paper\"},\"笔记\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"笔记\"}},\"name\":\"nihao\"},\"这是二\":{\"date\":null,\"path\":\"BusinessCards/这是二\",\"pwd\":null,\"content\":{\"Desjk\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"Desjk\"},\"亨利下\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"亨利下\"},\"封面\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"封面\"},\"胡健聪\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"胡健聪\"},\"粗糙\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"粗糙\"}},\"name\":\"这是二\"},\"魔法\":{\"date\":null,\"path\":\"BusinessCards/魔法\",\"pwd\":null,\"content\":{\"封面\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"封面\"},\"我擦\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"我擦\"},\"Sicp\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"Sicp\"},\"Kkk\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"Kkk\"}},\"name\":\"魔法\"}},\"name\":\"BusinessCards\"}}";
        
        self.rawData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        self.albums = [self allAlbums:self.rawData[@"BusinessCards"]];
        _mutableData = [self deepMutableCopy:self.rawData];
        _curlevelDic = [[NSMutableDictionary alloc] init];
        _curAlbums = [[NSMutableArray alloc] init];
        _curPhotos = [[NSMutableArray alloc] init];
        NSLog(@"haha");
    }
    return self;
}

-(NSArray*)allAlbums:(NSDictionary*)data{
    if (!data[@"content"]) return nil;
    NSMutableArray* result = [[NSMutableArray alloc] init];
    [result addObject:data[@"path"]];
    for (NSString* key in data[@"content"]){
        [result addObjectsFromArray:[self allAlbums:data[@"content"][key]]];
    }
    return result;
}

-(NSArray*)getAlbums{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:self.albums.count];
    for (NSString* path in self.albums){
        Card* newCard = [[Card alloc] initWithPath:[self nsurlWithPath:path] thumb:[self getThumbWithPath:path] name:path album:YES];
        [result addObject:newCard];
    }
    return result;
}


-(NSDictionary*)dataWithPath:(NSString *)path{
    if ([path isEqualToString:_curlevelPath]){
        return [self currentLevelData];
    }
    _curlevelPath = path;
    NSString* validPath = [self path2IndexPaths:path];
    NSDictionary* cur_level_temp = [self.rawData valueForKeyPath:validPath];
    _curlevelDic = [self deepMutableCopy:cur_level_temp];
    if (_curlevelDic && _curlevelDic[@"content"]){
        NSDictionary* contents = _curlevelDic[@"content"];
        [_curAlbums removeAllObjects];
        [_curPhotos removeAllObjects];
        for (id key in contents) {
            NSDictionary* item = contents[key];
            if (item){
                BOOL isalbum = item[@"content"]?YES:NO;
                __weak NSMutableArray* whichToInsert = isalbum?_curAlbums:_curPhotos;
                UIImage* thumb = [self getThumbWithPath:item[@"path"]];
                NSURL* imagePath = [self nsurlWithPath:item[@"path"]];
                [whichToInsert
                 addObject:[[Card alloc] initWithPath:imagePath thumb:thumb name:item[@"name"] album:isalbum]];
            }
        }
    }
    return @{@"AlbumCell":_curAlbums,
             @"PhotoCell":_curPhotos};
}

-(NSDictionary*) currentLevelData{
    return @{@"AlbumCell":_curAlbums,
             @"PhotoCell":_curPhotos};
}

-(NSString*) path2IndexPaths:(NSString*)path{
    NSArray* components = [path componentsSeparatedByString:@"/"];
    NSString* indexPaths = path;
    if (components.count > 1){
        indexPaths = [components componentsJoinedByString:@".content."];
    }
    return indexPaths;
}

-(NSURL*) nsurlWithPath:(NSString*)path{
//    return [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg"];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:path];
}

-(UIImage*) getThumbWithPath:(NSString*)path{
    
    return [UIImage imageNamed:@"test.jpg"];//for test
}

-(NSString*) rootPath{
    return [[self.rawData allKeys] firstObject];
}

-(NSDictionary*)dataAtFirstLevel{
    return [self dataWithPath:[self rootPath]];
}


-(NSArray*) photosArray{
    NSMutableArray* p = [[NSMutableArray alloc] initWithCapacity:_curPhotos.count];
    for (Card* c in _curPhotos){
        [p addObject:c.photo];
    }
    return p;
}


-(void) createAlbumAtPath:(NSString*)path name:(NSString*)name passwd:(NSString*)passwd complete:(createAlbumCallback)callback{
    NSString* encodedPath = [[path stringByAppendingPathComponent:name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    Card* newAlbum = [[Card alloc] initWithPath:[NSURL URLWithString:encodedPath] thumb:nil name:name album:YES];
    NSError* error = nil;
    //do some request here
    [_curAlbums addObject:newAlbum];
    NSDictionary* temp = @{@"name":newAlbum.name,
                           @"path":newAlbum.path.path,
                           @"pwd":newAlbum.password,
                           @"date":[NSNull null],
                           @"content":@{}};
    NSMutableDictionary* mut_new = [self deepMutableCopy:temp];
    
    [_curlevelDic setValue:mut_new forKeyPath:[NSString stringWithFormat:@"content.%@",name]];
    
    NSString* newIndexPaths = [self path2IndexPaths:_curlevelPath];
//    newIndexPaths = [NSString stringWithFormat:@"%@.content",newIndexPaths];
    [_mutableData setValue:_curlevelDic forKeyPath:newIndexPaths];
    self.rawData = [[NSDictionary alloc] initWithDictionary:_mutableData];
    self.albums = [self allAlbums:self.rawData[@"BusinessCards"]];
    callback(error);
}

-(void) removeItemWithNames:(NSArray *)names complete:(deleteItemCallback)callback{
    [_curlevelDic[@"content"] removeObjectsForKeys:names];
    [_mutableData setValue:_curlevelDic forKeyPath:[self path2IndexPaths:_curlevelPath]];
    self.rawData = [[NSDictionary alloc] initWithDictionary:_mutableData];
    self.albums = [self allAlbums:self.rawData[@"BusinessCards"]];
    callback(nil);
}

-(NSMutableDictionary*) deepMutableCopy:(NSDictionary*)dict{
    //warning: this function works only if your dict is
    //a pure (nested)dictionary, not nested with other kind of imutable
    //type like: NSArray, use with caution.
    //ps: if you want a deep copy function support all mutable type
    //its better to check dictionaryhelper authored by issac
    NSMutableDictionary* cur = [dict mutableCopy];
    for (id key in dict){
        if ([cur[key] isKindOfClass:[NSDictionary class]]){
            cur[key] = [self deepMutableCopy:cur[key]];
        }
    }
    return cur;
}
@end
