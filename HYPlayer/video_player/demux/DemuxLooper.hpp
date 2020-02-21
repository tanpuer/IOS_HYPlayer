//
//  DemuxLooper.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef DemuxLooper_hpp
#define DemuxLooper_hpp

#include <stdio.h>
#include "Looper.hpp"
#include "IDemux.hpp"
#include "circle_av_packet_queue.hpp"

class DemuxLooper : public Looper {

public:

    enum {
        kMsgDemuxCreated,
        kMsgDemuxSeek,
        kMsgDemuxRelease
    };

    DemuxLooper(circle_av_packet_queue *queue, bool isAudio = true);

    virtual ~DemuxLooper();

    void handleMessage(LooperMessage *msg) override;

    long getTotalDuration();

    IDemux *demux = nullptr;

    void pthreadExit() override;

private:

    circle_av_packet_queue *queue;

    bool isAudio;

};

#endif /* DemuxLooper_hpp */
