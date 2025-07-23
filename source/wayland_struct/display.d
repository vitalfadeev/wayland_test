module wayland_struct.proxy;

import wayland_struct.types;

extern (C) {
struct wl_display;
}

struct
Display {
    wl_display* _super;
    alias _super this;

    pragma (inline,true):
    Registry    registry         ()                         { return cast(Registry) (wl_display_get_registry (_super)); }
    //Pointer     pointer          ()                         { return Pointer (wl_display_bind (_super, null)); }
    Queue       queue            ()                         { return cast(Queue) (wl_display_create_queue (_super)); }
    //Queue       queue            (const char *name)         { return Queue (wl_display_create_queue_with_name (_super,name)); }

    Queue       create_queue     ()                         { return cast(Queue) (wl_display_create_queue (_super)); }
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
