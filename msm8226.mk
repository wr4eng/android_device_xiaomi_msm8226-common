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

# This file includes all definitions that apply to ALL msm8226-common devices, and
# are also specific to msm8226-common devices
#
# Everything in this directory will become public

DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

# bootanimation
#PRODUCT_COPY_FILES += \
#	$(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

# usbdriver
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/usbdriver.iso:system/media/usbdriver.iso
	
# Spn config
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/spn-conf.xml:system/etc/spn-conf.xml \
	#$(LOCAL_PATH)/configs/selective-spn-conf.xml:system/etc/selective-spn-conf.xml
	
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/apns-conf.xml:system/etc/apns-conf.xml \
	#$(LOCAL_PATH)/configs/apns-conf-cdma.xml:system/etc/apns-conf-cdma.xml
	
	
# Live Wallpapers
PRODUCT_PACKAGES += \
	LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni
	
# Display
PRODUCT_PACKAGES += \
    libgenlock \
	liboverlay \
	libtilerenderer \
	hwcomposer.msm8226 \
	gralloc.msm8226 \
	copybit.msm8226 \
	memtrack.msm8226 \
	

PRODUCT_PACKAGES += \
	audio.primary.msm8226 \
	audio.a2dp.default \
	audio.usb.default \
	audio.r_submix.default \
	audiod \
	audio_policy.msm8226 \
	
PRODUCT_PACKAGES += \
    libaudio-resampler \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    tinymix \
	
# OMX
PRODUCT_PACKAGES += \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libc2dcolorconvert \
    libOmxVdecHevc \
    libdashplayer \
    libdivxdrmdecrypt \
    libmm-omxcore \
    libstagefrighthw \
	libtilerenderer \
	libI420colorconvert \

PRODUCT_PACKAGES += \
    qcmediaplayer
    
PRODUCT_BOOT_JARS += qcmediaplayer
    
# libxml2 is needed for camera
PRODUCT_PACKAGES += libxml2

# Power
PRODUCT_PACKAGES += \
	power.msm8226

# Lights
PRODUCT_PACKAGES += \
	lights.msm8226
	
# Keymaster
PRODUCT_PACKAGES += \
    keystore.msm8226

# GPS	
PRODUCT_PACKAGES += \
	gps.msm8226 \
	libgps.utils \
    libloc_eng \
    libloc_api_v02 \
    libloc_adapter \
#	gps.conf \

# GPS configuration
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/gps.conf:system/etc/gps.conf \
	
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/sap.conf:system/etc/sap.conf \
	$(LOCAL_PATH)/configs/sec_config:system/etc/sec_config

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/sensor_def_qcomdev.conf:system/etc/sensor_def_qcomdev.conf
	

# Connectivity Engine support
PRODUCT_PACKAGES += \
    libcnefeatureconfig \
    services-ext


# for off charging mode
#PRODUCT_PACKAGES += \
#    charger \
#    charger_res_images
	
# etc configs
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/hosts:system/etc/hosts

# Media
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
	$(LOCAL_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/configs/mixer_paths.xml:system/etc/mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio_platform_info.xml:system/etc/audio_platform_info.xml \

# Qcom scripts
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/etc/init.qcom.fm.sh:system/etc/init.qcom.fm.sh \
	$(LOCAL_PATH)/etc/init.qcom.wifi.sh:system/etc/init.qcom.wifi.sh \
	
	
# These are the hardware-specific features
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml
    
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
	com.android.future.usb.accessory

# Filesystem management tools
PRODUCT_PACKAGES += \
	e2fsck
	
# Qualcomm Random Numbers Generator
#PRODUCT_PACKAGES += \
#    qrngd \
#    qrngp

#PRODUCT_PACKAGES += \
	libemoji \
	libion
	
# Telephony packages
PRODUCT_PACKAGES += \
    Mms \
#    CellBroadcastReceiver\
#    Stk \

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/vendor/lib/libqc-opt.so

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0 \
	wifi.supplicant_scan_interval=240 \

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp


PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.google.clientidbase=android-xiaomi \
	ro.com.google.clientidbase.ms=android-xiaomi \
	ro.com.google.clientidbase.am=android-xiaomi \
	ro.com.google.clientidbase.gmm=android-xiaomi \
	ro.com.google.clientidbase.yt=android-xiaomi
	
	
PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.ringtone=Orion.ogg \
	ro.config.notification_sound=OnTheHunt.ogg \
	ro.config.alarm_alert=Cesium.ogg \
	ro.config.ringtone_2=Orion.ogg


PRODUCT_PROPERTY_OVERRIDES += \
	ro.kernel.android.checkjni=0
	
# Audio
#PRODUCT_PROPERTY_OVERRIDES += \
#    af.resampler.quality=255
    
#PRODUCT_PROPERTY_OVERRIDES += \
#    audio.offload.24bit.enable=false \
#    audio.offload.buffer.size.kb=32 \
#    audio.offload.gapless.enabled=false \
#    audio.offload.multiple.enabled=false \
#    audio.offload.pcm.enable=true
#
#PRODUCT_PROPERTY_OVERRIDES += \
#    av.offload.enable=false \
#    av.streaming.offload.enable=false

PRODUCT_PROPERTY_OVERRIDES += \
    mm.enable.smoothstreaming=true

#PRODUCT_PROPERTY_OVERRIDES += \
#    persist.audio.calfile0=/etc/Bluetooth_cal.acdb \
#    persist.audio.calfile1=/etc/General_cal.acdb \
#    persist.audio.calfile2=/etc/Global_cal.acdb \
#    persist.audio.calfile3=/etc/Handset_cal.acdb \
#    persist.audio.calfile4=/etc/Hdmi_cal.acdb \
#    persist.audio.calfile5=/etc/Headset_cal.acdb \
#    persist.audio.calfile6=/etc/Speaker_cal.acdb
    
    
# Radio
#PRODUCT_PROPERTY_OVERRIDES += \
#    persist.radio.msgtunnel.start=false \
#    persist.radio.dont_use_dsd=true \
#    persist.radio.apm_sim_not_pwdn=1 \
#    persist.radio.dfr_mode_set=1 \
#    persist.radio.no_wait_for_card=1 \
#    persist.radio.plmn_name_cmp=1	

    
# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

