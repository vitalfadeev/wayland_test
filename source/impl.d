import std.stdio;
import std.format : format;
import core.stdc.string        : strcmp;
import wayland_struct;
import util;

static const uint WIDTH             = 640;
static const uint HEIGHT            = 480;
static const uint PIXEL_FORMAT_ID   = wl_shm.format_.xrgb8888;


struct
Wayland {
    wayland_ctx ctx;

    auto 
    connect () {
        with (ctx) {
            wl_display  = wl_display_connect (null);
            _init_registry ();
        }
        return check ();
    }
    auto 
    connect (const char* name) {
        with (ctx) {
            wl_display  = wl_display_connect (name);
            _init_registry ();
        }
        return check ();
    }
    auto 
    connect (int fd) { 
        with (ctx) {
            wl_display_connect_to_fd (fd); 
            _init_registry ();
        }
        return check ();
    }
    void 
    _init_registry () {
        with (ctx) {
            wl_registry = wl_display.get_registry ();  // return wl_registry__impl
            wl_registry.add_listener (&wl_registry.listener,&ctx);  // wl_proxy.add_listener
            wl_display.roundtrip ();
        }
    }

    auto
    check () {
        with (ctx) {
            if (xdg_wm_base is null) {
                printf ("Can't find xdg_wm_base\n");
                return false;
            } 

            if (wl_seat is null) {
                printf ("Can't find seat\n");
                return false;
            } 
        } 

        return true;
    }

    void
    create_surface () {
        with (ctx) {
            wl_surface   = wl_compositor.create_surface ();
            xdg_surface  = xdg_wm_base.get_xdg_surface (wl_surface);
            xdg_surface.add_listener (&xdg_surface.listener, &ctx);
            xdg_toplevel = xdg_surface.get_toplevel ();
            xdg_toplevel.set_title ("Example client");
            wl_surface.commit ();
        }
    }

    auto
    events () {
        return Events (&this);
    }

    void
    loop () {
        with (ctx)
        while (!done) {
            if (wl_display.dispatch () < 0) {
                printf ("loop: dispatch 1\n");
                perror ("Main loop error");
                done = true;
            }
        }
    }

    void
    cleanup () {
        with (ctx) {
            wl_registry.destroy ();
            wl_display.disconnect ();        
        }
    }
}

struct
Events {
    Wayland* wayland;
    Event    front;

    bool  
    empty () {
        with (wayland.ctx)
        while (!done) {
            if (wl_display.dispatch () < 0) {
                printf ("loop: dispatch 1\n");
                perror ("Main loop error");
                done = true;
            }
        }

        return true;
    }

    void 
    popFront () {
        //
    }
}

struct
Event {
    //
}


struct 
wayland_ctx {
    int                 width  = WIDTH;
    int                 height = HEIGHT;

    wl_display__impl    wl_display;
    wl_registry__impl   wl_registry;
    wl_seat__impl       wl_seat;
    wl_compositor__impl wl_compositor;
    wl_surface__impl    wl_surface;
    wl_shm__impl        wl_shm;
    wl_shm_pool__impl   wl_shm_pool;
    wl_buffer__impl     wl_buffer;

    xdg_wm_base__impl   xdg_wm_base;
    xdg_surface__impl   xdg_surface;
    xdg_toplevel__impl  xdg_toplevel;

    Input               input;

    bool                done;

    //
    struct 
    Input {
        wl_keyboard*   keyboard;
        wl_pointer*    pointer;
        wl_touch*      touch;
    }
}

// wl_display
struct
wl_display__impl {
    wl_display* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    auto
    get_registry () {
        import wayland_struct.protocol.wayland : wl_registry,wl_registry_interface;
        return 
            cast (wl_registry*)
            wl_proxy_marshal_flags (
                cast (wl_proxy*) _super, 
                display_opcode_get_registry, 
                &wl_registry_interface, 
                wl_proxy_get_version (cast (wl_proxy *) _super),
                0,
                null
            );
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
    }

    typeof(_super).Listener listener = {
        &global,
        &global_remove,
    };

    extern (C)
    static
    void 
    global (void* ctx, wl_registry* _this, uint name, const(char)* interface_, uint version_) {
        printf ("%d: %s\n", name, interface_);
        auto _ctx =  cast (wayland_ctx*) ctx;

        mixin (BIND!xdg_wm_base);
        mixin (BIND!wl_seat);
        mixin (BIND!wl_compositor);
        mixin (BIND!wl_shm);
    }

    extern (C) 
    static
    void 
    global_remove (void* ctx, wl_registry* _this, uint name) {
        //
    }
}

// wl_compositor
struct
wl_compositor__impl {
    wl_compositor* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }
}

// wl_surface
struct
wl_surface__impl {
    wl_surface* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        &enter,
        &leave,
        &preferred_buffer_scale,
        &preferred_buffer_transform,
    };

    extern (C)
    static
    void
    enter (void* ctx, wl_surface* _this /* args: */ , wl_output* output) {
        // 
    }

    extern (C)
    static
    void
    leave (void* ctx, wl_surface* _this /* args: */ , wl_output* output) {
        // 
    }

    extern (C)
    static
    void
    preferred_buffer_scale (void* ctx, wl_surface* _this /* args: */ , int factor) {
        // 
    }

    extern (C)
    static
    void
    preferred_buffer_transform (void* ctx, wl_surface* _this /* args: */ , uint transform) {
        // 
    }
}

// wl_shm
struct
wl_shm__impl {
    wl_shm* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        &format,
    };

    extern (C)
    static
    void
    format (void* ctx, wl_shm* _this /* args: */ , uint format) {
        // 
    }
}

// wl_shm_pool
struct
wl_shm_pool__impl {
    wl_shm_pool* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
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
    }

    typeof(_super).Listener listener = {
        &capabilities,
        &name,
    };

    extern (C)
    static
    void
    capabilities (void* ctx, wl_seat* _this /* args: */ , uint capabilities) {
        auto _ctx = cast (wayland_ctx*) ctx;
        if (capabilities & wl_seat.capability_.keyboard) {
            printf ("seat.cap: keyboard\n");
            _ctx.input.keyboard = _ctx.wl_seat.get_keyboard ();
            printf ("keyboard: %p\n", _ctx.input.keyboard);
        }
        if (capabilities & wl_seat.capability_.pointer) {
            printf ("seat.cap: pointer\n");
            _ctx.input.pointer = _ctx.wl_seat.get_pointer ();
            printf ("pointer: %p\n", _ctx.input.pointer);
        }
        if (capabilities & wl_seat.capability_.touch) {
            printf ("seat.cap: touch\n");
            _ctx.input.touch = _ctx.wl_seat.get_touch ();
            printf ("touch: %p\n", _ctx.input.touch);
        }
    }

    extern (C)
    static
    void
    name (void* ctx, wl_seat* _this /* args: */ , const(char)* name) {
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
    }

    typeof(_super).Listener listener = {
        &release,
    };

    extern (C)
    static
    void
    release (void* ctx, wl_buffer* _this /* args: */ ) {
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
        /*ping:*/ &ping,
    };

    extern (C)
    static
    void
    ping (void* ctx, typeof(_super) _this /* args: */ , uint serial) {
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
        configure: &configure,
    };

    extern (C)
    static
    void
    configure (void* ctx, xdg_surface* _this /* args: */ , uint serial) {
        auto _ctx = cast (wayland_ctx*) ctx;
        _this.ack_configure (serial);

        with (_ctx) {
            auto buffer = draw_frame (_ctx);
            if (buffer !is null) {
                wl_surface.attach (buffer, 0, 0);
                wl_surface.commit ();
            }
        }
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


template
BIND (T) {
    enum BIND = format!"
        if (strcmp (_ctx.%s.IFACE.name, interface_) == 0) {
            _ctx.%s = cast (%s*) _this.bind (name, &_ctx.%s.IFACE, version_); 

            static if (__traits (hasMember, _ctx.%s, \"listener\")) {
                _ctx.%s.add_listener (&_ctx.%s.listener,_ctx);
            }
        }
        "
        (T.stringof, T.stringof, T.stringof, T.stringof, T.stringof, T.stringof, T.stringof);
}

