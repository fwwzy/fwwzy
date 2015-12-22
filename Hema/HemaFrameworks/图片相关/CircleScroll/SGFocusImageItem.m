//
//  SGFocusImageItem.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize image = _image;
@synthesize tag = _tag;
@synthesize myDic = _myDic;

- (void)dealloc
{
    self.title = nil;
    self.image = nil;
    self.myDic = nil;
    [super dealloc];
}
- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSMutableDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        self.title = [dict objectForKey:@"id"];
        self.image = [dict objectForKey:@"imgurl"];
        self.myDic = dict;
    }
    return self;
}
@end
