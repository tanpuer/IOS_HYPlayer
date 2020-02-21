//
//  IDecode.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef IDecode_hpp
#define IDecode_hpp

#include <stdio.h>
#include "circle_av_packet_queue.hpp"
#include "circle_av_frame_queue.hpp"

class IDecode {

public:

    virtual bool init() = 0;

    virtual bool start() = 0;

    virtual bool pause() = 0;

    virtual void release() = 0;

    circle_av_packet_queue *packetQueue;

    circle_av_frame_queue *frameQueue;

    bool isDecoding = false;

};

#endif /* IDecode_hpp */
