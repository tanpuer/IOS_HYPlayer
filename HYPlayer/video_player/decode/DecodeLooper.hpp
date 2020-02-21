//
//  DecodeLooper.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef DecodeLooper_hpp
#define DecodeLooper_hpp

#include <stdio.h>
#include "Looper.hpp"
#include "IDecode.hpp"
#include "circle_av_frame_queue.hpp"

class DecodeLooper : public Looper {

public:

    enum {
        kMsgDecodeCreated,
        kMsgDecodeSeek,
        kMsgDecodeRelease
    };

    DecodeLooper(circle_av_frame_queue *frameQueue, circle_av_packet_queue *packetQueue,
                 bool isAudio, bool usingMediaCodec);

    ~DecodeLooper();

    void handleMessage(LooperMessage *msg) override;

    IDecode *decode;

    void pthreadExit() override;

private:

    circle_av_frame_queue *frameQueue;

    circle_av_packet_queue *packetQueue;

    bool isAudio;

    bool usingMediaCodec;
};

#endif /* DecodeLooper_hpp */
