import std.stdio;
import wayland_struct;
import core.sys.posix.sys.mman : mmap,munmap,PROT_READ,MAP_SHARED,MAP_FAILED;
import core.sys.posix.sys.stat : fstat,stat_t;
import core.sys.posix.fcntl    : open,O_RDWR;
import core.stdc.stdlib        : EXIT_SUCCESS,EXIT_FAILURE;
import core.stdc.stdlib        : free;
import std.conv                : to;

static const uint WIDTH             = 320;
static const uint HEIGHT            = 200;
static const uint CURSOR_WIDTH      = 100;
static const uint CURSOR_HEIGHT     = 59;
static const  int CURSOR_HOT_SPOT_X = 10;
static const  int CURSOR_HOT_SPOT_Y = 35;
static const uint PIXEL_FORMAT_ID   = WL_SHM_FORMAT_ARGB8888;

Shm           shm;
Shm_pool      pool;
Shell_surface surface;
Buffer        buffer;
Compositor    compositor;
Shell         shell;
Pointer       pointer;

static bool   done = false;

void 
on_button (uint button) {
    done = true;
}


int
main () {
    auto wayland  = Wayland ();
    auto ctx     = wayland.ctx ();

    // setup
    ctx.display  = wayland.display;
    ctx.registry = ctx.display.registry;
    ctx.registry.add_listener (&Registry_listener.listener,&ctx);
    ctx.display.roundtrip ();

    //
    auto image = open ("images.bin", O_RDWR);

    if (image < 0) {
        perror ("Error opening surface image");
        return EXIT_FAILURE;
    }

    pool    = hello_create_memory_pool (shm,image);
    surface = hello_create_surface (compositor,shell);
    buffer  = hello_create_buffer (pool, WIDTH, HEIGHT);
              hello_bind_buffer (buffer, surface);
              hello_set_cursor_from_pool (pool, CURSOR_WIDTH, CURSOR_HEIGHT, CURSOR_HOT_SPOT_X, CURSOR_HOT_SPOT_Y);
              hello_set_button_callback (surface,&on_button);

    //
    while (!done) {
        if (ctx.display.dispatch () < 0) {
            perror ("Main loop error");
            done = true;
        }
    }

    printf ("Exiting sample wayland client...\n");

    //
    //hello_free_cursor();
    //hello_free_buffer(buffer);
    //hello_free_surface(surface);
    //hello_free_memory_pool(pool);
    //close(image);
    //hello_cleanup_wayland();

    // cleanup
    ctx.display.disconnect ();
    ctx.registry.destroy ();

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


struct 
pool_data {
    int      fd;
    typeof (stat_t.st_size) capacity;
    typeof (stat_t.st_size) size;
    pixel*   memory;
};
alias uint pixel;


Shm_pool
hello_create_memory_pool (Shm shm, int file) {
    Shm_pool  pool;
    stat_t   _stat;

    if (fstat (file, &_stat) != 0)
        return cast (Shm_pool) null;

    auto data = new pool_data (file,_stat.st_size,0);

    data.memory = cast (pixel*)
        mmap (null, data.capacity, PROT_READ, MAP_SHARED, data.fd, 0);

    if (data.memory == MAP_FAILED)
        goto cleanup_alloc;

    pool = shm.create_pool (data.fd, data.capacity.to!int);

    if (pool == null)
        goto cleanup_mmap;

    pool.set_user_data (data);

    return pool;

cleanup_mmap:
    munmap (data.memory, data.capacity);
cleanup_alloc:
    free (data);
    return cast (Shm_pool) null;
}

extern (C)
static 
void 
shell_surface_ping (void *data, wl_shell_surface* shell_surface, uint serial) {
    wl_shell_surface_pong (shell_surface, serial);
}

extern (C)
static 
void 
shell_surface_configure (void *data, wl_shell_surface *shell_surface, uint edges, int width, int height) { }

static 
const shell_surface_listener = wl_shell_surface_listener (
    ping      : &shell_surface_ping,
    configure : &shell_surface_configure,
);

Shell_surface
hello_create_surface (Compositor compositor, Shell shell) {
    auto surface = compositor.create_surface ();

    if (surface is null)
        return cast (Shell_surface) null;

    auto shell_surface = shell.get_shell_surface (surface);

    if (shell_surface is null) {
        surface.destroy ();
        return cast (Shell_surface) null;
    }


    shell_surface.add_listener (&shell_surface_listener,null);
    shell_surface.set_toplevel ();
    shell_surface.set_user_data (surface);
    surface.set_user_data (null);

    return shell_surface;
}

Buffer
hello_create_buffer (Shm_pool pool, uint width, uint height) {
    auto pool_data = cast (pool_data*) pool.get_user_data ();
    auto buffer    = pool.create_buffer (
        pool_data.size.to!int, width, height,
        width*pixel.sizeof.to!int, PIXEL_FORMAT_ID);

    if (buffer is null)
        return cast (Buffer) null;

    pool_data.size += width*height*pixel.sizeof;

    return buffer;
}

void 
hello_bind_buffer (Buffer buffer, Shell_surface shell_surface) {
    auto surface = cast (Surface) cast (wl_surface*) shell_surface.get_user_data ();
    surface.attach (buffer,0,0);
    surface.commit ();
}

struct 
pointer_data {
    wl_surface* surface;
    wl_buffer*  buffer;
    int         hot_spot_x;
    int         hot_spot_y;
    wl_surface* target_surface;
}

void 
hello_set_cursor_from_pool (Shm_pool pool, uint width, uint height, int hot_spot_x, int hot_spot_y) {
    auto data = new pointer_data ();
    data.hot_spot_x = hot_spot_x;
    data.hot_spot_y = hot_spot_y;
    data.surface    = compositor.create_surface ();

    if (data.surface is null)
        goto cleanup_alloc;

    data.buffer = hello_create_buffer (pool,width,height);

    if (data.buffer is null)
        goto cleanup_surface;

    pointer.set_user_data (data);

    return;

cleanup_surface:
    data.surface.destroy ();
cleanup_alloc:
    free (data);
error:
    perror ("Unable to allocate cursor");
}

void 
hello_set_button_callback (Shell_surface shell_surface, void function (uint) callback) {
    auto surface = cast (Surface) cast (wl_surface*) shell_surface.get_user_data ();
    surface.set_user_data (callback);
}

