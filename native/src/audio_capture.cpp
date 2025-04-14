#include "audio_capture.h"
#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"
#include <vector>
#include <algorithm>
#include <string.h>
#include <stdlib.h>


static ma_device appDevice;
static ma_context appContext;
static bool isAppInitialized = false;
static bool isAppCapturing = false;
static std::vector<float> appBuffer;
static char currentDeviceId[256] = {0};


void app_data_callback(ma_device* pDevice, void* pOutput, const void* pInput, ma_uint32 frameCount) {
    if (isAppCapturing) {
        const float* input = static_cast<const float*>(pInput);
        appBuffer.assign(input, input + frameCount * pDevice->capture.channels);
//        std::memset(appBuffer.data(), 0, appBuffer.size() * sizeof(float));
//        appBuffer.insert(appBuffer.begin(), input, input + frameCount * pDevice->capture.channels);
    }
}

bool InitializeAudioCapture(const char* deviceId) {
    const char* newDeviceId = deviceId ? deviceId : "";

    if (isAppInitialized) {
        if (strcmp(newDeviceId, currentDeviceId) == 0) {
            return true;
        } else {
            CleanupAudioCapture();
        }
    }


    ma_backend backends[] = {
            ma_backend_wasapi,
//                              ma_backend_dsound,
//                              ma_backend_winmm,
//                              ma_backend_coreaudio,
//                              ma_backend_sndio,
//                              ma_backend_audio4,
//                              ma_backend_oss,
//                              ma_backend_pulseaudio,
//                              ma_backend_alsa,
//                              ma_backend_jack,
//                              ma_backend_aaudio,
//                              ma_backend_opensl,
//                              ma_backend_webaudio,
//                              ma_backend_null
    };

    ma_context_config contextConfig = ma_context_config_init();
    ma_result result = ma_context_init(backends, 1, &contextConfig, &appContext);
    if (result != MA_SUCCESS)return false;

    ma_device_config deviceConfig = ma_device_config_init(ma_device_type_loopback);
    deviceConfig.capture.format = ma_format_f32;
    deviceConfig.capture.channels = 2;
    deviceConfig.sampleRate = 44100;
    deviceConfig.dataCallback = app_data_callback;

    if (newDeviceId[0] != '\0') {
        ma_device_info* pPlaybackInfos;
        ma_uint32 playbackCount;
        result = ma_context_get_devices(&appContext, NULL, NULL, &pPlaybackInfos, &playbackCount);
        if (result == MA_SUCCESS) {
            for (ma_uint32 i = 0; i < playbackCount; ++i) {
                if (strcmp(pPlaybackInfos[i].name, newDeviceId) == 0) {
                    deviceConfig.capture.pDeviceID = &pPlaybackInfos[i].id;
                    break;
                }
            }
        }
    }

    result = ma_device_init(&appContext, &deviceConfig, &appDevice);
    if (result != MA_SUCCESS) {
        ma_context_uninit(&appContext);
        return false;
    }

    isAppInitialized = true;
    size_t len = strlen(newDeviceId);
    if (len >= sizeof(currentDeviceId)) {
        len = sizeof(currentDeviceId) - 1;
    }
    memcpy(currentDeviceId, newDeviceId, len);
    currentDeviceId[len] = '\0';
    return true;
}


bool StartAudioCapture() {
    if (!isAppInitialized) {
        InitializeAudioCapture(NULL);
    }

    ma_result result = ma_device_start(&appDevice);
    if (result != MA_SUCCESS) return false;

    isAppCapturing = true;
    appBuffer.clear();
    return true;
}


void StopAudioCapture() {
    if (!isAppInitialized) return;

    ma_device_stop(&appDevice);
    isAppCapturing = false;
}


bool GetAudioData(float* buffer, int bufferSize) {
    if (!isAppCapturing || !buffer || bufferSize <= 0) return false;

    int copySize = std::min(bufferSize, static_cast<int>(appBuffer.size()));
    std::copy(appBuffer.begin(), appBuffer.begin() + copySize, buffer);

    // Remove copied data from buffer
    appBuffer.erase(appBuffer.begin(), appBuffer.begin() + copySize);

    return true;
}


void GetAudioFormat(int* sampleRate, int* channels) {
    if (!isAppInitialized || !sampleRate || !channels) return;

    *sampleRate = appDevice.sampleRate;
    *channels = appDevice.capture.channels;
}

void CleanupAudioCapture() {
    if (!isAppInitialized) return;

    ma_device_uninit(&appDevice);
    ma_context_uninit(&appContext);
    isAppInitialized = false;
    isAppCapturing = false;
    currentDeviceId[0] = '\0';
    appBuffer.clear();
} 