module wayland_struct.other;

version (NEVER):
public import wayland.client;
public import wayland.client.dy_loader;
public import wayland.client.egl;
import std.stdio             : printf;
import core.sys.posix.signal : timespec;
import core.stdc.string      : strcmp;


// https://wayland.freedesktop.org/docs/html/apb.html#Client-classwl__display


struct
Wayland {
    pragma (inline,true):
    Display display ()                  { return cast(Display) (wl_display_connect (null)); }
    Display display (const char *name)  { return cast(Display) (wl_display_connect (name)); }  // name, NULL, from: env WAYLAND_DISPLAY, env WAYLAND_SOCKET, env XDG_RUNTIME_DIR
    Display display (int fd)            { return cast(Display) (wl_display_connect_to_fd (fd)); }

    wayland_ctx* ctx ()                  { return new wayland_ctx (); }
}



struct
Registry {
    wl_registry* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_registry_listener* listener, void* data) { return wl_registry_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_registry_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_registry_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_registry_get_version (_super); }
    void   destroy       ()                                             {        wl_registry_destroy (_super); }
    //void   release       ()                                             {        wl_registry_release (_super); }

    void*  bind (uint name, const wl_interface* interface_, uint version_) { return wl_registry_bind (_super,name,interface_,version_); }
}



struct
Events {
    // two steps: 
    // queueing
    //   data coming from the display fd is interpreted and added to a queue
    // dispatching
    //   handler for the incoming event set by the client on the corresponding wl_proxy is called
    //
    // default queue
}

struct
Queue {
    wl_event_queue* _super;
    alias _super this;

    pragma (inline,true):
    void        destroy  () {        wl_event_queue_destroy (_super); }
    //const char* get_name () { return wl_event_queue_get_name (_super); }
}

struct
Log {
    //... _super;
    //alias _super this;
    static
    void set_handler_client (wl_log_func_t handler) { wl_log_set_handler_client (handler); }

    alias handler_cb = extern (C) void function (const char* fmt, const void* args);
}

// wl_fixed_t

struct
Surface {  // surface -  is a rectangular area that is displayed on the screen
    wl_surface* _super;
    alias _super this;

    pragma (inline,true):
    int       add_listener         (const wl_surface_listener* listener, void* data) { return wl_surface_add_listener (_super,listener,data); }
    void      set_user_data        (void* user_data)                              {        wl_surface_set_user_data (_super,user_data); }
    void*     get_user_data        ()                                             { return wl_surface_get_user_data (_super); }
    //uint      get_version          ()                                             { return wl_surface_get_version (_super); }
    void      destroy              ()                                             {        wl_surface_destroy (_super); }
    //void      release              ()                                             {        wl_seat_release (_super); }
    void      attach               (Buffer buffer, int x, int y)                  {        wl_surface_attach(_super,buffer,x,y); }
    void      damage               (int x, int y, int width, int height)          {        wl_surface_damage (_super,x,y,width,height); }
    Callback  frame                ()                                             { return cast(Callback) (wl_surface_frame (_super)); }
    void      set_opaque_region    (Region region)                                {       wl_surface_set_opaque_region (_super,region); }
    void      set_input_region     (Region region)                                {       wl_surface_set_input_region (_super,region); }
    void      commit               ()                                             {       wl_surface_commit (_super); }
    void      set_buffer_transform (int transform)                                {       wl_surface_set_buffer_transform (_super,transform); }
    void      set_buffer_scale     (int scale)                                    {       wl_surface_set_buffer_scale (_super,scale); }
    //void      damage_buffer        (int x, int y, int width, int height)          {       wl_surface_damage_buffer (_super,x,y,width,height); }
    //void      offset               (int x, int y)                                 {       wl_surface_offset (_super,x,y); }
}

struct
Callback {
    wl_callback* _super;
    alias _super this;

    pragma (inline,true):
}

struct
Buffer {
    wl_buffer* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_Buffer_listener* listener, void* data) { return wl_seat_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_buffer_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_buffer_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_buffer_get_version (_super); }
    void   destroy       ()                                             {        wl_buffer_destroy (_super); }
    //void   release       ()                                             {        wl_buffer_release (_super); }
}

struct
Data_device_manager {
    wl_data_device_manager* _super;
    alias _super this;

    pragma (inline,true):
    void  set_user_data (void *user_data)       {        wl_data_device_manager_set_user_data (_super,user_data); }
    void* get_user_data ()                      { return wl_data_device_manager_get_user_data (_super); }
    //uint  get_version ()                        {        wl_data_device_manager_get_version (_super); }
    void  destroy ()                            {        wl_data_device_manager_destroy (_super); }
    DataSource create_data_source ()       { return cast (DataSource) wl_data_device_manager_create_data_source (_super); }
    DataDevice get_data_device (Seat seat) { return cast (DataDevice) wl_data_device_manager_get_data_device (_super,seat); }
}

struct
DataDevice {
    wl_data_device* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_data_device_listener* listener, void* data)   { return wl_data_device_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_data_device_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_data_device_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_data_device_get_version (_super); }
    void   destroy       ()                                             {        wl_data_device_destroy (_super); }
    //void   release       ()                                             {        wl_data_device_release (_super); }
    void   start_drag    (DataSource source, Surface origin, Surface icon, uint serial) { wl_data_device_start_drag(_super,source,origin,icon,serial); }
    void   set_selection (DataSource source, uint serial)               {        wl_data_device_set_selection (_super,source,serial); }
}

struct
DataSource {
    wl_data_source* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_data_source_listener* listener, void* data)   { return wl_data_source_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_data_source_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_data_source_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_pointer_get_version (_super); }
    void   destroy       ()                                             {        wl_data_source_destroy (_super); }
    //void   release       ()                                             {        wl_data_source_release (_super); }
    void   offer         (const char *mime_type)                        {        wl_data_source_offer (_super,mime_type); }
}

struct
Shell {
    wl_shell* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subsurface* listener, void* data) { return wl_shell_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)       {        wl_shell_set_user_data (_super,user_data); }
    void*  get_user_data ()                      { return wl_shell_get_user_data (_super); }
    //uint   get_version   ()                      { return wl_shell_get_version (_super); }
    void   destroy       ()                      {        wl_shell_destroy (_super); }
    Shell_surface get_shell_surface (Surface surface) { return cast (Shell_surface) wl_shell_get_shell_surface (_super,surface); }
}

struct
Shell_surface {
    wl_shell_surface* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_shell_surface_listener* listener, void* data) { return wl_shell_surface_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)       {        wl_shell_surface_set_user_data (_super,user_data); }
    void*  get_user_data ()                      { return wl_shell_surface_get_user_data (_super); }
    //uint   get_version   ()                      { return wl_shell_surface_get_version (_super); }
    void   destroy       ()                      {        wl_shell_surface_destroy (_super); }
    void   pong (uint serial)                    {        wl_shell_surface_pong (_super,serial); }
    void   move (Seat seat, uint serial)         {        wl_shell_surface_move (_super,seat,serial); }
    void   resize (Seat seat, uint serial, uint edges) {         wl_shell_surface_resize (_super,seat,serial,edges); }
    void   set_toplevel ()                       {        wl_shell_surface_set_toplevel (_super); }
    void   set_transient (Surface parent, int x, int y, uint flags) {        wl_shell_surface_set_transient (_super,parent,x,y,flags); }
    void   set_fullscreen (uint method, uint framerate, Output output) {         wl_shell_surface_set_fullscreen (_super,method,framerate,output); }
    void   set_popup (Seat seat, uint serial, Surface parent, int x, int y, uint flags) {         wl_shell_surface_set_popup (_super,seat,serial,parent,x,y,flags); }
    void   set_maximized (Output output)         {        wl_shell_surface_set_maximized (_super,output); }
    void   set_title (const char *title)         {        wl_shell_surface_set_title (_super,title); }
    void   set_class (const char *class_)        {        wl_shell_surface_set_class (_super,class_); }
}

struct
Seat {
    wl_seat* _super;
    alias _super this;

    pragma (inline,true):
    Keyboard keyboard () { return cast(Keyboard) (wl_seat_get_keyboard (_super)); }
    Pointer  pointer  () { return cast(Pointer)  (wl_seat_get_pointer (_super)); }
    Touch    touch    () { return cast(Touch)    (wl_seat_get_touch (_super)); }

    int      add_listener  (const wl_seat_listener* listener, void* data) { return wl_seat_add_listener (_super,listener,data); }
    void     set_user_data (void* user_data)                              {        wl_seat_set_user_data (_super,user_data); }
    void*    get_user_data ()                                             { return wl_seat_get_user_data (_super); }
    //uint     get_version   ()                                             { return wl_seat_get_version (_super); }
    void     destroy       ()                                             {        wl_seat_destroy (_super); }
    //void     release       ()                                             {        wl_seat_release (_super); }
}

struct
Pointer {
    wl_pointer * _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_pointer_listener* listener, void* data) { return wl_pointer_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_pointer_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_pointer_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_pointer_get_version (_super); }
    void   destroy       ()                                             {        wl_pointer_destroy (_super); }
    void   release       ()                                             {        wl_pointer_release (_super); }
    void   set_cursor    (uint serial, wl_surface* surface, int hotspot_x, int hotspot_y) 
                                                                        {        wl_pointer_set_cursor(_super,serial,surface,hotspot_x,hotspot_y); }
}

struct
Keyboard {
    wl_keyboard* _super;
    alias _super this;
    
    pragma (inline,true):
    int    add_listener  (const wl_keyboard_listener* listener, void* data) { return wl_keyboard_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_keyboard_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_keyboard_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_keyboard_get_version (_super); }
    void   destroy       ()                                             {        wl_keyboard_destroy (_super); }
    void   release       ()                                             {        wl_keyboard_release (_super); }
}

struct
Touch {
    wl_touch* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_touch_listener* listener, void* data) { return wl_touch_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_touch_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_touch_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_touch_get_version (_super); }
    void   destroy       ()                                             {        wl_touch_destroy (_super); }
    void   release       ()                                             {        wl_touch_release (_super); }
    
}

struct
Output {
    wl_output* _super;
    alias _super this;

    pragma (inline,true):
    int    add_listener  (const wl_output_listener* listener, void* data) { return wl_output_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_output_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_output_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_output_get_version (_super); }
    void   destroy       ()                                             {        wl_output_destroy (_super); }
    //void   release       ()                                             {        wl_output_release (_super); }
    
}

struct
Region {
    wl_region* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_region_listener* listener, void* data) { return wl_seat_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_region_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_region_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_region_get_version (_super); }
    void   destroy       ()                                             {        wl_region_destroy (_super); }
    //void   release       ()                                             {        wl_region_release (_super); }
    void   add           (int x, int y, int width, int height)          {        wl_region_add (_super,x,y,width,height); }
    void   subtract      (int x, int y, int width, int height) 
                                                                        {        wl_region_subtract (_super,x,y,width,height); }
}

struct
Subcompositor {
    wl_subcompositor* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subcompositor_listener* listener, void* data) { return wl_subcompositor_add_listener (_super,listener,data); }
    void       set_user_data (void* user_data)                              {        wl_subcompositor_set_user_data (_super,user_data); }
    void*      get_user_data ()                                             { return wl_subcompositor_get_user_data (_super); }
    //uint       get_version   ()                                             { return wl_subcompositor_get_version (_super); }
    void       destroy       ()                                             {        wl_subcompositor_destroy (_super); }
    //void       release       ()                                             {        wl_subcompositor_release (_super); }
    Subsurface get_subsurface (Surface surface, Surface parent)         { return cast(Subsurface) (wl_subcompositor_get_subsurface (_super,surface,parent)); }
}

struct
Subsurface {
    wl_subsurface* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subsurface* listener, void* data) { return wl_subsurface_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_subsurface_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_subsurface_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_subsurface_get_version (_super); }
    void   destroy       ()                                             {        wl_subsurface_destroy (_super); }
    //void   release       ()                                             {        wl_subsurface_release (_super); }
    void   set_position  (int x, int y)                                 {         wl_subsurface_set_position(_super,x,y); }
    void   place_above   (Surface sibling)                              {         wl_subsurface_place_above(_super,sibling); }
    void   place_below   (Surface sibling)                              {         wl_subsurface_place_below(_super,sibling); }
    void   set_sync      ()                                             {         wl_subsurface_set_sync (_super); }
    void   set_desync    ()                                             {         wl_subsurface_set_desync (_super); }
}

struct
Compositor {
    wl_compositor* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subsurface* listener, void* data) { return wl_compositor_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_compositor_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_compositor_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_compositor_get_version (_super); }
    void   destroy       ()                                             {        wl_compositor_destroy (_super); }
    //void   release       ()                                             {        wl_compositor_release (_super); }

    Surface create_surface () { return cast (Surface) wl_compositor_create_surface (_super); }
    Region  create_region  () { return cast (Region)  wl_compositor_create_region  (_super); }
}

struct
Shm {
    wl_shm* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subsurface* listener, void* data) { return wl_shm_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_shm_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_shm_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_shm_get_version (_super); }
    void   destroy       ()                                             {        wl_shm_destroy (_super); }
    //void   release       ()                                             {        wl_shm_release (_super); }

    Shm_pool create_pool (int fd, int size)                             { return cast (Shm_pool) wl_shm_create_pool(_super,fd,size); }
}

struct
Shm_pool {
    wl_shm_pool* _super;
    alias _super this;

    pragma (inline,true):
    //int    add_listener  (const wl_subsurface* listener, void* data) { return wl_shm_pool_add_listener (_super,listener,data); }
    void   set_user_data (void* user_data)                              {        wl_shm_pool_set_user_data (_super,user_data); }
    void*  get_user_data ()                                             { return wl_shm_pool_get_user_data (_super); }
    //uint   get_version   ()                                             { return wl_shm_pool_get_version (_super); }
    void   destroy       ()                                             {        wl_shm_pool_destroy (_super); }
    //void   release       ()                                             {        wl_shm_pool_release (_super); }

    Buffer create_buffer (int offset, int width, int height, int stride, uint format) { return cast (Buffer) wl_shm_pool_create_buffer (_super,offset,width,height,stride,format); }
    void   resize        (int size) { wl_shm_pool_resize (_super,size); }
}


/*
struct 
pointer_state {
    wl_pointer* pointer;
    uint32_t    serial;
}

static 
void 
pointer_enter (void* data, wl_pointer* pointer, uint32_t serial, wl_surface* surface) {
    pointer_state* ps = cast (pointer_state*) data;
    ps.serial = serial;
    printf ("Pointer entered surface\n");
}

static 
void 
pointer_motion (void* data, wl_pointer* pointer, uint32_t time, wl_fixed_t surface_x, wl_fixed_t surface_y) {
    pointer_state* ps = cast (pointer_state*) data;
    printf ("Pointer moved to (%f, %f)\n",
           wl_fixed_to_double (surface_x), wl_fixed_to_double (surface_y));
}

void 
setup_pointer (app_state* state) {
    auto ps = new pointer_state ();
    ps.pointer = wl_display_bind (state.display, null);

    auto lst = new wl_pointer_listener (
        .enter  = &pointer_enter,
        .motion = &pointer_motion
    );
    
    wl_pointer_add_listener (ps.pointer, &lst, ps);
}

struct 
app_state {
    wl_display* display;
    wl_registry* registry;
}

alias uint32_t = uint;
*/



struct
Registry_listener {
    static
    wl_registry_listener listener = 
        wl_registry_listener (
            &global,
            &global_remove,
        );

    extern (C)
    static 
    void 
    global (void* data, wl_registry* wl_registry, uint name, const char* interface_, uint version_) {
        wayland_ctx* ctx = cast (wayland_ctx*) data;
        printf ("registry.global: %s\n", interface_);

        if (!strcmp (interface_,wl_compositor_interface.name)) {
            ctx.compositor = cast (Compositor) cast (wl_compositor*) ctx.registry.bind (name, wl_compositor_interface, 1);

        } else 
        if (!strcmp (interface_,wl_shm_interface.name)) {
            ctx.shm = cast (Shm) cast (wl_shm*) ctx.registry.bind (name, wl_shm_interface, min (version_, 1));

        } else 
        if (!strcmp(interface_, xdg_wm_base_interface.name)) {  // xdg_wm_base
            ctx.xdg_wm_base = wl_registry_bind (registry, name, xdg_wm_base_interface, 1);
            xdg_wm_base_add_listener(xdg_wm_base, &xdg_wm_base_listener, NULL);
        } else 
        if (!strcmp(interface_, wl_shell_interface.name)) {  // wl_shell | gtk_shell1
            ctx.shell = cast (Shell) cast (wl_shell*) ctx.registry.bind (name, wl_shell_interface, min (version_, 1));
        } else 
        if (!strcmp(interface_, "gtk_shell1")) {
            //ctx.gtk_shell = cast (GTK_shell) cast (wl_shell*) ctx.registry.bind (name, wl_shell_interface, min (version_, 1));
            // gtk_shell1
            // gtk_surface1

        } else 
        if (!strcmp (interface_,wl_seat_interface.name)) {
            printf ("interface: seat: %s\n", wl_seat_interface.name);
            ctx.seat = cast (Seat) cast (wl_seat*) ctx.registry.bind (name, wl_seat_interface, min (version_, 1));
            ctx.seat.add_listener (&Seat_listener.listener, ctx);

        //} else 
        //if (!strcmp (interface_,"xdg_wm_base")) {
        //    ctx.xdg_wm_base = wl_registry_bind (ctx.wl_registry, name, xdg_wm_base_interface, 1);
        //    xdg_wm_base_add_listener (ctx.xdg_wm_base, &wayland_xdg_wm_base_listener, ctx);

        //} else 
        //if (!strcmp (interface_, "wl_output")) {
        //    wl_output* wl_output = cast (wl_output*) wl_registry_bind (ctx.wl_registry, name, wl_output_interface, 1);
        //    wl_output_add_listener (wl_output, &wayland_output_listener, null);
        }
    }

    extern (C)
    static 
    void 
    global_remove (void* data, wl_registry* wl_registry, uint name) {
        //
    }
}

struct
Seat_listener {
    static
    wl_seat_listener listener = wl_seat_listener (
        capabilities: &capabilities,
        name:         &name,
    );
    
    extern (C)
    static 
    void
    capabilities (void *data, wl_seat* wl_seat, uint capabilities) {
        printf ("  seat.capabilities: %x\n", capabilities);

        auto ctx   = cast (wayland_ctx*) data;
        auto input = &ctx.input;

        if (capabilities & WL_SEAT_CAPABILITY_POINTER) {
            input.pointer = (cast (Seat) wl_seat).pointer;
            printf ("    pointer: %p\n", &input.pointer);
            input.pointer.add_listener (&Pointer_listener.listener, &ctx.input);
        }
        if (capabilities & WL_SEAT_CAPABILITY_KEYBOARD) {
            input.keyboard = (cast (Seat) wl_seat).keyboard;
            printf ("    keyboard: %p\n", &input.keyboard);
            input.keyboard.add_listener (&Keyboard_listener.listener, &ctx.input);
        }
        if(capabilities & WL_SEAT_CAPABILITY_TOUCH) {
            input.touch = (cast (Seat) wl_seat).touch ();
            printf ("    touch: %p\n", &input.touch);
            input.touch.add_listener (&Touch_listener.listener, &ctx.input);
        }
    }

    extern (C)
    static 
    void
    name (void *data, wl_seat *wl_seat, const char *name) {
        printf ("  seat.name: %s\n", name);
    }
}

struct
Pointer_listener {
    static
    wl_pointer_listener listener = 
        wl_pointer_listener (
            &enter,
            &leave,
            &motion,
            &button,
            &axis,
        );

    extern (C)
    static 
    void 
    enter (void *data, wl_pointer *wl_pointer, uint serial, wl_surface *surface, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        printf ("  pointer.enter: surface: %p, xy: (%d,%d)\n", surface, surface_x, surface_y);
    }

    extern (C)
    static 
    leave (void *data, wl_pointer *wl_pointer, uint serial, wl_surface *surface) {
        printf ("  pointer.leave: surface: %p\n", surface);
    } 

    extern (C)
    static 
    void 
    motion (void *data, wl_pointer *wl_pointer, uint time, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        printf ("  pointer.motion: xy: (%d,%d)\n", surface_x, surface_y);
    }

    extern (C)
    static 
    void 
    button (void *data, wl_pointer *wl_pointer, uint serial, uint time, uint button, uint state) {
        printf ("  pointer.button: button: %d: %d\n", button, state);
    }

    extern (C)
    static 
    void 
    axis (void *data, wl_pointer *wl_pointer, uint time, uint axis, wl_fixed_t value) {
        printf ("  pointer.axis: axis: %d: %d\n", axis, value);
    }
}

struct
Keyboard_listener {
    static
    wl_keyboard_listener listener = 
        wl_keyboard_listener (
            &keymap,
            &enter,
            &leave,
            &key,
            &modifiers,
            &repeat_info,
        );

    extern (C)
    static 
    void 
    keymap (void *data, wl_keyboard *wl_keyboard, uint format, int fd, uint size) {
        //
    }

    extern (C)
    static 
    void 
    enter (void *data, wl_keyboard *wl_keyboard, uint serial, wl_surface *surface, wl_array *keys) {
        //
    }

    extern (C)
    static 
    void 
    leave (void *data, wl_keyboard *wl_keyboard, uint serial, wl_surface *surface) {
        //
    }

    extern (C)
    static 
    void 
    key (void *data, wl_keyboard *wl_keyboard, uint serial, uint time, uint key, uint state) {
        printf ("  pointer.key: axis: %d: %d\n", key, state);
    }

    extern (C)
    static 
    void 
    modifiers (void *data, wl_keyboard *wl_keyboard, uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group) {
        printf ("  pointer.modifiers: group: %d\n", group);
    }

    extern (C)
    static 
    void 
    repeat_info (void *data, wl_keyboard *wl_keyboard, int rate, int delay) {
        printf ("  pointer.repeat_info: group: %d,%d\n", rate, delay);
    }
}

struct
Touch_listener {
    static
    wl_touch_listener listener = 
        wl_touch_listener (
            &down,
            &up,
            &motion,
            &frame,
            &cancel,
        );

    extern (C)
    static 
    void 
    down (void *data, wl_touch *wl_touch, uint serial, uint time, wl_surface *surface, int id, wl_fixed_t x, wl_fixed_t y) {
        //
    }

    extern (C)
    static 
    void 
    up (void *data, wl_touch *wl_touch, uint serial, uint time, int id) {
        //
    }

    extern (C)
    static 
    void 
    motion (void *data, wl_touch *wl_touch, uint time, int id, wl_fixed_t x, wl_fixed_t y)  {
        //
    }

    extern (C)
    static 
    void 
    frame (void *data, wl_touch *wl_touch) {
        //
    }

    extern (C)
    static 
    void 
    cancel (void *data, wl_touch *wl_touch) {
        //
    }    
}


