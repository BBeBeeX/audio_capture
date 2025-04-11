cmake_minimum_required(VERSION 3.22.0)
project(audio_capture)

set(HEADER_FILES "src/audio_capture.h" "miniaudio/extras/miniaudio_split/miniaudio.h")
set(SOURCE_FILES "src/audio_capture.cpp"  "miniaudio/extras/miniaudio_split/miniaudio.c")
set(CMAKE_BUILD_TYPE Debug)

if ("${SHARED}" STREQUAL "YES")
  add_library(${PROJECT_NAME} SHARED ${SOURCE_FILES})
else()
  add_library(${PROJECT_NAME} STATIC ${SOURCE_FILES})
endif()

target_compile_definitions(${PROJECT_NAME}  PRIVATE AUDIOCAPTURE_EXPORTS)

target_include_directories(${PROJECT_NAME} PRIVATE "miniaudio/extras/miniaudio_split")
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)

if ("${OS}" STREQUAL "ANDROID")
  install (TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION .
  )
elseif ("${OS}" STREQUAL "LINUX")
  install (TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION .
  )
endif()



