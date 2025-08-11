import std.stdio;
import core.stdc.string        : strcmp;
import wayland_struct;
import util;

static const uint WIDTH             = 640;
static const uint HEIGHT            = 480;
static const uint PIXEL_FORMAT_ID   = wl_shm.format_.xrgb8888;


struct
Wayland {
    pragma (inline,true):
    auto display ()                  { return (wl_display_connect (null)); }
    auto display (const char *name)  { return (wl_display_connect (name)); }  // name, NULL, from: env WAYLAND_DISPLAY, env WAYLAND_SOCKET, env XDG_RUNTIME_DIR
    auto display (int fd)            { return (wl_display_connect_to_fd (fd)); }
    auto ctx ()                      { return new wayland_ctx (); }
}


struct 
wayland_ctx {
    int                width  = WIDTH;
    int                height = HEIGHT;

    wl_display*        display;
    wl_registry__impl  registry;
    wl_seat__impl      seat;
    wl_compositor*     compositor;
    wl_surface*        surface;
    wl_shm*            shm;
    wl_shm_pool*       pool;
    wl_buffer__impl    buffer;

    xdg_wm_base__impl  xdg_wm_base;
    xdg_surface__impl  xdg_surface;
    xdg_toplevel__impl xdg_toplevel;

    Input              input;

    bool               done;

    //
    struct 
    Input {
        wl_keyboard*   keyboard;
        wl_pointer*    pointer;
        wl_touch*      touch;
    }
}

// wl_registry
struct
wl_registry__impl {
    wl_registry* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
        // add_listener (&listener,ctx);
    }

    typeof(_super).Listener listener = {
        &global_impl,
        &global_remove_impl,
    };

    extern (C)
    static
    void 
    global_impl (void* ctx, wl_registry* _this, uint name, const(char)* interface_, uint version_) {
        printf ("%d: %s\n", name, interface_);
        auto _ctx =  cast (wayland_ctx*) ctx;

        //BIND!xdg_wm_base (ctx,_this,name,interface_,version_);
        if (strcmp (xdg_wm_base_interface.name, interface_) == 0) {
            _ctx.xdg_wm_base = cast (xdg_wm_base*) _this.bind (name, &xdg_wm_base_interface, version_);
            _ctx.xdg_wm_base.add_listener (&_ctx.xdg_wm_base.listener, ctx);
        }

        if (strcmp (wl_seat_interface.name, interface_) == 0) {
            _ctx.seat = cast (wl_seat*) _this.bind (name, &wl_seat_interface, version_);
            _ctx.seat.add_listener (&_ctx.seat.listener, ctx);
        }

        if (strcmp (wl_compositor_interface.name, interface_) == 0) {
            _ctx.compositor = cast (wl_compositor*) _this.bind (name, &wl_compositor_interface, version_);
        }

        if (strcmp (wl_shm_interface.name, interface_) == 0) {
            _ctx.shm = cast (wl_shm*) _this.bind (name, &wl_shm_interface, version_);
        }
    }

    extern (C) 
    static
    void 
    global_remove_impl (void* ctx, wl_registry* _this, uint name) {
        //
    }
}

// wl_seat
struct
wl_seat__impl {
    wl_seat* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
        // add_listener (&listener,ctx);
    }

    typeof(_super).Listener listener = {
        &capabilities_impl,
        &name_impl,
    };

    extern (C)
    static
    void
    capabilities_impl (void* ctx, wl_seat* _this /* args: */ , uint capabilities) {
        auto _ctx = cast (wayland_ctx*) ctx;
        if (capabilities & wl_seat.capability_.keyboard) {
            printf ("seat.cap: keyboard\n");
            _ctx.input.keyboard = _ctx.seat.get_keyboard ();
            printf ("keyboard: %p\n", _ctx.input.keyboard);
        }
        if (capabilities & wl_seat.capability_.pointer) {
            printf ("seat.cap: pointer\n");
            _ctx.input.pointer = _ctx.seat.get_pointer ();
            printf ("pointer: %p\n", _ctx.input.pointer);
        }
        if (capabilities & wl_seat.capability_.touch) {
            printf ("seat.cap: touch\n");
            _ctx.input.touch = _ctx.seat.get_touch ();
            printf ("touch: %p\n", _ctx.input.touch);
        }
    }

    extern (C)
    static
    void
    name_impl (void* ctx, wl_seat* _this /* args: */ , const(char)* name) {
        printf ("seat.name: %s\n", name);
    }
}

// wl_buffer
struct
wl_buffer__impl {
    wl_buffer* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
        // add_listener (&listener,ctx);
    }

    typeof(_super).Listener listener = {
        &_release_impl,
    };

    extern (C)
    static
    void
    _release_impl (void* ctx, wl_buffer* _this /* args: */ ) {
        _this.destroy ();
    }
}

// xdg_wm_base
struct
xdg_wm_base__impl {
    xdg_wm_base* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        /*ping:*/ &_ping_impl,
    };

    extern (C)
    static
    void
    _ping_impl (void* ctx, typeof(_super) _this /* args: */ , uint serial) {
        _this.pong (serial);
    }
}

// xdg_surface
struct
xdg_surface__impl {
    xdg_surface* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        /* configure: */ &_configure_impl,
    };

    extern (C)
    static
    void
    _configure_impl (void* ctx, xdg_surface* _this /* args: */ , uint serial) {
        auto _ctx = cast (wayland_ctx*) ctx;
        _this.ack_configure (serial);

        auto buffer = draw_frame (_ctx);
        _ctx.surface.attach (buffer, 0, 0);
        _ctx.surface.commit ();
    }
}


// xdg_toplevel
struct
xdg_toplevel__impl {
    xdg_toplevel* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }
}


auto
BIND (T,TTHIS) (void* ctx, TTHIS _this, uint name, const(char)* interface_, uint version_) {
    if (strcmp (T.IFACE.name, interface_) == 0) {
        mixin (format!
            "(cast (wayland_ctx*) ctx).%s = cast (%s*) _this.bind (name, &T.IFACE, version_);" 
            (T.stringof, T.stringof)
        );
    }
}

