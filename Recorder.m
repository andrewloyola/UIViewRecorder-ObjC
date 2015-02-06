//
//  Recorder.m
//
//  Created by Andrew Loyola on 2/5/15.
//  Copyright (c) 2015 Andrew Loyola. All rights reserved.
//

#import "Recorder.h"

@interface Recorder ()


@property (nonatomic) NSInteger imageCounter;

@property (strong, nonatomic) CADisplayLink * displayLink;
@property (strong, nonatomic) NSDate * referenceDate;

@property (strong, nonatomic, readonly) NSURL * applicationDocumentsDirectory;
@property (strong, nonatomic, readonly) NSString * outputPathString;

@end

@implementation Recorder

- (id) init {
    self = [super init];
    if(self){
        self.name = @"image";
        self.imageCounter = 0;
    }
    return self;
}

- (void) start {
    if(!self.view){
        [NSException raise:@"No View Set" format:@"You must set a view before calling start."];
    } else {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.referenceDate = [NSDate date];
    }
}

- (void) stop {
    [self.displayLink invalidate];
    NSTimeInterval seconds = [self.referenceDate timeIntervalSinceNow];
    if((-1 * seconds) > 0){
        NSLog(@"Recorded %ld frames\nDuration:%f seconds\nStored in : %@", (long)self.imageCounter, -1 * seconds, [self outputPathString]);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }
}

- (NSURL *) applicationDocumentsDirectory{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *url = urls[urls.count -1];
    return url;
}

- (void) handleDisplayLink:(CADisplayLink *)displayLink{
    if(self.view){
        [self createImageFromView:self.view];
    }
}

- (NSString *) outputPathString {
    if(self.outputPath){
        return self.outputPath;
    } else {
        return [self.applicationDocumentsDirectory absoluteString];
    }
}

- (void) createImageFromView:(UIView *)captureView{
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, false, 0);
    [captureView drawViewHierarchyInRect:captureView.bounds afterScreenUpdates: false];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    NSString* fileExtension = @"png";
    NSData* data;
    
    if (self.outputJPG) {
        data = UIImageJPEGRepresentation(image, 1);
        fileExtension = @"jpg";
    }
    else {
        data = UIImagePNGRepresentation(image);
    }
    
    NSString* path = [self outputPathString];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@-%ld.%@", self.name, (long)self.imageCounter, fileExtension]];
    
    self.imageCounter = self.imageCounter + 1;
    [data writeToURL:[NSURL URLWithString:path] atomically:NO];
    UIGraphicsEndImageContext();
}

@end
