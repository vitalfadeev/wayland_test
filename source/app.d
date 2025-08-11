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

    // init
    auto wayland  = Wayland ();
    auto ctx      = wayland.ctx ();

    // connect
    with (ctx) {
        wl_display  = wayland.display;
        wl_registry = wl_display.get_registry ();  // return wl_registry__impl
        wl_registry.add_listener (&wl_registry.listener,ctx);  // wl_proxy.add_listener
        wl_display.roundtrip ();
    }

    // checks
    if (!ctx.check) {
        return EXIT_FAILURE;
    } 

    // surface,window,draw
    with (ctx) {
        wl_surface   = wl_compositor.create_surface ();
        xdg_surface  = xdg_wm_base.get_xdg_surface (wl_surface);
        xdg_surface.add_listener (&xdg_surface.listener, ctx);
        xdg_toplevel = xdg_surface.get_toplevel ();
        xdg_toplevel.set_title ("Example client");
        wl_surface.commit ();
    }

    // loop,draw
    while (!ctx.done) {
        if (ctx.wl_display.dispatch () < 0) {
            printf ("loop: dispatch 1\n");
            perror ("Main loop error");
            ctx.done = true;
        }
    }

    // cleanup
    with (ctx) {
        wl_registry.destroy ();
        wl_display.disconnect ();
    }

    //
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
