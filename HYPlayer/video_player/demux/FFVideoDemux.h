//
//  FFVideoDemux.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef FFVideoDemux_hpp
#define FFVideoDemux_hpp

#include <stdio.h>
#include "IDemux.hpp"
#include "circle_av_packet_queue.hpp"

extern "C" {
#include <libavformat/avformat.h>
};

class FFVideoDemux: public IDemux {
    
    public:

        virtual ~FFVideoDemux();

        virtual bool init(const char *url);

        virtual bool start();

        virtual bool pause();

        virtual bool seek(long pos);

        virtual void release();

    protected:

        virtual int getBestStream(AVFormatContext *ic);

    private:

        const char *url;

        AVFormatContext *ic;

        int streamIndex = -1;

        double timeBase;

        void seekToStart();

};

#endif /* FFVideoDemux_hpp */
