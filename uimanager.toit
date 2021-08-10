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

  inputs_/Channel
  updates_/Channel
  events_/Channel

  duration_10ms ::= Duration --ms=10

  input_ := null
  event_ := null
  update_/ByteArray := ByteArray 0
  txt/string := ""
  
  sans_ := Font [sans_14.ASCII]
  sans_context_ := null


  constructor --model/Map --display/TrueColorPixelDisplay --inputs/Channel --updates/Channel --events/Channel:

    map_ = model
    display_ = display
    inputs_ = inputs
    events_ = events
    updates_ = updates
  
  run -> none:
    display_.background = BLACK
    sans_context_ = display_.context --landscape --color=(get_rgb 230 230 50) --font=sans_
    blank

    showTxt "hello world"
    while true:
      dispatchInputs
      dispatchEvents
      dispatchUpdates

  showTxt text/string -> none:
    display_.remove_all
    display_.text sans_context_ 10 60 text
    display_.draw

  blank -> none:
      display_.remove_all
      display_.draw

  dispatchInputs -> none:
    // for now, if you receive any 5way switch action, just display switch event code
    catch:
      with_timeout duration_10ms:
        input_ = inputs_.receive
        showTxt input_.stringify

  dispatchEvents -> none:
    catch:
      with_timeout duration_10ms:
        event_ = events_.receive
        showTxt txt

  dispatchUpdates -> none:
    catch:
      with_timeout duration_10ms:
        update_ = updates_.receive
        txt = update_.to_string_non_throwing 0 (update_.size + 1) // why is this the right "to" value ?
//        txt = update_.to_string 0 update_.size // ok, since "to" excluded ?
        showTxt txt
