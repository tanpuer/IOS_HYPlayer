//
//  AVPacketData.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "AVPacketData.hpp"

void AVPacketData::clear() {
    av_packet_free(&packet);
}
