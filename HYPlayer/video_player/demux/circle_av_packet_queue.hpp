//
//  circle_av_packet_queue.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef circle_av_packet_queue_hpp
#define circle_av_packet_queue_hpp

#include <stdio.h>
#include "AVPacketData.hpp"
#include <semaphore.h>

#define DEFAULT_AV_PACKET_SIZE 100

struct AVPacketStruct {
    AVPacketData *data;
    AVPacketStruct *next;
};

class circle_av_packet_queue {

public:

    circle_av_packet_queue();

    virtual ~circle_av_packet_queue();

    void push(AVPacketData *data);

    AVPacketData* pull();

    AVPacketData* pop();

private:

    pthread_mutex_t mutex;
    pthread_cond_t cond;

    AVPacketStruct *tail;
    AVPacketStruct *head;
    AVPacketStruct *pullCursor;
    AVPacketStruct *pushCursor;

    int currSize = 0;

    bool demuxStarted = false;
};

#endif /* circle_av_packet_queue_hpp */
