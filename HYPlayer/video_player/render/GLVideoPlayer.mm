//
//  GLVideoPlayer.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#include "GLVideoPlayer.h"
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGLDrawable.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>

GLVideoPlayer::GLVideoPlayer(circle_av_frame_queue *frameQueue) {
    this->frameQueue = frameQueue;
}

GLVideoPlayer::~GLVideoPlayer() {
    NSLog(@"GLVideoPlayer destructor");
    if (filter != nullptr) {
        delete filter;
        filter = nullptr;
    }
}

void GLVideoPlayer::surfaceCreated(void *layer) {
    NSLog(@"viewCreated start");
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    glGenRenderbuffers(1, &depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    
    glGenRenderbuffers(1, &colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(__bridge CAEAGLLayer*)layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    NSLog(@"back width and height: %d %d", backingWidth, backingHeight);
    //将绘制缓冲区绑定到帧缓冲区
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorBuffer);
        
    //stencil
//    glGenRenderbuffers(1, &stencilBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, stencilBuffer);
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_ATTACHMENT, backingWidth, backingHeight);
//    glBindRenderbuffer(GL_RENDERBUFFER, 0);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, stencilBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"framebuffer status error");
    }
    glClearColor(0.5f, 0.5f, 0.5f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    NSLog(@"viewCreated success");
        
//        glEnable(GL_CULL_FACE);
//        glEnable(GL_DEPTH_TEST);
//        glDepthFunc(GL_LEQUAL);
//        glCullFace(GL_CCW);
//        glEnable(GL_BLEND);
    this->context = (__bridge void *)context;
}

void GLVideoPlayer::surfaceChanged(int width, int height) {
    glViewport(0, 0, width, height);
    screen_width = width;
    screen_height = height;
}

void GLVideoPlayer::surfaceDestroyed() {
   
}

void GLVideoPlayer::surfaceDoFrame() {
//    ALOGD("GLVideoPlayer surfaceDoFrame");
    if (!started) {
        return;
    }

    if (startTime >= 0) {
        int64_t pts = frameQueue->pullHeadFramePts();
        int64_t currentTime = startTime + index * 16667 / 1000;
        NSLog(@"current Time is %lld %lld %d", currentTime, pts, index);
        if (pts > currentTime) {
            index++;
            return;
        }
    }

    AVFrameData *data = frameQueue->pull();
    if (data != nullptr && data->frame != nullptr) {
        if (startTime < 0) {
            startTime = data->pts;
        }
        currentPos = data->pts;
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        AVFrame *avFrame = data->frame;
        initFilter(avFrame);
        filter->drawFrame(avFrame);
        index++;
        [(__bridge EAGLContext*)context presentRenderbuffer:GL_RENDERBUFFER];
    }
}

void GLVideoPlayer::initFilter(AVFrame *avFrame) {
    if (filter != nullptr) {
        return;
    }
    
    filter = new base_filter();
//    switch (avFrame->format) {
//        case AV_PIX_FMT_YUV420P: {
//            ALOGD("video type is YUV420P!");
//            filter = new base_filter();
//            break;
//        }
//        case AV_PIX_FMT_NV12: {
//            ALOGD("video type is NV12!");
//            filter = new mediacodec_nv12_filter();
//            break;
//        }
//        case AV_PIX_FMT_NV21: {
//            ALOGD("video type is NV21!");
//            filter = new mediacodec_nv21_filter();
//            break;
//        }
//        default: {
//            ALOGE("not support this video type!");
//            break;
//        }
//    }
    if (filter != nullptr) {
        filter->screen_width = screen_width;
        filter->screen_height = screen_height;
        filter->init_program();
    }
}

void GLVideoPlayer::start() {
    started = true;
}

void GLVideoPlayer::pause() {
    started = false;
}

long GLVideoPlayer::getCurrentPos() {
    return currentPos;
}

void GLVideoPlayer::seek() {
    pause();
    currentPos = 0;
    startTime = -1;
    index = 0;
    AVFrameData *data = frameQueue->pull();
    while (!data->seekOver) {
        data->clear();
        data = frameQueue->pull();
    }
    data->clear();
    start();
}
