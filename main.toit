// Copyright 2021 Ekorau LLC

import pubsub
import encoding.json
import gpio

import .tftfactory show TFT_factory
import .uimanager show UIManager
import .jog show Jog5WaySwitch
import spi

import monitor show *

map := Map

text_topic ::= "cloud:some_text"
ui_channel := Channel 1
update_channel := Channel 1

display := TFT_factory.adafruit_128x128
uiManager := UIManager
                --display = display
                --model = map
                --events = ui_channel
                --updates = update_channel

main:

  task:: jog_task
  task:: cloud_subscriptions
  task:: display_task

jog_task:
  print "start task, scanning the 5 way jog switch"
  jog := Jog5WaySwitch
          --left   = 14 // Pin IO14
          --right  = 27
          --up     = 26
          --down   = 12
          --select = 33
  jog.eventTo ui_channel  // there is a loop here

cloud_subscriptions:
  print "start task, for cloud subscriptions"
  pubsub.subscribe text_topic --blocking=true: | msg/pubsub.Message |
    update_channel.send msg.payload


display_task:
  //For reference, Nokia 2330 128x160
  print "start task, display"
  uiManager.run


