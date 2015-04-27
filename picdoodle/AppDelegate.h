//
//  AppDelegate.h
//  picdoodle
//
//  Created by Dennis White on 3/30/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicToolsManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabController;

@property (strong, nonatomic) PicToolsManager *tools;

@end

