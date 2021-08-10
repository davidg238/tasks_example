// Copyright (c) 2021 Ekorau LLC

import gpio
import pubsub
import monitor show *

// For a five way switch.
// One event is generated per switch press (not a stream of events, while the button is pressed)
// Only one switch can be pressed at a time.
// https://www.eejournal.com/article/ultimate-guide-to-switch-debounce-part-4/, use --ms=20 debounce

class Jog5WaySwitch:

  left_   /gpio.Pin // 10
  right_  /gpio.Pin // 11
  up_     /gpio.Pin // 12
  down_   /gpio.Pin // 13
  select_ /gpio.Pin // 14

  lcount := 0
  rcount := 0
  ucount := 0
  dcount := 0
  scount := 0

  constructor --left/int --right/int --up/int --down/int --select/int:
        left_   = gpio.Pin left --input=true --pull_up=true
        right_  = gpio.Pin right --input=true --pull_up=true
        up_     = gpio.Pin up --input=true --pull_up=true
        down_   = gpio.Pin down --input=true --pull_up=true
        select_ = gpio.Pin select --input=true --pull_up=true

  eventTo aChannel/Channel -> none:
    while true:
        if 0 == left_.get:   lcount++ else: lcount = 0
        if 0 == right_.get:  rcount++ else: rcount = 0
        if 0 == up_.get:     ucount++ else: ucount = 0
        if 0 == down_.get:   dcount++ else: dcount = 0
        if 0 == select_.get: scount++ else: scount = 0

        if 2 == lcount: aChannel.send 10
        if 2 == rcount: aChannel.send 11
        if 2 == ucount: aChannel.send 12
        if 2 == dcount: aChannel.send 13
        if 2 == scount: aChannel.send 14

        sleep --ms=20

    