//
//  GLVideoLooper.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef GLVideoLooper_hpp
#define GLVideoLooper_hpp

#include <stdio.h>
#include "circle_av_frame_queue.hpp"
#include "GLVideoPlayer.h"
#include "Looper.hpp"

class GLVideoLooper : public Looper {

public:

    enum {
        kMsgSurfaceCreated,
        kMsgSurfaceChanged,
        kMsgSurfaceDestroyed,
        kMsgSurfaceStart,
        kMsgSurfacePause,
        kMsgSurfaceSeek,
        kMsgSurfaceDoFrame
    };

    GLVideoLooper(circle_av_frame_queue *frameQueue);

    virtual ~GLVideoLooper();

    virtual void handleMessage(LooperMessage *msg) override;

    long getCurrentPos();

private:
    GLVideoPlayer *glVideoPlayer;

    bool destroyed;

    circle_av_frame_queue *frameQueue;
};

#endif /* GLVideoLooper_hpp */
