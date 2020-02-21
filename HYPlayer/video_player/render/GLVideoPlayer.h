//
//  GLVideoPlayer.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef GLVideoPlayer_hpp
#define GLVideoPlayer_hpp

#include <stdio.h>

#include "circle_av_frame_queue.hpp"
#import <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#include "base_filter.h"

extern "C" {
#include <libavutil/frame.h>
};

class GLVideoPlayer {

public:
    GLVideoPlayer(circle_av_frame_queue *frameQueue);

    virtual ~GLVideoPlayer();

    void surfaceCreated(void *layer);

    void surfaceChanged(int width, int height);

    void surfaceDestroyed();

    void surfaceDoFrame();

    void start();

    void pause();

    void seek();

    long getCurrentPos();

private:

    circle_av_frame_queue *frameQueue;

    void initFilter(AVFrame *avFrame);

    int screen_width, screen_height;

    bool started = false;

    long currentPos = 0;

    int64_t startTime = -1LL;

    int64_t index = 0;

    GLuint frameBuffer;
    GLuint colorBuffer;
    GLuint depthBuffer;
    GLuint stencilBuffer;
    GLint backingWidth;
    GLint backingHeight;
    base_filter *filter = nullptr;
    void* context = nullptr;

};

#endif /* GLVideoPlayer_hpp */
