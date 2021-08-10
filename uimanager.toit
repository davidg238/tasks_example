import font show *
import font.x11_100dpi.sans.sans_14_bold as sans_14
import pixel_display show *
// import pixel_display.texture show TEXT_TEXTURE_ALIGN_RIGHT TEXT_TEXTURE_ALIGN_CENTER
import pixel_display.true_color show BLACK get_rgb

import monitor show Channel
import encoding.json

class UIManager:

  display_/TrueColorPixelDisplay
  map_/Map

  events_/Channel
  updates_/Channel
  event_ := null
  update_/ByteArray := ByteArray 0
  txt/string := ""
  
  sans_ := Font [sans_14.ASCII]
  sans_context_ := null

  constructor --display/TrueColorPixelDisplay --model/Map --events/Channel --updates/Channel:

    display_ = display
    map_ = model
    events_ = events
    updates_ = updates
  
  run -> none:
    display_.background = BLACK
    sans_context_ = display_.context --landscape --color=(get_rgb 230 230 50) --font=sans_
    blank

    showTxt "hello world"
    while true:
        dispatchEvents
        dispatchUpdates

  showTxt text/string -> none:
    display_.remove_all
    display_.text sans_context_ 10 60 text
    display_.draw

  blank -> none:
      display_.remove_all
      display_.draw

  dispatchEvents -> none:
    // for now, if you receive any 5way switch action, just display switch event code
    print ".. in dispatchEvents"
    event_ = events_.receive // assume this yields if nothing on the channel?
    // print event_
    showTxt event_.stringify

  dispatchUpdates -> none:
    print ".. in dispatchUpdates"
    update_ = updates_.receive
    txt = update_.to_string_non_throwing 0 (update_.size + 1)
    showTxt txt
