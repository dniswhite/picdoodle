//
//  PicToolsViewController.h
//  picdoodle
//
//  Created by Dennis White on 4/15/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicToolsManager.h"

@interface PicToolsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageColorMap;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelectedColor;

- (IBAction)sliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *brushWidth;
@property (weak, nonatomic) IBOutlet UISlider *brushOpacity;

@property (strong, nonatomic) PicToolsManager *tools;

@end
