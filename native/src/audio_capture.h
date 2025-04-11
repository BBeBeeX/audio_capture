#pragma once

#ifdef _WIN32
#ifdef AUDIOCAPTURE_EXPORTS
        #define AUDIOCAPTURE_API __declspec(dllexport) // 导出
    #else
        #define AUDIOCAPTURE_API __declspec(dllimport) // 导入
    #endif
#else
#define AUDIOCAPTURE_API 
#endif

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

AUDIOCAPTURE_API bool InitializeAudioCapture(const char* deviceId);
AUDIOCAPTURE_API bool StartAudioCapture();
AUDIOCAPTURE_API void StopAudioCapture();
AUDIOCAPTURE_API bool GetAudioData(float* buffer, int bufferSize);
AUDIOCAPTURE_API void GetAudioFormat(int* sampleRate, int* channels);
AUDIOCAPTURE_API void CleanupAudioCapture();


#ifdef __cplusplus
}
#endif