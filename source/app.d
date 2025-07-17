import std.stdio;
import wayland_struct;


void
main () {
    auto wayland = Wayland ();
    auto display = wayland.display;

    //wl_registry_add_listener (compositor, &compositor_listener, null);
    //surface = compositor.surface;
    //wl_surface_add_listener (surface, &surface_listener, null);

    while (display.dispatch () >= 0) {  // default queue
        while (display.read_events () >= 0) {
            //writeln (event);
        }
    }


    version (XXX_roundtrip)
    while (display.roundtrip () >= 0) {
        //
    }

    version (XXX_unblocked)
    while (display.dispatch_pending () >= 0) {
        //
    }

    //
    version (XXX_test)
    {
        auto queue = display.queue; 
        while (display.prepare_read_queue (queue) != 0)
            display.dispatch_queue_pending (queue);

        display.flush ();

        ret = poll (fds, nfds, -1);
        if (has_error (ret))
            display.cancel_read ();
        else
            display.read_events ();

        display.dispatch_queue_pending (queue);

        // ...
    }

    //
    display.disconnect ();
}

//void 
//main () {
//	// INIT
//    auto wayland   = Wayland ();

//    auto c         = wayland.connect (false,null);
//    auto screen    = c.screen;
//    auto window    = c.window (screen);

//    writeln ("width x height (in pixels): ", screen.width_in_pixels, "x", screen.height_in_pixels);
//    writeln ("hwnd: ",window);

//    // EVENT LOOP
//    foreach (event; c.events) {
//        switch (event.type) {
//            case Event.Type.KEY_PRESS   : 
//            case Event.Type.KEY_RELEASE : 
//                writeln (event.keyboard);
//                break;
//            case Event.Type.BUTTON_PRESS   : 
//            case Event.Type.BUTTON_RELEASE : 
//                writeln (event.button);
//                break;
//            case Event.Type.MOTION_NOTIFY : 
//                writeln (event.motion);
//                break;
//            case Event.Type.EXPOSE : 
//                writeln (event.expose);
//                break;
//            default : writeln (event);
//        }        
//    }

//    c.disconnect ();
//}

