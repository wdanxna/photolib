//
//  AlbumCell.m
//  Photolib
//
//  Created by bravo on 14-6-10.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) configreCell:(Card *)data{
    [self.thumb setImage:data.thumb];
    [self.label setText:data.name];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
