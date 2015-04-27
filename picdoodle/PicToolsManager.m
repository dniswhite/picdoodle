//
//  PicToolsManager.m
//  picdoodle
//
//  Created by Dennis White on 4/18/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "PicToolsManager.h"

@implementation PicToolsManager

-(id) init
{
    if (self = [super init]) {
        // init stuff here
        [self setupDefaultBush];
    }
    
    return self;
}

- (void) setupDefaultBush {
    [self setRed: 0.0/255.0];
    [self setGreen: 0.0/255.0];
    [self setBlue: 0.0/255.0];
    [self setBrush: 10.0];
    [self setOpacity:1.0];
}

@end
