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
        if (wl_display.dispatch () < 0) {
            printf ("loop: dispatch 1\n");
            perror ("Main loop error");
            done = true;
            return done;
        }
        else {
            return done;
        }
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
        wl_keyboard__impl wl_keyboard;
        wl_pointer__impl  wl_pointer;
        wl_touch__impl    wl_touch;
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
        with (_ctx) {
            if (capabilities & wl_seat.capability_.keyboard) {
                input.wl_keyboard = wl_seat.get_keyboard ();
                input.wl_keyboard.add_listener (&input.wl_keyboard.listener,ctx);  // wl_proxy.add_listener
            }
            if (capabilities & wl_seat.capability_.pointer) {
                input.wl_pointer = wl_seat.get_pointer ();
                input.wl_pointer.add_listener (&input.wl_pointer.listener,ctx);  // wl_proxy.add_listener
            }
            if (capabilities & wl_seat.capability_.touch) {
                input.wl_touch = wl_seat.get_touch ();
                input.wl_touch.add_listener (&input.wl_touch.listener,ctx);  // wl_proxy.add_listener
            }
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


// wl_pointer
struct
wl_pointer__impl {
    wl_pointer* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        &enter,
        &leave,
        &motion,
        &button,
        &axis,
        &frame,
        &axis_source,
        &axis_stop,
        &axis_discrete,
        &axis_value120,
        &axis_relative_direction,
    };

    extern (C)
    static
    void
    enter (void* ctx, wl_pointer* _this /* args: */ , uint serial, wl_surface* surface, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        // 
    }

    extern (C)
    static
    void
    leave (void* ctx, wl_pointer* _this /* args: */ , uint serial, wl_surface* surface) {
        // 
    }

    extern (C)
    static
    void
    motion (void* ctx, wl_pointer* _this /* args: */ , uint time, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        writeln ("MOTION: x,y: ", surface_x.to_int, ",", surface_y.to_int);
    }

    extern (C)
    static
    void
    button (void* ctx, wl_pointer* _this /* args: */ , uint serial, uint time, uint button, uint state) {
        writeln ("BTN: ", decode_btn (button), ": ", cast(wl_pointer.button_state_) state);
        with (cast (wayland_ctx*) ctx) {
            if (button == BTN_LEFT)
                done = true;
        }
    }

    extern (C)
    static
    void
    axis (void* ctx, wl_pointer* _this /* args: */ , uint time, uint axis, wl_fixed_t value) {
        writeln ("AXIS: ", cast (wl_pointer.axis_) axis, ": ", value.to_int);
    }

    extern (C)
    static
    void
    frame (void* ctx, wl_pointer* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    axis_source (void* ctx, wl_pointer* _this /* args: */ , uint axis_source) {
        writeln ("AXIS_SOURCE: ", cast (wl_pointer.axis_source_) axis_source);
    }

    extern (C)
    static
    void
    axis_stop (void* ctx, wl_pointer* _this /* args: */ , uint time, uint axis) {
        writeln ("AXIS_STOP: ", cast (wl_pointer.axis_) axis);
    }

    extern (C)
    static
    void
    axis_discrete (void* ctx, wl_pointer* _this /* args: */ , uint axis, int discrete) {
        writeln ("AXIS_DISCRETE: ", cast (wl_pointer.axis_) axis, ": ", discrete);
    }

    extern (C)
    static
    void
    axis_value120 (void* ctx, wl_pointer* _this /* args: */ , uint axis, int value120) {
        // 
    }

    extern (C)
    static
    void
    axis_relative_direction (void* ctx, wl_pointer* _this /* args: */ , uint axis, uint direction) {
        writeln ("AXIS_DIRECTION: ", cast (wl_pointer.axis_) axis, ": ", cast (wl_pointer.axis_relative_direction_) direction);
    }
}

// wl_keyboard
struct
wl_keyboard__impl {
    wl_keyboard* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        &keymap,
        &enter,
        &leave,
        &key,
        &modifiers,
        &repeat_info,
    };

    extern (C)
    static
    void
    keymap (void* ctx, wl_keyboard* _this /* args: */ , uint format, int fd, uint size) {
        // 
    }

    extern (C)
    static
    void
    enter (void* ctx, wl_keyboard* _this /* args: */ , uint serial, wl_surface* surface, wl_array* keys) {
        // 
    }

    extern (C)
    static
    void
    leave (void* ctx, wl_keyboard* _this /* args: */ , uint serial, wl_surface* surface) {
        // 
    }

    extern (C)
    static
    void
    key (void* ctx, wl_keyboard* _this /* args: */ , uint serial, uint time, uint key, uint state) {
        writeln ("KEY: ", decode_key (key), ": ", cast(wl_keyboard.key_state_) state);
        with (cast (wayland_ctx*) ctx) {
            if (key ==KEY_ESC)
                done = true;
        }
    }

    extern (C)
    static
    void
    modifiers (void* ctx, wl_keyboard* _this /* args: */ , uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group) {
        // 
    }

    extern (C)
    static
    void
    repeat_info (void* ctx, wl_keyboard* _this /* args: */ , int rate, int delay) {
        // 
    }
}

// wl_touch
struct
wl_touch__impl {
    wl_touch* _super;
    alias _super this;

    void
    opAssign (typeof(_super) b) {
        _super = b;
    }

    typeof(_super).Listener listener = {
        &down,
        &up,
        &motion,
        &frame,
        &cancel,
        &shape,
        &orientation,
    };

        extern (C)
    static
    void
    down (void* ctx, wl_touch* _this /* args: */ , uint serial, uint time, wl_surface* surface, int id, wl_fixed_t x, wl_fixed_t y) {
        // 
    }

    extern (C)
    static
    void
    up (void* ctx, wl_touch* _this /* args: */ , uint serial, uint time, int id) {
        // 
    }

    extern (C)
    static
    void
    motion (void* ctx, wl_touch* _this /* args: */ , uint time, int id, wl_fixed_t x, wl_fixed_t y) {
        // 
    }

    extern (C)
    static
    void
    frame (void* ctx, wl_touch* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    cancel (void* ctx, wl_touch* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    shape (void* ctx, wl_touch* _this /* args: */ , int id, wl_fixed_t major, wl_fixed_t minor) {
        // 
    }

    extern (C)
    static
    void
    orientation (void* ctx, wl_touch* _this /* args: */ , int id, wl_fixed_t orientation) {
        // 
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

auto
to_float (wl_fixed_t a) {
    return 1.0f * (a / 2^^8) + (1.0f * (a & 0xFF) / 0xFF);
}auto
to_int (wl_fixed_t a) {
    return (a / 2^^8) + (a & 0xFF) / 0xFF;
}