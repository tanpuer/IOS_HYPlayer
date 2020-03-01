//
//  AudioUnitPlayer.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/27.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef AudioUnitPlayer_hpp
#define AudioUnitPlayer_hpp

#include <stdio.h>
#include "IAudioPlayer.h"
#include "circle_av_frame_queue.hpp"

class AudioUnitPlayer : public IAudioPlayer {
  
public:

    AudioUnitPlayer(circle_av_frame_queue *frameQueue);

    ~AudioUnitPlayer();

    void init();

    void start();

    void pause();

    void seek();

    void release();

    void call(void *bufq);

    void reset();

    void setVolume(float volume);

private:

    unsigned char* buf = 0;

    circle_av_frame_queue *frameQueue;
    
    void initAudioSession();
    
};

#endif /* AudioUnitPlayer_hpp */
