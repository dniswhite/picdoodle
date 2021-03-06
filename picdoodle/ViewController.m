//
//  ViewController.m
//  picdoodle
//
//  Created by Dennis White on 3/30/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "ViewController.h"
#import "JSImagePickerViewController.h"

@interface ViewController () <JSImagePickerViewControllerDelegate> {
    bool isLineDrawing;
    CGPoint lastLocation;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
}


@end

@implementation ViewController

#pragma mark - viewHandlers

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[[self imageView] layer] setMasksToBounds:YES];
    [[self imageView] setClipsToBounds:YES];

    [self setupDefaultBush];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupDefaultBush {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
}

#pragma mark - imagehandling

- (void) imagePickerDidSelectImage:(UIImage *)image {
    image = [self fixImageRotation:image];
    [[self imageView] setImage:image];
    [[self imageViewDrawing] setImage:NULL];
    [self transferImage];
}

- (IBAction)getPicture:(id)sender {
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (UIImage *)fixImageRotation:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - touchevents

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isLineDrawing = NO;
    
    UITouch *touch = [touches anyObject];
    lastLocation = [touch locationInView:[self view]];

    NSLog(@"user has started to draw %@.", NSStringFromCGPoint(lastLocation));
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (YES == isLineDrawing) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:[self view]];

        NSLog(@"user was drawing a line going from %@ to %@.", NSStringFromCGPoint(lastLocation), NSStringFromCGPoint(currentLocation));

        UIGraphicsBeginImageContextWithOptions([[self imageViewDrawing] frame].size, NO, 1.0f);
        [[[self imageViewDrawing] image] drawInRect:CGRectMake(0, 0, [[self imageViewDrawing] frame].size.width, [[self imageViewDrawing] frame].size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastLocation.x, lastLocation.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentLocation.x, currentLocation.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        [[self imageViewDrawing] setImage:UIGraphicsGetImageFromCurrentImageContext()];
        [[self imageViewDrawing] setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastLocation = currentLocation;
    } else {
        NSLog(@"user just wants a dot on the screen at %@.", NSStringFromCGPoint(lastLocation));

        UIGraphicsBeginImageContextWithOptions([[self imageViewDrawing] frame].size, NO, 1.0f);
        [[[self imageViewDrawing] image] drawInRect:CGRectMake(0, 0, [[self imageViewDrawing] frame].size.width, [[self imageViewDrawing] frame].size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastLocation.x, lastLocation.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastLocation.x, lastLocation.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        [[self imageViewDrawing] setImage:UIGraphicsGetImageFromCurrentImageContext()];
        [[self imageViewDrawing] setAlpha:opacity];
        UIGraphicsEndImageContext();
    }
    
    [self transferImage];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    isLineDrawing = YES;

    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:[self view]];
    
    NSLog(@"user is line drawing moving from %@ to %@", NSStringFromCGPoint(lastLocation), NSStringFromCGPoint(currentLocation));
    
    UIGraphicsBeginImageContextWithOptions([[self imageViewDrawing] frame].size, NO, 1.0f);
    [[[self imageViewDrawing] image] drawInRect:CGRectMake(0, 0, [[self imageViewDrawing] frame].size.width, [[self imageViewDrawing] frame].size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastLocation.x, lastLocation.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentLocation.x, currentLocation.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    [[self imageViewDrawing] setImage:UIGraphicsGetImageFromCurrentImageContext()];
    [[self imageViewDrawing] setAlpha:opacity];
    UIGraphicsEndImageContext();

    lastLocation = currentLocation;
}

-(void) transferImage {
    UIGraphicsBeginImageContextWithOptions([[self imageView] frame].size, NO, 1.0f);
    [[[self imageView] image] drawInRect:CGRectMake(0, 0, [[self imageView] frame].size.width, [[self imageView] frame].size.height)];
    [[[self imageViewDrawing] image] drawInRect:CGRectMake(0, 0, [[self imageViewDrawing] frame].size.width, [[self imageViewDrawing] frame].size.height)];

    [[self imageView] setImage:UIGraphicsGetImageFromCurrentImageContext()];
    [[self imageViewDrawing] setImage:NULL];
    UIGraphicsEndImageContext();
}

@end
