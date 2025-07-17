import wayland.client;
import wayland.client.dy_loader;
import std.stdio : printf;
import core.sys.posix.signal : timespec;

pragma (lib, "wayland-client");
// libwayland-client0
// libwayland-dev
//
// /usr/include/wayland-client-core.h
// /usr/include/wayland-client-protocol.h
// /usr/include/wayland-client.h
// /usr/include/wayland-cursor.h
// /usr/include/wayland-egl-core.h
// /usr/include/wayland-egl.h
// /usr/include/wayland-server-core.h
// /usr/include/wayland-server-protocol.h
// /usr/include/wayland-server.h
// /usr/include/wayland-util.h
// /usr/include/wayland-version.h

// https://wayland.freedesktop.org/docs/html/apb.html#Client-classwl__display


struct
Wayland {
    pragma (inline,true):
    Display display ()                  { return Display (wl_display_connect (null)); }
    Display display (const char *name)  { return Display (wl_display_connect (name)); }  // name, NULL, from: env WAYLAND_DISPLAY, env WAYLAND_SOCKET, env XDG_RUNTIME_DIR
    Display display (int fd)            { return Display (wl_display_connect_to_fd (fd)); }
}

struct
Display {
    wl_display* _super;
    alias _super this;

    pragma (inline,true):
    version (WaylandServer)
    Compositor  compositor       ()                         { return Compositor (wl_display_get_registry (_super)); }
    Registry    registry         ()                         { return Registry (wl_display_get_registry (_super)); }
    //Pointer     pointer          ()                         { return Pointer (wl_display_bind (_super, null)); }
    Queue       queue            ()                         { return Queue (wl_display_create_queue (_super)); }
    //Queue       queue            (const char *name)         { return Queue (wl_display_create_queue_with_name (_super,name)); }

    Queue       create_queue     ()                         { return Queue (wl_display_create_queue (_super)); }
    //Queue       create_queue_with_name (const char *name)   { return Queue (wl_display_create_queue_with_name (_super,name)); }
    int         dispatch         ()                         { return wl_display_dispatch (_super); }
    int         dispatch_pending ()                         { return wl_display_dispatch_pending (_super); }
    int         dispatch_queue   (Queue queue)              { return wl_display_dispatch_queue (_super,queue); }
    int         dispatch_queue_pending (Queue queue)        { return wl_display_dispatch_queue_pending (_super,queue); }
    //int         dispatch_queue_timeout (Queue queue, timespec* timeout)  { return wl_display_dispatch_queue_timeout (_super,queue,timeout); }
    void        disconnect       ()                         {        wl_display_disconnect (_super); }
    int         get_fd           ()                         { return wl_display_get_fd (_super); }
    int         roundtrip        ()                         { return wl_display_roundtrip (_super); }
    int         roundtrip_queue  (Queue queue)              { return wl_display_roundtrip_queue (_super,queue); }
    int         read_events      ()                         { return wl_display_read_events (_super); }
    int         prepare_read_queue (Queue queue)            { return wl_display_prepare_read_queue(_super,queue); }
    int         prepare_read     ()                         { return wl_display_prepare_read (_super); }
    void        cancel_read      ()                         { return wl_display_cancel_read (_super); }
    int         get_error        ()                         { return wl_display_get_error (_super); }
    uint        get_protocol_error (const wl_interface** interface_, uint* id) { return wl_display_get_protocol_error (_super,interface_,id); }
    int         fulsh            ()                         { return wl_display_flush (_super); }
    //void        set_max_buffer_size (size_t max_buffer_size) {        wl_display_set_max_buffer_size (_super,max_buffer_size); }
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
Compositor {
    wl_compositor* _super;
    alias _super this;

    pragma (inline,true):
    Surface surface () { return Surface (wl_compositor_create_surface (_super)); }
}

struct
Surface {
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
    Callback  frame                ()                                             { return Callback (wl_surface_frame (_super)); }
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
    //void   release       ()                                             {        wl_seat_release (_super); }
}

struct
Registry {
    wl_registry* _super;
    alias _super this;
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
    wl_data_source* create_data_source ()       { return wl_data_device_manager_create_data_source (_super); }
    wl_data_device* get_data_device (Seat seat) { return wl_data_device_manager_get_data_device (_super,seat); }
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
    void   set_user_data (void* user_data)       {        wl_shell_set_user_data (_super,user_data); }
    void*  get_user_data ()                      { return wl_shell_get_user_data (_super); }
    //uint   get_version   ()                      { return wl_shell_get_version (_super); }
    void   destroy       ()                      {        wl_shell_destroy (_super); }
    ShellSurface get_shell_surface (Surface surface) { return ShellSurface (wl_shell_get_shell_surface (_super,surface)); }
}

struct
ShellSurface {
    wl_shell_surface* _super;
    alias _super this;

    pragma (inline,true):
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
    Keyboard get_keyboard () { return Keyboard (wl_seat_get_keyboard (_super)); }
    Pointer  get_pointer  () { return Pointer  (wl_seat_get_pointer (_super)); }
    Touch    get_touch    () { return Touch    (wl_seat_get_touch (_super)); }

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
    Subsurface get_subsurface (Surface surface, Surface parent)         { return Subsurface (wl_subcompositor_get_subsurface (_super,surface,parent)); }
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


extern (C)
static 
void 
keyboard_handle_keymap (void *data, wl_keyboard* keyboard, uint format, int fd, uint size) {
    //
}

extern (C)
static 
void 
keyboard_handle_enter (void *data, wl_keyboard* keyboard, uint serial, wl_surface* surface, wl_array* keys) {
    //
}

extern (C)
static 
void 
keyboard_handle_leave (void *data, wl_keyboard* keyboard, uint serial, wl_surface* surface) {
    //
}

extern (C)
static 
void 
keyboard_handle_key (void *data, wl_keyboard* keyboard, uint serial, uint time, uint key, uint state_w) {
    //
}

void
listen_keyboard () {
    auto cb = wl_keyboard_listener (
        &keyboard_handle_keymap,
        &keyboard_handle_enter,
        &keyboard_handle_leave,
        &keyboard_handle_key,
    );
}