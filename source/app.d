import std.stdio;
import core.sys.posix.sys.mman : mmap,munmap,PROT_READ,PROT_WRITE,MAP_SHARED,MAP_FAILED;
import core.sys.posix.sys.stat : fstat,stat_t;
import core.sys.posix.fcntl    : open,O_RDWR;
import core.sys.posix.fcntl    : O_CREAT,O_EXCL;
import core.stdc.stdlib        : EXIT_SUCCESS,EXIT_FAILURE;
import core.stdc.stdlib        : free;
import core.stdc.string        : strcmp;
import std.conv                : to;
import wayland_struct;
import wayland_struct.protocol.wayland;
import wayland_struct.protocol.xdg_shell;
import core.sys.posix.signal   : timespec;
import core.sys.posix.time     : clock_gettime;
import core.sys.posix.time     : CLOCK_REALTIME;
import core.sys.posix.sys.mman : shm_open;
import core.sys.posix.sys.mman : shm_unlink;
import core.stdc.errno         : errno;
import core.stdc.errno         : EEXIST;
import core.stdc.errno         : EINTR;
import core.sys.posix.unistd   : close;
import core.sys.posix.unistd   : ftruncate;
import core.stdc.string        : memset;
import std.conv : octal;


static const uint WIDTH             = 320;
static const uint HEIGHT            = 200;
static const uint CURSOR_WIDTH      = 100;
static const uint CURSOR_HEIGHT     = 59;
static const  int CURSOR_HOT_SPOT_X = 10;
static const  int CURSOR_HOT_SPOT_Y = 35;
static const uint PIXEL_FORMAT_ID   = wl_shm.format_.xrgb8888;

// ctx
static wayland_ctx* ctx;
static bool  done = false;

void 
on_button (uint button) {
    done = true;
}


struct
Wayland {
    pragma (inline,true):
    wl_display*  display ()                  { return (wl_display_connect (null)); }
    wl_display*  display (const char *name)  { return (wl_display_connect (name)); }  // name, NULL, from: env WAYLAND_DISPLAY, env WAYLAND_SOCKET, env XDG_RUNTIME_DIR
    wl_display*  display (int fd)            { return (wl_display_connect_to_fd (fd)); }
    wayland_ctx* ctx ()                      { return new wayland_ctx (); }
}

struct 
wayland_ctx {
    int               width  = 640;
    int               height = 480;
    wl_display*       display;
    wl_registry*      registry;
    wl_seat*          seat;
    wl_compositor*    compositor;
    wl_surface*       surface;
    wl_shm*           shm;
    wl_shm_pool*      pool;

    xdg_wm_base*      _xdg_wm_base;
    xdg_surface*      _xdg_surface;
    xdg_toplevel*     _xdg_toplevel;

    Input          input;

    void* user_ctx;

    struct 
    Input {
        int         repeat_fd;

        wl_keyboard* keyboard;
        wl_pointer*  pointer;
        wl_touch*    touch;
    }
};

auto min (A,B) (A a, B b) { return (a) < (b) ? (a) : (b); }
auto max (A,B) (A a, B b) { return (a) > (b) ? (a) : (b); }


auto
wl_display_get_registry (wl_display* display) {
    return
        cast (wl_registry*) (
            wl_proxy_marshal_constructor (
                cast (wl_proxy*) display, 
                display_opcode_get_registry, 
                &wl_registry_interface, 
                null
            )
        );
}

extern (C)
void 
global_impl (void* ctx, wl_registry* _this, uint name, const(char)* interface_, uint version_) {
    printf ("%d: %s\n", name, interface_);
    auto _ctx =  cast (wayland_ctx*) ctx;

    if (strcmp (xdg_wm_base_interface.name, interface_) == 0) {
        _ctx._xdg_wm_base = cast (xdg_wm_base*) _this.bind (name, &xdg_wm_base_interface, version_);
        _ctx._xdg_wm_base.add_listener (
            new xdg_wm_base.Listener (
                    &_ping_impl
                ), 
                ctx);
    }

    if (strcmp (wl_seat_interface.name, interface_) == 0) {
        _ctx.seat = cast (wl_seat*) _this.bind (name, &wl_seat_interface, version_);
        _ctx.seat.add_listener (
            new wl_seat.Listener (  // is a vector of function pointers. 
                &capabilities_impl,
                &name_impl,
            ),
            ctx);  // wl_proxy.add_listener
    }

    if (strcmp (wl_compositor_interface.name, interface_) == 0) {
        _ctx.compositor = cast (wl_compositor*) _this.bind (name, &wl_compositor_interface, version_);
    }

    if (strcmp (wl_shm_interface.name, interface_) == 0) {
        _ctx.shm = cast (wl_shm*) _this.bind (name, &wl_shm_interface, version_);
    }
}
extern (C) 
void 
global_remove_impl (void* data, wl_registry* _wl_registry, uint name) {
    //
}

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


extern (C)
static
void
_ping_impl (void* ctx, xdg_wm_base* _this /* args: */ , uint serial) {
    _this.pong (serial);
}


static 
string
randname () {
    char[7] buf;
    timespec ts;
    clock_gettime (CLOCK_REALTIME, &ts);
    long r = ts.tv_nsec;
    for (int i = 0; i < 6; ++i) {
        buf[i] = 'A'+(r&15)+(r&16)*2;
        r >>= 5;
    }
    return buf.to!string;
}

static 
int
create_shm_file () {
    int retries = 100;
    do {
        string name = "/wl_shm-" ~ randname ();
        retries--;
        int fd = shm_open (name.ptr, O_RDWR | O_CREAT | O_EXCL, octal!"600");
        if (fd >= 0) {
            shm_unlink (name.ptr);
            return fd;
        }
    } while (retries > 0 && errno == EEXIST);
    return -1;
}

int
allocate_shm_file (size_t size) {
    int fd = create_shm_file ();
    if (fd < 0)
        return -1;
    int ret;
    do {
        ret = ftruncate (fd,size);
    } while (ret < 0 && errno == EINTR);
    if (ret < 0) {
        close (fd);
        return -1;
    }
    return fd;
}

extern (C)
static
void
_release_impl (void* ctx, wl_buffer* _this /* args: */ ) {
    _this.destroy ();
}

static 
wl_buffer*
draw_frame (wayland_ctx* ctx) {
    int stride = ctx.width * 4;
    int size = stride * ctx.height;

    int fd = allocate_shm_file (size);
    if (fd == -1) {
        return null;
    }

    uint* data = cast (uint*) mmap (null, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (data == MAP_FAILED) {
        close (fd);
        return null;
    }

    wl_shm_pool* pool = ctx.shm.create_pool (fd, size);
    wl_buffer* buffer = pool.create_buffer (0, ctx.width, ctx.height, stride, PIXEL_FORMAT_ID);
    pool.destroy ();
    close (fd);

    /* Draw checkerboxed background */
    for (int y = 0; y < ctx.height; ++y) {
        for (int x = 0; x < ctx.width; ++x) {
            if ((x + y / 8 * 8) % 16 < 8)
                data[y * ctx.width + x] = 0xFF666666;
            else
                data[y * ctx.width + x] = 0xFFEEEEEE;
        }
    }

    munmap (data, size);
    buffer.add_listener (new wl_buffer.Listener (&_release_impl), null);
    return buffer;
}

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

int
main () {
    //version (Dynamic) loadWaylandClient ();

    printf ("%s:, %d, %d\n", 
        wl_registry_interface.name, 
        wl_registry_interface.method_count,
        wl_registry_interface.event_count);
    printf ("%s:, %d, %d\n", 
        wl_shm_interface.name, 
        wl_shm_interface.method_count,
        wl_shm_interface.event_count);

    auto wayland  = Wayland ();
         ctx      = wayland.ctx ();

    // setup
    ctx.display  = wayland.display;
    ctx.registry = wl_display_get_registry (ctx.display);
    writeln (1, ": display  : ", ctx.display);
    writeln (1, ": registry : ", ctx.registry);
    ctx.registry.add_listener (
        new wl_registry.Listener (  // is a vector of function pointers. 
            &global_impl,
            &global_remove_impl,
        ),
        ctx);  // wl_proxy.add_listener
    ctx.display.roundtrip ();

    // checks
    if (ctx._xdg_wm_base is null) {
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

    // surface
    ctx.surface       = ctx.compositor.create_surface ();
    ctx._xdg_surface  = ctx._xdg_wm_base.get_xdg_surface (ctx.surface);
    ctx._xdg_surface.add_listener (new xdg_surface.Listener (&_configure_impl), ctx);
    ctx._xdg_toplevel = ctx._xdg_surface.get_toplevel ();
    ctx._xdg_toplevel.set_title ("Example client");
    ctx.surface.commit ();

    // loop
    while (!done) {
        if (ctx.display.dispatch () < 0) {
            printf ("loop: dispatch 1\n");
            perror ("Main loop error");
            done = true;
        }
    }


    // cleanup
    ctx.registry.destroy ();
    ctx.display.disconnect ();

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
