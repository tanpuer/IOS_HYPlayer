//
//  VideoView.m
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION
#import "VideoView.h"
#include "VideoPlayer.hpp"

@interface VideoView()
@property(nonatomic) VideoPlayer *videoPlayer;
@property(nonatomic) int width;
@property(nonatomic) int height;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation VideoView

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
//        _looper = new GLLooper();
//        _looper->sendMessage(_looper->kMsgGLViewCreated, (__bridge void *)eaglLayer);
//        _looper->sendMessage(_looper->kMsgGLViewChanged, _width, _height);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"trailer111" ofType:@"mp4" inDirectory:@""];
        const char* url = [path cStringUsingEncoding:NSASCIIStringEncoding];
        _videoPlayer = new VideoPlayer(url, false);
        _videoPlayer->setNativeWindowCreated((__bridge void *)eaglLayer);
        _videoPlayer->setNativeWindowChanged(_width, _height);
        _videoPlayer->start();
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshEvent)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.preferredFramesPerSecond = 60;
    }
    return self;
}

- (void)refreshEvent {
    if (_videoPlayer != nullptr) {
        _videoPlayer->doFrame();
    }
}

-(void)dealloc {
    delete _videoPlayer;
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
