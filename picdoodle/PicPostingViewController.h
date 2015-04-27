//
//  PicPostingViewController.h
//  picdoodle
//
//  Created by Dennis White on 4/15/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicPostingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *post;
- (IBAction)share:(id)sender;

@end
