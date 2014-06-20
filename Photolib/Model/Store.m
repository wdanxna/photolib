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
@property (nonatomic, strong) NSMutableArray* albums;
@property (nonatomic, strong) NSMutableArray* photos;

@end

@implementation Store{
    NSMutableDictionary* _curlevelDic;
    NSMutableDictionary* _mutableData;
}

-(id) init{
    self = [super init];
    if (self){
//        self.rawData = [[NSMutableDictionary alloc] init];
        NSString* json = @"{\"BusinessCards\":{\"date\":null,\"path\":\"BusinessCards\",\"pwd\":null,\"content\":{\"Tough\":{\"date\":null,\"path\":\"BusinessCards/Tough\",\"pwd\":null,\"content\":{\"Gogo\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"Gogo\"}},\"name\":\"Tough\"},\"nihao\":{\"date\":null,\"path\":\"BusinessCards/nihao\",\"pwd\":null,\"content\":{\"Paper\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"Paper\"},\"笔记\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"笔记\"}},\"name\":\"nihao\"},\"这是二\":{\"date\":null,\"path\":\"BusinessCards/这是二\",\"pwd\":null,\"content\":{\"Desjk\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"Desjk\"},\"亨利下\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"亨利下\"},\"封面\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"封面\"},\"胡健聪\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"胡健聪\"},\"粗糙\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"粗糙\"}},\"name\":\"这是二\"},\"魔法\":{\"date\":null,\"path\":\"BusinessCards/魔法\",\"pwd\":null,\"content\":{\"封面\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"封面\"},\"我擦\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/SouthPark.jpg\",\"pwd\":null,\"name\":\"我擦\"},\"Sicp\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/test.jpg\",\"pwd\":null,\"name\":\"Sicp\"},\"Kkk\":{\"date\":null,\"path\":\"https://dl.dropboxusercontent.com/u/75635128/roaringwave.jpg\",\"pwd\":null,\"name\":\"Kkk\"}},\"name\":\"魔法\"}},\"name\":\"BusinessCards\"}}";
        
        self.rawData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        _mutableData = [self deepMutableCopy:self.rawData];
        _curlevelDic = [[NSMutableDictionary alloc] init];
        self.albums = [[NSMutableArray alloc] init];
        self.photos = [[NSMutableArray alloc] init];
        NSLog(@"haha");
    }
    return self;
}

-(NSDictionary*)dataWithPath:(NSString *)path{
    
    NSArray* components = [path componentsSeparatedByString:@"/"];
    NSString* validPath = path;
    if (components.count > 1){
        validPath = [components componentsJoinedByString:@".content."];
    }
    NSDictionary* cur_level_temp = [self.rawData valueForKeyPath:validPath];
    _curlevelDic = [self deepMutableCopy:cur_level_temp];
    if (_curlevelDic && _curlevelDic[@"content"]){
        NSDictionary* contents = _curlevelDic[@"content"];
        [self.albums removeAllObjects];
        [self.photos removeAllObjects];
        for (id key in contents) {
            NSDictionary* item = contents[key];
            if (item){
                BOOL isalbum = item[@"content"]?YES:NO;
                __weak NSMutableArray* whichToInsert = isalbum?self.albums:self.photos;
                UIImage* thumb = [self getThumbWithPath:item[@"path"]];
                NSURL* imagePath = [self getPathWithPath:item[@"path"]];
                [whichToInsert
                 addObject:[[Card alloc] initWithPath:imagePath thumb:thumb name:item[@"name"] album:isalbum]];
            }
        }
    }
    return @{@"AlbumCell":self.albums,
             @"PhotoCell":self.photos};
}

-(NSURL*) getPathWithPath:(NSString*)path{
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

-(NSDictionary*) curdata{
    return @{@"AlbumCell":self.albums,
             @"PhotoCell":self.photos};
}


-(NSArray*) photosArray{
    NSMutableArray* p = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
    for (Card* c in self.photos){
        [p addObject:c.photo];
    }
    return p;
}


-(void) createAlbumAtPath:(NSString*)path name:(NSString*)name passwd:(NSString*)passwd complete:(createAlbumCallback)callback{
    Card* newAlbum = [[Card alloc] initWithPath:[NSURL URLWithString:[path stringByAppendingPathComponent:name]] thumb:nil name:name album:YES];
    NSError* error = nil;
    //do some request here
    [self.albums addObject:newAlbum];
    [_curlevelDic setValue:newAlbum forKeyPath:[NSString stringWithFormat:@"content.%@",name]];
    callback(error);
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
