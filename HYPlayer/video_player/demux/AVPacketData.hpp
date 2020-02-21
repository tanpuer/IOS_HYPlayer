//
//  AVPacketData.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef AVPacketData_hpp
#define AVPacketData_hpp

#include <stdio.h>

extern "C" {
#include "avcodec.h"
}

class AVPacketData {
    
public:
  
    int size;
    AVPacket *packet;
    int64_t pts;
    AVCodecParameters *parameters;
    bool over;
    void clear();
    bool seekOver;
    double timeBase;
    bool reset;
    
};

#endif /* AVPacketData_hpp */
