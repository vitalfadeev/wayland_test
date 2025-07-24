module wayland_struct.util;

extern (C):
struct wl_object;

alias uint32_t   = uint;
alias wl_fixed_t = int;

struct 
wl_array {
    size_t size;
    size_t alloc;
    void*  data;
}

struct 
wl_message {
    const (char*)           name;
    const (char*)           signature;
    const (wl_interface*)*  types;
}

struct 
wl_interface {
    const (char*)       name;
    int                 ver;
    int                 method_count;
    const (wl_message*) methods;
    int                 event_count;
    const (wl_message*) events;
}

//wl_interface 
//foo_interface = wl_interface (
//    "foo", 1,
//    2, foo_requests,
//    1, foo_events
//);

union 
wl_argument {
    int           i; // signed integer
    uint          u; // unsigned integer
    wl_fixed_t    f; // fixed point
    const (char*) s; // string
    wl_object*    o; // object
    uint          n; // new_id
    wl_array*     a; // array
    int           h; // file descriptor
}

alias wl_dispatcher_func_t = int  function (const (void*), void*, uint, const (wl_message*), wl_argument*);
alias wl_log_func_t        = void function (const (char*), ...);

extern __gshared wl_interface wl_display_interface;
extern __gshared wl_interface wl_registry_interface;
extern __gshared wl_interface wl_callback_interface;
extern __gshared wl_interface wl_compositor_interface;
extern __gshared wl_interface wl_shm_pool_interface;
extern __gshared wl_interface wl_shm_interface;
extern __gshared wl_interface wl_buffer_interface;
extern __gshared wl_interface wl_data_offer_interface;
extern __gshared wl_interface wl_data_source_interface;
extern __gshared wl_interface wl_data_device_interface;
extern __gshared wl_interface wl_data_device_manager_interface;
extern __gshared wl_interface wl_shell_interface;
extern __gshared wl_interface wl_shell_surface_interface;
extern __gshared wl_interface wl_surface_interface;
extern __gshared wl_interface wl_seat_interface;
extern __gshared wl_interface wl_pointer_interface;
extern __gshared wl_interface wl_keyboard_interface;
extern __gshared wl_interface wl_touch_interface;
extern __gshared wl_interface wl_output_interface;
extern __gshared wl_interface wl_region_interface;
extern __gshared wl_interface wl_subcompositor_interface;
extern __gshared wl_interface wl_subsurface_interface;
