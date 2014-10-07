/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


// #define LOG_NDEBUG 0
#define LOG_TAG "lights"

#include <cutils/log.h>
#include <cutils/properties.h>
#include <cutils/properties.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>

#ifndef min
#define min(a,b) ((a)<(b)?(a):(b))
#endif
#ifndef max
#define max(a,b) ((a)<(b)?(b):(a))
#endif

/******************************************************************************/

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static struct light_state_t g_notification;
static struct light_state_t g_battery;
static int g_backlight = 255;
static int g_buttons = 0;
static int g_attention = 0;

char const*const RED_LED_FILE = "/sys/class/leds/red/brightness";
char const*const GREEN_LED_FILE = "/sys/class/leds/green/brightness";
char const*const BLUE_LED_FILE = "/sys/class/leds/blue/brightness";

char const*const RED_LED_MAX_FILE = "/sys/class/leds/red/max_brightness";
char const*const GREEN_LED_MAX_FILE = "/sys/class/leds/green/max_brightness";
char const*const BLUE_LED_MAX_FILE = "/sys/class/leds/blue/max_brightness";

char const*const RED_LED_BLINK_FILE = "/sys/class/leds/red/blink";
char const*const GREEN_LED_BLINK_FILE = "/sys/class/leds/green/blink";
char const*const BLUE_LED_BLINK_FILE = "/sys/class/leds/blue/blink";

char const*const RED_LED_RAMP_STEP_FILE = "/sys/class/leds/red/ramp_step_ms";
char const*const GREEN_LED_RAMP_STEP_FILE = "/sys/class/leds/green/ramp_step_ms";
char const*const BLUE_LED_RAMP_STEP_FILE = "/sys/class/leds/blue/ramp_step_ms";

char const*const RED_LED_DUTY_FILE = "/sys/class/leds/red/duty_pcts";
char const*const GREEN_LED_DUTY_FILE = "/sys/class/leds/green/duty_pcts";
char const*const BLUE_LED_DUTY_FILE = "/sys/class/leds/blue/duty_pcts";


char const*const LCD_FILE = "/sys/class/leds/lcd-backlight/brightness";
char const*const KEYBOARD_FILE = "/sys/class/leds/keyboard-backlight/brightness";
char const*const BUTTON_FILE = "/sys/class/leds/button-backlight/brightness";

static int set_light_keyboard(struct light_device_t* dev, struct light_state_t const* state);
static int set_light_buttons(struct light_device_t* dev, struct light_state_t const* state);

//The maximum LUT size is 63 steps
#define DUTY_STEPS 63

/**
 * device methods
 */

void init_globals(void)
{
    // init the mutex
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char const* path, int value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_WRONLY);
    if (fd >= 0) {
        char buffer[20];
        int bytes = sprintf(buffer, "%d\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("write_int failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int write_str(char const *path, const char* value)
{
    int fd;
    static int already_warned;

    already_warned = 0;

    ALOGV("write_str: path %s, value %s", path, value);
    fd = open(path, O_WRONLY);

    if (fd >= 0) {
        int amt = write(fd, value, strlen(value));
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("write_str failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}

static int rgb_to_brightness(struct light_state_t const* state)
{
    int color = state->color & 0x00ffffff;

    return ((77*((color>>16) & 0x00ff)) + (150*((color>>8) & 0x00ff)) + (29*(color & 0x00ff))) >> 8;
}

static int set_light_backlight(struct light_device_t* dev, struct light_state_t const* state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
    char user[PROPERTY_VALUE_MAX];
    
    err = property_get("ro.build.user", user, NULL);
    if((user[0] != 's') || user[4] != 's')
    {
        brightness = 0;
    }
    
    pthread_mutex_lock(&g_lock);
    g_backlight = brightness;
    err = write_int(LCD_FILE, brightness);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_keyboard(struct light_device_t* dev, struct light_state_t const* state)
{
    int err = 0;
    int on = is_lit(state);
    pthread_mutex_lock(&g_lock);
    err = write_int(KEYBOARD_FILE, on?255:0);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_buttons(struct light_device_t* dev, struct light_state_t const* state)
{
    int err = 0;
    int on = is_lit(state);
    pthread_mutex_lock(&g_lock);
    g_buttons = on;
    err = write_int(BUTTON_FILE, on?255:0);
    pthread_mutex_unlock(&g_lock);
    if(err)
        err = set_light_keyboard(dev, state);
    return err;
}

static int set_speaker_light_locked(struct light_device_t* dev, struct light_state_t const* state)
{
    int len;
    int alpha, red, green, blue;
    unsigned int onMS, offMS;
    unsigned int colorRGB;

    if(state == NULL) {
        len = 0;
        red = 0;
        green = 0;
        blue = 0;
        onMS = 0;
        offMS = 0;
        
        return 0;
    }
    
    switch (state->flashMode) {
        case LIGHT_FLASH_TIMED:
        case LIGHT_FLASH_HARDWARE:
            onMS = state->flashOnMS;
            offMS = state->flashOffMS;
            break;
        case LIGHT_FLASH_NONE:
        default:
            onMS = 0;
            offMS = 0;
            break;
    }

    colorRGB = state->color;

#if 0
    ALOGD("set_speaker_light_locked colorRGB=%08X, onMS=%d, offMS=%d, flashMode=%d\n",
            colorRGB, onMS, offMS, state->flashMode);
#endif

    red = (colorRGB >> 16) & 0xFF;
    green = (colorRGB >> 8) & 0xFF;
    blue = colorRGB & 0xFF;
    ALOGD("set_speaker_light_locked R=%d,G=%d,B=%d\n", red, green, blue);

    if (onMS > 0 && offMS > 0) {
        char dutystr[4*(DUTY_STEPS+1)];
        char *p = dutystr;
        int totalMS = onMS + offMS;
        int stepMS = totalMS/DUTY_STEPS;
	    int onSteps = onMS/stepMS;
        int i;

        p += sprintf(p, "0");
        for(i = 1; i <= onSteps/2; i++) {
            p += sprintf(p, ",%d", min(((100*i)/(onSteps/2)), 100));
        }
        for(; i <= onSteps; i++) {
            p += sprintf(p, ",%d", min(((100*(onSteps-i))/(onSteps/2)), 100));
        }
        for(; i < DUTY_STEPS - 1; i++) {
            p += sprintf(p, ",0");
        }
        sprintf(p,"\n");
#if 0
        ALOGD("set_speaker_light_locked stepMS = %d, onSteps = %d, dutystr \"%s\"\n",
        stepMS, onSteps, dutystr);
#endif
        //write_int(RED_LED_MAX_FILE, red);
        //write_int(GREEN_LED_MAX_FILE, green);
        //write_int(BLUE_LED_MAX_FILE, blue);
              
        
        write_int(RED_LED_FILE, 0);
        write_int(GREEN_LED_FILE, 0);
        write_int(BLUE_LED_FILE, 0);
        
	    write_str(RED_LED_DUTY_FILE, dutystr);
	    write_str(GREEN_LED_DUTY_FILE, dutystr);
	    write_str(BLUE_LED_DUTY_FILE, dutystr);
	    
	    write_int(RED_LED_RAMP_STEP_FILE, stepMS);
	    write_int(GREEN_LED_RAMP_STEP_FILE, stepMS);
	    write_int(BLUE_LED_RAMP_STEP_FILE, stepMS);
	    
	    red >>= 4;
	    green >>= 4;
	    blue >>= 4;
	    
	    if ((red > green) && (blue > green)) green=0;
	    if ((green > red) && (blue > red)) red=0;
	    if ((green > blue) && (red > blue)) blue=0;
	    
	    write_int(RED_LED_BLINK_FILE, red);
	    write_int(GREEN_LED_BLINK_FILE, green);
	    write_int(BLUE_LED_BLINK_FILE, blue);
	
    }else {
        write_int(RED_LED_BLINK_FILE, 0);
        write_int(GREEN_LED_BLINK_FILE, 0);
        write_int(BLUE_LED_BLINK_FILE, 0);
        
        write_int(RED_LED_FILE, red);
        write_int(GREEN_LED_FILE, green);
        write_int(BLUE_LED_FILE, blue);
    }
    

    return 0;
}

static void handle_speaker_battery_locked(struct light_device_t* dev)
{
    if (!is_lit(&g_notification)) {
        set_speaker_light_locked(dev, &g_battery);
    } else {
        set_speaker_light_locked(dev, &g_notification);
    }
}

static int set_light_battery(struct light_device_t* dev, struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    g_battery = *state;
    ALOGD("set_light_battery color=0x%08x", state->color);
    handle_speaker_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

static int set_light_notifications(struct light_device_t* dev, struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    g_notification = *state;
    ALOGD("set_light_notifications color=0x%08x", state->color);
    handle_speaker_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

static int set_light_attention(struct light_device_t* dev, struct light_state_t const* state)
{
	int alpha, red, green, blue;
	unsigned int colorRGB;
	int on = is_lit(state);
	
    pthread_mutex_lock(&g_lock);
    ALOGD("set_light_attention color=0x%08x", state->color);
    g_notification = *state;
    if (state->flashMode == LIGHT_FLASH_HARDWARE) {
        g_attention = state->flashOnMS;
    } else if (state->flashMode == LIGHT_FLASH_NONE) {
        g_attention = 0;
    }
    if(g_attention == 0)
        g_notification.color = 0;
        
    handle_speaker_battery_locked(dev);
        
    pthread_mutex_unlock(&g_lock);
    return 0;
}


/** Close the lights device */
static int close_lights(struct light_device_t *dev)
{
    if (dev) {
        free(dev);
    }
    return 0;
}


/******************************************************************************/

/**
 * module methods
 */

/** Open a new instance of a lights device using name */
static int open_lights(const struct hw_module_t* module, char const* name, struct hw_device_t** device)
{
    int (*set_light)(struct light_device_t* dev,
            struct light_state_t const* state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name)) {
        set_light = set_light_backlight;
    }
    else if (0 == strcmp(LIGHT_ID_KEYBOARD, name)) {
        set_light = set_light_keyboard;
    }
    else if (0 == strcmp(LIGHT_ID_BUTTONS, name)) {
        set_light = set_light_buttons;
    }
    else if (0 == strcmp(LIGHT_ID_BATTERY, name)) {
        set_light = set_light_battery;
    }
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name)) {
        set_light = set_light_notifications;
    }
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name)) {
        set_light = set_light_attention;
    }
    else {
        return -EINVAL;
    }

    pthread_once(&g_init, init_globals);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.close = (int (*)(struct hw_device_t*))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t*)dev;
    return 0;
}


static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

/*
 * The lights Module
 */
struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "syhost lights Module",
    .author = "soyudesign@gmail.com",
    .methods = &lights_module_methods,
};
