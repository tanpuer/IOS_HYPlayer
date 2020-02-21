//
//  IDemux.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef IDemux_hpp
#define IDemux_hpp

#include <stdio.h>
#include "circle_av_packet_queue.hpp"

class IDemux {

public:

    virtual bool init(const char *url) = 0;

    virtual bool start() = 0;

    virtual bool pause() = 0;

    virtual bool seek(long pos) = 0;

    virtual void release() = 0;

    bool isDemuxing = false;

    bool isOver = false;

    bool loop = false;

    bool needReset = false;

    circle_av_packet_queue *packetQueue;

    int64_t totalDuration;

};

#endif /* IDemux_hpp */
