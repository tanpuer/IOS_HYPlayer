//
//  IAudioPlayer.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/27.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef IAudioPlayer_hpp
#define IAudioPlayer_hpp

#include <stdio.h>

class IAudioPlayer {

public:

    virtual void init() = 0;

    virtual void start() = 0;

    virtual void pause() = 0;

    virtual void seek() = 0;

    virtual void release() = 0;

    virtual void reset() = 0;

    virtual void setVolume(float volume) = 0;

    long currentPos;

};

#endif /* IAudioPlayer_hpp */
