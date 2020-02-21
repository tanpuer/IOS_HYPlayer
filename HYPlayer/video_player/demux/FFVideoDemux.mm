//
//  FFVideoDemux.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "FFVideoDemux.h"
#include <pthread.h>
#include <unistd.h>
#include "AVPacketData.hpp"
#import <Foundation/Foundation.h>

extern "C" {
#include <libavformat/avformat.h>
}

//分数转为浮点数
static double r2d(AVRational r) {
    return r.num == 0 || r.den == 0 ? 0. : (double) r.num / (double) r.den;
}

bool FFVideoDemux::init(const char *url) {
    av_register_all();
    avcodec_register_all();
    avformat_network_init();
    NSLog(@"open file begin %s", url);
    int re = avformat_open_input(&ic, url, nullptr, nullptr);
    if (re != 0) {
        char buf[1024] = {0};
        av_strerror(re, buf, sizeof(buf));
        NSLog(@"open file failed %s", buf);
        return false;
    }
    NSLog(@"open file success!");
    re = avformat_find_stream_info(ic, nullptr);
    if (re != 0) {
        char buf[1024] = {0};
        av_strerror(re, buf, sizeof(buf));
        NSLog(@"find stream info failed %s", buf);
        return false;
    }
    totalDuration = ic->duration / AV_TIME_BASE * 1000;
    re = getBestStream(ic);
    if (re < 0) {
        char buf[1024] = {0};
        av_strerror(re, buf, sizeof(buf));
        NSLog(@"av_find_best_stream failed %s", buf);
        return false;
    }
    streamIndex = re;
    timeBase = r2d(ic->streams[streamIndex]->time_base);
    NSLog(@"FFDemux init finish");
    return true;
}

bool FFVideoDemux::start() {
    NSLog(@"FFDemux start %d", streamIndex);
    while (isDemuxing) {
        AVPacket *pkt = av_packet_alloc();
        int re = av_read_frame(ic, pkt);
        if (re != 0) {
            char buf[1024] = {0};
            av_strerror(re, buf, sizeof(buf));
            NSLog(@"av_read_frame error %s", buf);
            av_packet_free(&pkt);
            if (!isOver && loop) {
                seekToStart();
                continue;
            }
            break;
        }
        if (pkt->stream_index == streamIndex) {
            AVPacketData *data = new AVPacketData();
            data->packet = pkt;
            data->size = pkt->size;
            data->pts = pkt->pts * 1000 * timeBase;
            data->parameters = ic->streams[streamIndex]->codecpar;
            data->timeBase = timeBase;
            packetQueue->push(data);
            //network slow test
//            usleep(100000);
        } else {
            //ignore other streams!
            av_packet_free(&pkt);
        }
    }
    if (isOver) {
        NSLog(@"FFDemux isOver");
        //over
        AVPacketData *data = new AVPacketData();
        data->over = true;
        packetQueue->push(data);
        AVPacketData *data2 = new AVPacketData();
        data->over = true;
        packetQueue->push(data2);
        isOver = false;
    }
    if (needReset) {
        NSLog(@"FFDemux needReset");
        needReset = false;
        auto *data = new AVPacketData();
        data->reset = true;
        packetQueue->push(data);
        needReset = false;
        if (ic) {
            avformat_close_input(&ic);
        }
        NSLog(@"FFDemux reset!");
    }
    NSLog(@"FFDemux start break!");
    return false;
}

bool FFVideoDemux::pause() {
    return true;
}

bool FFVideoDemux::seek(long pos) {
    NSLog(@"demux seek start! %ld, %lld", pos, totalDuration);
    avformat_flush(ic);
    int64_t seekPos = ic->streams[streamIndex]->duration * pos / totalDuration;
    NSLog(@"demux seek start! %lld, %lld", seekPos, ic->streams[streamIndex]->duration);
    int re = av_seek_frame(ic, streamIndex, seekPos, AVSEEK_FLAG_FRAME | AVSEEK_FLAG_BACKWARD);
    if (re < 0) {
        NSLog(@"seek error !");
        return false;
    }
    isDemuxing = true;
    AVPacketData *data = new AVPacketData();
    data->seekOver = true;
    packetQueue->push(data);
    NSLog(@"demux seek end!");
    start();
    return true;
}

void FFVideoDemux::release() {
    if (ic) {
        avformat_close_input(&ic);
    }
    NSLog(@"FFDemux release!");

    delete this;
}

FFVideoDemux::~FFVideoDemux() {
    NSLog(@"delete FFDemux");
}

int FFVideoDemux::getBestStream(AVFormatContext *ic) {
    return av_find_best_stream(ic, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
}

void FFVideoDemux::seekToStart() {
    avformat_flush(ic);
    NSLog(@"demux seek start! %d, %lld", 0, ic->streams[streamIndex]->duration);
    int re = av_seek_frame(ic, streamIndex, 0, AVSEEK_FLAG_FRAME | AVSEEK_FLAG_BACKWARD);
    if (re < 0) {
        NSLog(@"seek error !");
    }
}
