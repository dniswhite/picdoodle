//
//  PicToolsViewController.m
//  picdoodle
//
//  Created by Dennis White on 4/15/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "PicToolsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PicToolsViewController () {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    CGFloat alpha;
 }

@end

@implementation PicToolsViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Disable automatic adjustment, as we want to occupy all screen real estate
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[[self imageColorMap] layer] setCornerRadius:8.f];
    
    [[[self imageColorMap] layer] setMasksToBounds:YES];
    
    [[[self imageColorMap] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[[self imageColorMap] layer] setBorderWidth:0.5f];
    
    [self setupDefaultBush];
    [self updateBrushDisplay];
}

- (void) setupDefaultBush {
    red = [[self tools] red];
    green = [[self tools] green];
    blue = [[self tools] blue];
    brush = [[self tools] brush];
    opacity = [[self tools] opacity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:[self view]];
    
    if (CGRectContainsPoint([[self imageColorMap] frame], currentLocation)) {
        // save color information
        [self saveColorAtLocation:currentLocation];
        
        // update brush information
        [self updateBrushDisplay];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:[self view]];

    if (CGRectContainsPoint([[self imageColorMap] frame], currentLocation)) {
        // save color information
        [self saveColorAtLocation:currentLocation];
        
        // update brush information
        [self updateBrushDisplay];
    }
}

-(void) saveColorAtLocation: (CGPoint) location {
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef contextRef = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(contextRef, -location.x, -location.y);
    
    [self.imageColorMap.layer renderInContext:contextRef];
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    red = pixel[0]/255.0;
    green = pixel[1]/255.0;
    blue = pixel[2]/255.0;
    alpha = pixel[3]/255.0;
    
    NSLog(@"%f %f %f %f", alpha, red, green, blue);
}

- (IBAction)sliderChanged:(id)sender {
    if (sender == [self brushOpacity]) {
        opacity = [[self brushOpacity] value]/255.0;
    } else if (sender == [self brushWidth]) {
        brush = [[self brushWidth] value];
    }
    
    // update brush information
    [self updateBrushDisplay];
}

-(void) updateBrushDisplay {
    [[self tools] setRed:red];
    [[self tools] setGreen:green];
    [[self tools] setBlue:blue];
    [[self tools] setBrush:brush];
    [[self tools] setOpacity:opacity];
    
    UIGraphicsBeginImageContext(self.imageSelectedColor.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    CGSize pt = self.imageSelectedColor.frame.size;
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),pt.height/2, pt.width/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),pt.height/2, pt.width/2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageSelectedColor.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();}
@end
