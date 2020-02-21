//
//  circle_av_frame_queue.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef circle_av_frame_queue_hpp
#define circle_av_frame_queue_hpp

#include <stdio.h>
#include "AVFrameData.hpp"
#include <semaphore.h>

#define DEFAULT_AV_FRAME_SIZE 100

struct AVFrameStruct {
    AVFrameData *data;
    AVFrameStruct *next;
};

class circle_av_frame_queue {

public:

    circle_av_frame_queue();

    ~circle_av_frame_queue();

    void push(AVFrameData *frame);

    AVFrameData *pull();

    int64_t pullHeadFramePts();

private:
    pthread_mutex_t mutex;
    pthread_cond_t cond;

    AVFrameStruct *tail;
    AVFrameStruct *head;
    AVFrameStruct *pullCursor;
    AVFrameStruct *pushCursor;

    int currSize = 0;

    bool decodeStarted = false;

};

#endif /* circle_av_frame_queue_hpp */
