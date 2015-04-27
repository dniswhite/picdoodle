//
//  ViewController.h
//  picdoodle
//
//  Created by Dennis White on 3/30/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController 

- (IBAction)getPicture:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewDrawing;

@end

