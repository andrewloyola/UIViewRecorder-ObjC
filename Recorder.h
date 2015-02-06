//
//  Recorder.h
//
//  Created by Andrew Loyola on 2/5/15.
//  Copyright (c) 2015 Andrew Loyola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Recorder : NSObject

@property (strong, nonatomic) NSString * outputPath;
@property (strong, nonatomic) UIView * view;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL outputJPG;

- (void) start;
- (void) stop;

@end
