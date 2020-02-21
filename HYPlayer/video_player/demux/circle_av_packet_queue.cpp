//
//  circle_av_packet_queue.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "circle_av_packet_queue.hpp"
#include <pthread.h>
extern "C" {
#include <libavcodec/avcodec.h>
}

circle_av_packet_queue::circle_av_packet_queue() {
    pthread_mutex_init(&mutex, nullptr);
    pthread_cond_init(&cond, nullptr);

    tail = new AVPacketStruct();
    AVPacketStruct *nextCursor = tail;
    AVPacketStruct *currCursor = nullptr;
    int i = DEFAULT_AV_PACKET_SIZE - 1;
    while (i > 0) {
        currCursor = new AVPacketStruct();
        currCursor->next = nextCursor;
        nextCursor = currCursor;
        i--;
    }
    head = currCursor;
    tail->next = head;
    pushCursor = head;
    pullCursor = head;
}

circle_av_packet_queue::~circle_av_packet_queue() {
    pthread_mutex_lock(&mutex);
    AVPacketStruct *temp = nullptr;
    while (head != tail) {
        if (head->data != nullptr) {
            head->data->clear();
            temp = head;
            head = head->next;
            delete temp;
        }
    }
    if (tail->next != nullptr) {
        tail->data->clear();
    }
    delete tail;
    head = nullptr;
    tail = nullptr;
    pullCursor = nullptr;
    pushCursor = nullptr;
    pthread_mutex_unlock(&mutex);
}

void circle_av_packet_queue::push(AVPacketData *data) {
    pthread_mutex_lock(&mutex);
    if (pushCursor->next == pullCursor) {
        pthread_cond_wait(&cond, &mutex);
    }
    pushCursor->data = data;
    pushCursor = pushCursor->next;
    currSize++;
    demuxStarted = true;
    if (currSize > DEFAULT_AV_PACKET_SIZE / 2) {
        pthread_cond_signal(&cond);
    }
    pthread_mutex_unlock(&mutex);
}

AVPacketData *circle_av_packet_queue::pull() {
    pthread_mutex_lock(&mutex);
    if (!demuxStarted) {
        pthread_cond_wait(&cond, &mutex);
    }
    if (currSize < DEFAULT_AV_PACKET_SIZE / 3) {
        pthread_cond_signal(&cond);
    }
    if (pullCursor->next != pushCursor) {
        AVPacketData *data = pullCursor->data;
        pullCursor = pullCursor->next;
        currSize--;
        pthread_mutex_unlock(&mutex);
        return data;
    } else {
        pthread_mutex_unlock(&mutex);
        return new AVPacketData();
    }
}

AVPacketData *circle_av_packet_queue::pop() {
    pthread_mutex_lock(&mutex);
    if (!demuxStarted) {
        pthread_cond_wait(&cond, &mutex);
    }
    if (currSize < DEFAULT_AV_PACKET_SIZE / 3) {
        pthread_cond_signal(&cond);
    }
    if (pullCursor->next != pushCursor) {
        AVPacketData *data = pullCursor->data;
        pthread_mutex_unlock(&mutex);
        return data;
    } else {
        pthread_mutex_unlock(&mutex);
        return new AVPacketData();
    }
}
