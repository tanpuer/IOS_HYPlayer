//
//  GLView.m
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#import "GLView.h"
#include "GLLooper.hpp"

@interface GLView()
@property(nonatomic) GLLooper *looper;
@property(nonatomic) int width;
@property(nonatomic) int height;
@end

@implementation GLView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self.width = 0;
    self.height = 0;
    [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)[self layer];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:NO],
                              kEAGLDrawablePropertyRetainedBacking,
                              kEAGLColorFormatRGB565,
                              kEAGLDrawablePropertyColorFormat,
                              nil];
        [eaglLayer setOpaque:YES];
        [eaglLayer setDrawableProperties:dict];
        _looper = new GLLooper();
        _looper->sendMessage(_looper->kMsgGLViewCreated, (__bridge void *)eaglLayer);
        _looper->sendMessage(_looper->kMsgGLViewChanged, _width, _height);
    }
    return self;
}

-(void)dealloc {
    delete self.looper;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            _width = newFrame.size.width;
            _height = newFrame.size.height;
            NSLog(@"%d %d", _width, _height);
        }
    }
}

@end
