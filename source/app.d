import std.stdio;
import core.stdc.stdlib        : EXIT_SUCCESS,EXIT_FAILURE;
import std.format              : format;
import wayland_struct;
import impl;
import util;


struct
Wayland {
    pragma (inline,true):
    auto display ()                  { return (wl_display_connect (null)); }
    auto display (const char *name)  { return (wl_display_connect (name)); }  // name, NULL, from: env WAYLAND_DISPLAY, env WAYLAND_SOCKET, env XDG_RUNTIME_DIR
    auto display (int fd)            { return (wl_display_connect_to_fd (fd)); }
    auto ctx ()                      { return new wayland_ctx (); }
}


auto min (A,B) (A a, B b) { return (a) < (b) ? (a) : (b); }
auto max (A,B) (A a, B b) { return (a) > (b) ? (a) : (b); }

auto
BIND (T,TTHIS) (void* ctx, TTHIS _this, uint name, const(char)* interface_, uint version_) {
    if (strcmp (T.IFACE.name, interface_) == 0) {
        mixin (format!
            "(cast (wayland_ctx*) ctx).%s = cast (%s*) _this.bind (name, &T.IFACE, version_);" 
            (T.stringof, T.stringof)
        );
    }
}


//extern (C)
int
main () {
    //version (Dynamic) loadWaylandClient ();

    // init
    auto wayland  = Wayland ();
    auto ctx      = wayland.ctx ();

    // connect
    with (ctx) {
        display  = wayland.display;
        registry = wl_display_get_registry (display);
        registry.add_listener (
            new wl_registry.Listener (  // is a vector of function pointers. 
                &global_impl,
                &global_remove_impl,
            ),
            ctx);  // wl_proxy.add_listener
        display.roundtrip ();
    }

    // checks
    if (ctx.xdg_wm_base is null) {
        printf ("Can't find xdg_wm_base\n");
        return EXIT_FAILURE;
    } 
    else {
        printf ("Found xdg_wm_base\n");
    }

    if (ctx.seat is null) {
        printf ("Can't find seat\n");
        return EXIT_FAILURE;
    } 
    else {
        printf ("Found seat\n");
    }

    // surface,window,draw
    with (ctx) {
        surface      = compositor.create_surface ();
        xdg_surface  = xdg_wm_base.get_xdg_surface (surface);
        xdg_surface.add_listener (new ctx.xdg_surface.Listener (&_configure_impl), ctx);
        xdg_toplevel = xdg_surface.get_toplevel ();
        xdg_toplevel.set_title ("Example client");
        surface.commit ();
    }

    // loop,draw
    bool done = false;
    while (!done) {
        if (ctx.display.dispatch () < 0) {
            printf ("loop: dispatch 1\n");
            perror ("Main loop error");
            done = true;
        }
    }

    // cleanup
    with (ctx) {
        registry.destroy ();
        display.disconnect ();
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
