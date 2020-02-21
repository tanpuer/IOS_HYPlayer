//
//  DecodeLooper.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "DecodeLooper.hpp"
#include "FFVideoDecode.h"

DecodeLooper::DecodeLooper(circle_av_frame_queue *frameQueue, circle_av_packet_queue *packetQueue,
                           bool isAudio, bool usingMediaCodec) {
    this->frameQueue = frameQueue;
    this->packetQueue = packetQueue;
    this->isAudio = isAudio;
    this->usingMediaCodec = usingMediaCodec;
}

DecodeLooper::~DecodeLooper() {

}

void DecodeLooper::handleMessage(Looper::LooperMessage *msg) {
    switch (msg->what) {
        case kMsgDecodeCreated: {
//            if (isAudio) {
//                ALOGD("audio decoder create");
//                decode = new FFDecode();
//            } else {
//                ALOGD("video decoder create");
//                decode = new FFVideoDecode(usingMediaCodec);
//            }
            decode = new FFVideoDecode(usingMediaCodec);
            decode->packetQueue = packetQueue;
            decode->frameQueue = frameQueue;
            decode->init();
            decode->isDecoding = true;
            decode->start();
            break;
        }
        case kMsgDecodeSeek: {
            break;
        }
        case kMsgDecodeRelease: {
            decode->release();
            quit();
            break;
        }
        default: {
        }
    }
}

void DecodeLooper::pthreadExit() {
    delete this;
}
