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

@implementation Store

-(id) init{
    self = [super init];
    if (self){
//        self.rawData = [[NSMutableDictionary alloc] init];
        NSString* json = @"{\"BusinessCards\": {\"date\": null, \"path\": \"BusinessCards\", \"pwd\": null, \"content\": {\"Tough\": {\"date\": null, \"path\": \"BusinessCards/Tough\", \"pwd\": null, \"content\": {\"Gogo\": {\"date\": null, \"path\": \"BusinessCards/Tough/Gogo.jpg\", \"pwd\": null, \"name\": \"Gogo\"}}, \"name\": \"Tough\"}, \"nihao\": {\"date\": null, \"path\": \"BusinessCards/nihao\", \"pwd\": null, \"content\": {\"Paper\": {\"date\": null, \"path\": \"BusinessCards/nihao/Paper.jpg\", \"pwd\": null, \"name\": \"Paper\"}, \"\u7b14\u8bb0\": {\"date\": null, \"path\": \"BusinessCards/nihao/\u7b14\u8bb0.jpg\", \"pwd\": null, \"name\": \"\u7b14\u8bb0\"}}, \"name\": \"nihao\"}, \"\u8fd9\u662f\u4e8c\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c\", \"pwd\": null, \"content\": {\"Desjk\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c/Desjk.jpg\", \"pwd\": null, \"name\": \"Desjk\"}, \"\u4ea8\u5229\u4e0b\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c/\u4ea8\u5229\u4e0b.jpg\", \"pwd\": null, \"name\": \"\u4ea8\u5229\u4e0b\"}, \"\u5c01\u9762\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c/\u5c01\u9762.jpg\", \"pwd\": null, \"name\": \"\u5c01\u9762\"}, \"\u80e1\u5065\u806a\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c/\u80e1\u5065\u806a.jpg\", \"pwd\": null, \"name\": \"\u80e1\u5065\u806a\"}, \"\u7c97\u7cd9\": {\"date\": null, \"path\": \"BusinessCards/\u8fd9\u662f\u4e8c/\u7c97\u7cd9.jpg\", \"pwd\": null, \"name\": \"\u7c97\u7cd9\"}}, \"name\": \"\u8fd9\u662f\u4e8c\"}, \"\u9b54\u6cd5\": {\"date\": null, \"path\": \"BusinessCards/\u9b54\u6cd5\", \"pwd\": null, \"content\": {\"\u5c01\u9762\": {\"date\": null, \"path\": \"BusinessCards/\u9b54\u6cd5/\u5c01\u9762.jpg\", \"pwd\": null, \"name\": \"\u5c01\u9762\"}, \"\u6211\u64e6\": {\"date\": null, \"path\": \"BusinessCards/\u9b54\u6cd5/\u6211\u64e6.jpg\", \"pwd\": null, \"name\": \"\u6211\u64e6\"}, \"Sicp\": {\"date\": null, \"path\": \"BusinessCards/\u9b54\u6cd5/Sicp.jpg\", \"pwd\": null, \"name\": \"Sicp\"}, \"Kkk\": {\"date\": null, \"path\": \"BusinessCards/\u9b54\u6cd5/Kkk.jpg\", \"pwd\": null, \"name\": \"Kkk\"}}, \"name\": \"\u9b54\u6cd5\"}}, \"name\": \"BusinessCards\"}}";
        
        self.rawData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        self.albums = [[NSMutableArray alloc] init];
        self.photos = [[NSMutableArray alloc] init];
        NSLog(@"haha");
    }
    return self;
}

-(NSDictionary*)dataWithPath:(NSString *)path{
    NSMutableDictionary* result;
    
    NSArray* components = [path componentsSeparatedByString:@"/"];
    NSString* validPath = path;
    if (components.count > 1){
        validPath = [components componentsJoinedByString:@".content."];
    }
    NSDictionary* curLevel = [self.rawData valueForKeyPath:validPath];
    if (curLevel && curLevel[@"content"]){
        NSDictionary* contents = curLevel[@"content"];
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


-(NSArray*) photosArray{
    NSMutableArray* p = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
    for (Card* c in self.photos){
        [p addObject:c.photo];
    }
    return p;
}

@end
