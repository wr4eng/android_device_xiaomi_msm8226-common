#!/usr/bin/python
#-*-coding:utf-8-*-

import common
import re
import os

TARGET_DIR = os.getenv('OUT')

def Thanks(self):
	self.script.AppendExtra('ui_print("===========================================");')
	self.script.AppendExtra('ui_print("         Thanks: ");')
	self.script.AppendExtra('ui_print(" tenfar,zhaochengw,airk,ivan19871002,");')
	self.script.AppendExtra('ui_print(" xuefy,suky,crazyi,windxixi,dianlujitao,");')
	self.script.AppendExtra('ui_print(" wangsai008,bingo1991,cofface,chenxi.mao");')
	self.script.AppendExtra('ui_print(" oubeichen,lwanggg");')
	self.script.AppendExtra('ui_print("******************************************");')
	self.script.AppendExtra('ui_print("    Design by syhost");')
	self.script.AppendExtra('ui_print(" 新  ");')
	self.script.AppendExtra('ui_print(" 浪  ");')
	self.script.AppendExtra('ui_print(" 微  ");')
	self.script.AppendExtra('ui_print(" 博  ");')
	self.script.AppendExtra('ui_print("    weibo.com/syhost");')
	self.script.AppendExtra('ui_print("===========================================");')
	self.script.AppendExtra('ui_print(" ");')

def FullOTA_Assertions(self):
	Thanks(self)

def IncrementalOTA_Assertions(self):
	Thanks(self)
	
def FullOTA_InstallEnd(self):
	RemovePreApp(self)
	
def IncrementalOTA_InstallEnd(self):
	RemovePreApp(self)


def RemovePreApp(self):
	self.script.AppendExtra('mount("ext4", "EMMC", "/dev/block/platform/msm_sdcc.1/by-name/userdata", "/data");')
	self.script.AppendExtra('delete("/data/system.notfirstrun");')

