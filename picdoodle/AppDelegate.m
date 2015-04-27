//
//  AppDelegate.m
//  picdoodle
//
//  Created by Dennis White on 3/30/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "AppDelegate.h"

#import "PicDoodleViewController.h"
#import "PicChooseViewController.h"
#import "PicReloadViewController.h"
#import "PicToolsViewController.h"
#import "PicPostingViewController.h"

@interface AppDelegate ()
<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setTools:[[PicToolsManager alloc] init]];
    
    [self setTabController:[[UITabBarController alloc] init]];
    
    PicDoodleViewController *picDoodle = [[PicDoodleViewController alloc] init];
    [[picDoodle tabBarItem] setTitle:@"Home"];
    [[picDoodle tabBarItem] setImage:[UIImage imageNamed:@"Home-32"]];
    [picDoodle setTools:[self tools]];
    
    PicReloadViewController *picReload = [[PicReloadViewController alloc] init];
    [[picReload tabBarItem] setTitle:@"Undo"];
    [[picReload tabBarItem] setImage:[UIImage imageNamed:@"undo-32"]];

    PicChooseViewController *picChoose = [[PicChooseViewController alloc] init];
    [[picChoose tabBarItem] setTitle:@"Camera"];
    [[picChoose tabBarItem] setImage:[UIImage imageNamed:@"camera-32"]];
    
    PicToolsViewController *picTools = [[PicToolsViewController alloc] initWithNibName:nil bundle:nil];
    [[picTools tabBarItem] setTitle:@"Brush"];
    [[picTools tabBarItem] setImage:[UIImage imageNamed:@"brush-32"]];
    [picTools setTools:[self tools]];
    
    PicPostingViewController *picPosting = [[PicPostingViewController alloc] init];
    [[picPosting tabBarItem] setTitle:@"Share"];
    [[picPosting tabBarItem] setImage:[UIImage imageNamed:@"activity-32"]];

    [[self tabController] setViewControllers:[NSArray arrayWithObjects:picDoodle, picReload, picChoose, picTools, picPosting, nil] animated:YES];

    [[[self tabController] tabBar] setBarTintColor:[UIColor blackColor]];
    [[self tabController] setDelegate:self];

    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];

    [[self tabController] setSelectedIndex:0];
    [[self window] setRootViewController:[self tabController]];

    return YES;
}

//Crystal Cheng
//415 557 5421

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    BOOL allowViewChange = NO;
    
    PicDoodleViewController * pdc = (PicDoodleViewController *)[[[self tabController] viewControllers] firstObject];

    if ([[self tabController] selectedViewController] == viewController) {
        allowViewChange = YES;
    } else if ([viewController isKindOfClass:[PicChooseViewController class]]) {
        [[self tabController] setSelectedIndex:0];
        
        [pdc loadPicture];
    } else if ([viewController isKindOfClass:[PicReloadViewController class]]) {
        [[self tabController] setSelectedIndex:0];
        
        [pdc reloadPicture];
    } else if ([viewController isKindOfClass:[PicToolsViewController class]]) {
        allowViewChange = YES;
    } else if ([viewController isKindOfClass:[PicPostingViewController class]]) {
        [[self tabController] setSelectedIndex:0];

        [pdc sharePicture];
    } else if ([viewController isKindOfClass:[PicDoodleViewController class]]) {
        allowViewChange = YES;
    }
    
    return allowViewChange;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
