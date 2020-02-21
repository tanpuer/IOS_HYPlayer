//
//  VideoPlayer.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef VideoPlayer_hpp
#define VideoPlayer_hpp

#include <stdio.h>
#include "circle_av_packet_queue.hpp"
#include "DemuxLooper.hpp"
#include "DecodeLooper.hpp"
#include "GLVideoLooper.h"

class VideoPlayer {

public:

    VideoPlayer(const char* path, bool usingMediaCodec);

    virtual ~VideoPlayer();

    void start();

    void pause();

    void seek(long pos);

    void release();

    long getTotalDuration();

    long getCurrentDuration();

    void setNativeWindowCreated(void *layer);

    void setNativeWindowChanged(int width, int height);

    void setNativeWindowDestroyed();

    void doFrame();

private:

    const char *path;

    circle_av_packet_queue *packetQueue;
    circle_av_frame_queue *frameQueue;
    DemuxLooper *demuxLooper;
    DecodeLooper *decodeLooper;
    GLVideoLooper *glVideoLooper;

    bool enable = false;
};

#endif /* VideoPlayer_hpp */
