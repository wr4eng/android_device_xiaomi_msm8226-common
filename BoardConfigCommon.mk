#
# Copyright (C) 2014 The Mokee OpenSource Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_SPECIFIC_HEADER_PATH := device/xiaomi/msm8226-common/include

BOARD_VENDOR 				:= xiaomi

TARGET_CPU_ABI 				:= armeabi-v7a
TARGET_CPU_ABI2 			:= armeabi
TARGET_CPU_SMP 				:= true
TARGET_ARCH 				:= arm
TARGET_ARCH_VARIANT 		:= armv7-a-neon
ARCH_ARM_HAVE_ARMV7A 		:= true
TARGET_CPU_VARIANT 			:= cortex-a7
ARCH_ARM_HAVE_NEON 			:= true
ARCH_ARM_HAVE_TLS_REGISTER 	:= true

TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp

TARGET_NO_BOOTLOADER 					:= true

TARGET_NO_RADIOIMAGE 		:= true
TARGET_BOARD_PLATFORM 		:= msm8226
TARGET_BOARD_PLATFORM_GPU 	:= qcom-adreno305



# QCOM
BOARD_USES_QCOM_HARDWARE 	:= true
TARGET_USES_QCOM_BSP 		:= true
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE -DQCOM_BSP


# Graphics
USE_OPENGL_RENDERER 		:= true
TARGET_USES_ION				:= true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_OVERLAY 		:= true
TARGET_USES_SF_BYPASS       := true
BOARD_EGL_CFG 				:= device/xiaomi/msm8226-common/configs/egl.cfg

TARGET_QCOM_DISPLAY_VARIANT := legacy

HAVE_ADRENO_SOURCE			:= false
OVERRIDE_RS_DRIVER 			:= libRSDriver_adreno.so

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 1024*1024

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

TARGET_DISPLAY_INSECURE_MM_HEAP := true

# Audio
TARGET_QCOM_AUDIO_VARIANT := caf
BOARD_USES_ALSA_AUDIO	  := true
#AUDIO_FEATURE_DISABLED_COMPRESS_CAPTURE := true
#AUDIO_FEATURE_DISABLED_DS1_DOLBY_DDP := true
AUDIO_FEATURE_DISABLED_SSR := true
#AUDIO_FEATURE_DISABLED_INCALL_MUSIC := true
#AUDIO_FEATURE_DISABLED_ANC_HEADSET := true

# Media
TARGET_QCOM_MEDIA_VARIANT := legacy

# QCOM enhanced A/V
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true


# Camera
USE_DEVICE_SPECIFIC_CAMERA 	:= true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
TARGET_NO_RPC := true
#TARGET_PROVIDES_GPS_LOC_API := true
#BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := msm8226

# PowerHAL
TARGET_POWERHAL_VARIANT	 := qcom

# LightHAL
TARGET_PROVIDES_LIBLIGHT := true


BOARD_SEPOLICY_DIRS += \
        device/xiaomi/msm8226-common/sepolicy

# The list below is order dependent
BOARD_SEPOLICY_UNION += \
        file_contexts \
        app.te \
        device.te
        
TARGET_RELEASETOOLS_EXTENSIONS 		:= device/xiaomi/msm8226-common

BOARD_USES_QC_TIME_SERVICES := true

TARGET_EXCLUDE_GOOGLE_IME := true

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

#PRODUCT_PREBUILT_WEBVIEWCHROMIUM := yes

