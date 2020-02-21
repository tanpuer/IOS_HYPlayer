//
//  AVFrameData.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "AVFrameData.hpp"

void AVFrameData::clear() {
    av_frame_free(&frame);
    free(data);
    data = nullptr;
}
