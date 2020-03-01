////
////  AudioUnitPlayer.cpp
////  HYPlayer
////
////  Created by templechen on 2020/2/27.
////  Copyright © 2020 templechen. All rights reserved.
////
//
//#include "AudioUnitPlayer.h"
//#import <AudioUnit/AudioUnit.h>
//#import <AVFoundation/AVFoundation.h>
//
//#define INPUT_BUS 1
//#define OUTPUT_BUS 0
//
//AudioUnit audioUnit;
//
//static OSStatus PlayCallback(void *inRefCon,
//                             AudioUnitRenderActionFlags *ioActionFlags,
//                             const AudioTimeStamp *inTimeStamp,
//                             UInt32 inBusNumber,
//                             UInt32 inNumberFrames,
//                             AudioBufferList *ioData) {
//    AudioUnitPlayer *player = (AudioUnitPlayer*)inRefCon;
//    player->call(ioData);
//}
//
//AudioUnitPlayer::AudioUnitPlayer(circle_av_frame_queue *frameQueue) {
//    //audio session
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *error = nil;
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
//    
//    AudioComponentDescription audioDesc;
//    audioDesc.componentType = kAudioUnitType_Output;
//    audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
//    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
//    audioDesc.componentFlags = 0;
//    audioDesc.componentFlagsMask = 0;
//    
//    AudioComponent inputComponent = AudioComponentFindNext(nullptr, &audioDesc);
//    AudioComponentInstanceNew(inputComponent, &audioUnit);
//    
//    //audio property
//    OSStatus status = noErr;
//    UInt32 flag = 1;
//    if (flag) {
//        status = AudioUnitSetProperty(audioUnit,
//                                      kAudioOutputUnitProperty_EnableIO,
//                                      kAudioUnitScope_Output,
//                                      OUTPUT_BUS,
//                                      &flag,
//                                      sizeof(flag));
//    }
//    if (status) {
//        NSLog(@"AudioUnitSetProperty error with status:%d", status);
//    }
//    
//    // format
//    AudioStreamBasicDescription outputFormat;
//    memset(&outputFormat, 0, sizeof(outputFormat));
//    outputFormat.mSampleRate       = 44100; // 采样率
//    outputFormat.mFormatID         = kAudioFormatLinearPCM; // PCM格式
//    outputFormat.mFormatFlags      = kLinearPCMFormatFlagIsSignedInteger; // 整形
//    outputFormat.mFramesPerPacket  = 1; // 每帧只有1个packet
//    outputFormat.mChannelsPerFrame = 1; // 声道数
//    outputFormat.mBytesPerFrame    = 2; // 每帧只有2个byte 声道*位深*Packet数
//    outputFormat.mBytesPerPacket   = 2; // 每个Packet只有2个byte
//    outputFormat.mBitsPerChannel   = 16; // 位深
//    
//    status = AudioUnitSetProperty(audioUnit,
//                                  kAudioUnitProperty_StreamFormat,
//                                  kAudioUnitScope_Input,
//                                  OUTPUT_BUS,
//                                  &outputFormat,
//                                  sizeof(outputFormat));
//    if (status) {
//        NSLog(@"AudioUnitSetProperty eror with status:%d", status);
//    }
//    
//    // callback
//    AURenderCallbackStruct playCallback;
//    playCallback.inputProc = PlayCallback;
//    playCallback.inputProcRefCon = (void *)this;
//    AudioUnitSetProperty(audioUnit,
//                         kAudioUnitProperty_SetRenderCallback,
//                         kAudioUnitScope_Input,
//                         OUTPUT_BUS,
//                         &playCallback,
//                         sizeof(playCallback));
//    
//    
//    OSStatus result = AudioUnitInitialize(audioUnit);
//    NSLog(@"result %d", result);
//}
//
//AudioUnitPlayer::~AudioUnitPlayer() {
//    
//}
//
//void AudioUnitPlayer::init() {
//    
//}
//
//void AudioUnitPlayer::start() {
//    AudioOutputUnitStart(audioUnit);
//}
//
//void AudioUnitPlayer::pause() {
//    AudioOutputUnitStop(audioUnit);
//}
//
//void AudioUnitPlayer::seek() {
//    
//}
//
//void AudioUnitPlayer::release() {
//    
//}
//
//void AudioUnitPlayer::call(void *bufq) {
//    if (!bufq) {
//            return;
//        }
//    AVFrameData *frameData = frameQueue->pull();
////    ALOGD("pull AVFrame from FrameQueue!");
//    if (frameData == nullptr) {
//        return;
//    }
//    if (frameData->over) {
//        NSLog(@"AVFrame is over!");
//        frameData->clear();
//        return;
//    }
//    currentPos = frameData->pts;
//    memcpy(buf, frameData->data, frameData->size);
//    
//    AudioBufferList *ioData = (AudioBufferList *)bufq;
//    ioData->mBuffers[0].mData = frameData->data;
//    ioData->mBuffers[0].mDataByteSize = frameData->size;
//    
//    frameData->clear();
//}
//
//void AudioUnitPlayer::reset() {
//    
//}
//
//void AudioUnitPlayer::setVolume(float volume) {
//    
//}
//
//void AudioUnitPlayer::initAudioSession() {
//    
//}
//
