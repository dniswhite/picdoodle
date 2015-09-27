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
    
    UIImage * colorMap;
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
    
    colorMap = [self getColorMap];
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
        [self saveColorAtLocation:[touch locationInView:[self imageColorMap]]];
//        [self saveColorAtLocation:currentLocation];
        
        // update brush information
        [self updateBrushDisplay];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:[self view]];

    if (CGRectContainsPoint([[self imageColorMap] frame], currentLocation)) {
        // save color information
        [self saveColorAtLocation:[touch locationInView:[self imageColorMap]]];
        
        // update brush information
        [self updateBrushDisplay];
    }
}

-(UIImage *) getColorMap {
    CGImageRef imageRef = [[[self imageColorMap] image] CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    NSInteger width = [self imageColorMap].frame.size.width;
    NSInteger height = [self imageColorMap].frame.size.height;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width,CGImageGetColorSpace(imageRef), bitmapInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

-(void) saveColorAtLocation: (CGPoint) location {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //CGImageRef cgImage = [[[self imageColorMap] image] CGImage];
    CGImageRef cgImage = [colorMap CGImage];
    
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    if (location.x < 0 || location.y < 0 || location.x > width || location.y > height) {
        NSLog(@"what happened??");
    }
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef contextRef = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), cgImage);
    
    [self.imageColorMap.layer renderInContext:contextRef];
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    NSUInteger byteIndex = (bytesPerRow * (NSUInteger)location.y) + (NSUInteger)location.x * bytesPerPixel;
    
    red = (rawData[byteIndex] * 1.0)/255.0;
    green = (rawData[byteIndex + 1] * 1.0)/255.0;
    blue = (rawData[byteIndex + 2] * 1.0)/255.0;
    alpha = (rawData[byteIndex + 3] * 1.0)/255.0;
    
    free(rawData);
    
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
