import std.stdio;
import core.stdc.stdlib        : EXIT_SUCCESS,EXIT_FAILURE;
import std.format              : format;
import wayland_struct;
import impl;
import util;


//extern (C)
int
main () {
    //version (Dynamic) loadWaylandClient ();

    // init, connect
    auto wayland = Wayland ();
    if (!wayland.connect ())
        return EXIT_FAILURE;
    wayland.create_surface ();

    // EVENT LOOP
    foreach (event; wayland.events) {
        writeln (event);
    }

    wayland.cleanup ();

    return EXIT_SUCCESS;
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
