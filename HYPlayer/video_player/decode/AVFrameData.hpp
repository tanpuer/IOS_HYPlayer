//
//  AVFrameData.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef AVFrameData_hpp
#define AVFrameData_hpp

#include <stdio.h>
extern "C" {
#include <libavutil/frame.h>
};

class AVFrameData {

public:

    AVFrame *frame;

    int64_t pts;

    unsigned char* data;

    void clear();

    int size;

    bool over;

    bool seekOver;

    bool reset;

};

#endif /* AVFrameData_hpp */
