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
#import <OpenGLES/EAGLDrawable.h>
#import <UIKit/UIKit.h>
#import "TriangleFilter.h"
#import "ImageFilter.h"

EAGLContext *context = nullptr;
GLuint frameBuffer;
GLuint renderBuffer;
GLint backingWidth;
GLint backingHeight;

IFilter *filter = nullptr;

void GLRenderer::viewCreated(void *layer) {
    NSLog(@"viewCreated start");
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    
    glGenFramebuffers(1, &frameBuffer);
    //创建绘制缓冲区
    glGenRenderbuffers(1, &renderBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    //h绑定绘制缓冲区到渲染管线
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    //为绘制缓冲区分配内存
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(__bridge CAEAGLLayer*)layer];
    //获取绘制缓冲区的宽高
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    //将绘制缓冲区绑定到帧缓冲区
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"framebuffer status error");
    }
    glClearColor(0.5f, 0.5f, 0.5f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    NSLog(@"viewCreated success");
    
//    filter = new TriangleFilter();
    filter = new ImageFilter();
    filter->init();
}
 
void GLRenderer::viewChanged(int width, int height) {
    glViewport(0, 0, width, height);
    
    filter->doFrame();
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

void GLRenderer::viewDoFrame() {
    
}

void GLRenderer::viewDestroyed() {
    if (filter != nullptr) {
        delete filter;
    }
}
