//
//  FFVideoDecode.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef FFVideoDecode_hpp
#define FFVideoDecode_hpp

#include <stdio.h>
#include "IDecode.hpp"

class FFVideoDecode : public IDecode{

public:

    FFVideoDecode(bool usingMediaCodec);

    virtual ~FFVideoDecode();

    virtual bool init();

    virtual bool start();

    virtual bool pause();

    virtual void release();

private:

    AVCodecParameters *parameters = nullptr;

    AVCodec *codec = nullptr;

    AVCodecContext *codecContext = nullptr;

    double timeBase;

    bool usingMediaCodec;

};

#endif /* FFVideoDecode_hpp */
