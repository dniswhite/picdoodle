//
//  PicDoodleViewController.h
//  picdoodle
//
//  Created by Dennis White on 4/14/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicToolsManager.h"

@interface PicDoodleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDrawing;

-(void) loadPicture;
-(void) reloadPicture;
-(void) sharePicture;

@property (strong, nonatomic) PicToolsManager *tools;
@property (weak, nonatomic) IBOutlet UIButton *textTools;

- (IBAction)textToolsClick:(id)sender;

@end
