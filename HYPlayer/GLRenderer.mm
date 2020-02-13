//
//  GLRenderer.m
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION
#import "GLRenderer.h"
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#import <OpenGLES/EAGLDrawable.h>
#import <UIKit/UIKit.h>
#import "TriangleFilter.h"
#import "ImageFilter.h"
#import "CubeFilter.h"

EAGLContext *context = nullptr;
GLuint frameBuffer;
GLuint colorBuffer;
GLuint depthBuffer;
GLuint stencilBuffer;
GLint backingWidth;
GLint backingHeight;

IFilter *filter = nullptr;

void GLRenderer::viewCreated(void *layer) {
    NSLog(@"viewCreated start");
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    glGenRenderbuffers(1, &depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    
//    filter = new TriangleFilter();
//    filter = new ImageFilter();
    filter = new CubeFilter();
    filter->init();
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    glCullFace(GL_CCW);
    glEnable(GL_BLEND);
}
 
void GLRenderer::viewChanged(int width, int height) {
    glViewport(0, 0, width, height);
    if (filter != nullptr) {
        filter->setNativeWindowSize(width, height);
    }
}

void GLRenderer::viewDoFrame() {
    if (filter != nullptr) {
        glClearColor(0.5f, 0.5f, 0.5f, 1.f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        filter->doFrame();
        [context presentRenderbuffer:GL_RENDERBUFFER];
    }
}

void GLRenderer::viewDestroyed() {
    if (filter != nullptr) {
        delete filter;
    }
}
