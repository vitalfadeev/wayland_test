// protocol wayland
module wayland_struct.protocol;

import wayland_struct.proxy : wl_proxy;
import wayland_struct.proxy : wl_proxy_marshal;
import wayland_struct.proxy : wl_proxy_marshal_constructor;
import wayland_struct.proxy : wl_proxy_marshal_constructor_versioned;
import wayland_struct.proxy : wl_proxy_marshal_flags;
import wayland_struct.proxy : wl_proxy_get_version;
import wayland_struct.proxy : wl_proxy_add_listener;
import wayland_struct.proxy : WL_MARSHAL_FLAG_DESTROY;
import wayland_struct.util  : wl_proxy_callback;;
import wayland_struct.util  : wl_message;
import wayland_struct.util  : wl_interface;
import wayland_struct.util  : wl_fixed_t;
import wayland_struct.util  : wl_array;

// module wayland.wl_registry;

struct
wl_registry {
  @disable this();
  @disable this(wl_registry);
  @disable this(ref wl_registry);

  // Requests
  pragma (inline,true):
  void*
  bind (uint name, const wl_interface* interface_, uint version_ ) {
    return cast (void*) 
        wl_proxy_marshal_flags (
            cast (wl_proxy*) &this,
            opcode.bind, 
            interface_, 
            version_, 
            0, 
            name, 
            interface_.name, 
            version_, 
            null
        );
  }

  // Events
  struct
  Listener {
    global_cb        global        = &_global_impl_default;
    global_remove_cb global_remove = &_global_remove_impl_default;

    alias global_cb        = extern (C) void function (void* data, wl_registry* _this /* args: */ , uint name, const(char)* interface_, uint version_);
    alias global_remove_cb = extern (C) void function (void* data, wl_registry* _this /* args: */ , uint name);

    extern (C)
    static
    void
    _global_impl_default (void* data, wl_registry* _this /* args: */ , uint name, const(char)* interface_, uint version_) {
        // 
    }

    extern (C)
    static
    void
    _global_remove_impl_default (void* data, wl_registry* _this /* args: */ , uint name) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Opcodes
  enum
  opcode : uint {
    bind = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_registry_interface;

// module wayland.wl_callback;

struct
wl_callback {
  @disable this();
  @disable this(wl_callback);
  @disable this(ref wl_callback);

  // Events
  struct
  Listener {
    done_cb done = &_done_impl_default;

    alias done_cb = extern (C) void function (void* data, wl_callback* _this /* args: */ , uint callback_data);

    extern (C)
    static
    void
    _done_impl_default (void* data, wl_callback* _this /* args: */ , uint callback_data) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }
}

// interface
extern (C) extern __gshared wl_interface wl_callback_interface;

// module wayland.wl_compositor;

struct
wl_compositor {
  @disable this();
  @disable this(wl_compositor);
  @disable this(ref wl_compositor);

  // Requests
  pragma (inline,true):
  auto create_surface () { return cast (wl_surface*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.create_surface, /* ret interface: */ &wl_surface_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto create_region () { return cast (wl_region*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.create_region, /* ret interface: */ &wl_region_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }

  // Opcodes
  enum
  opcode : uint {
    create_surface = 0,
    create_region = 1,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_compositor_interface;

// module wayland.wl_shm_pool;

struct
wl_shm_pool {
  @disable this();
  @disable this(wl_shm_pool);
  @disable this(ref wl_shm_pool);

  // Requests
  pragma (inline,true):
  auto create_buffer (int offset,int width,int height,int stride,uint format) { return cast (wl_buffer*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.create_buffer, /* ret interface: */ &wl_buffer_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null,offset,width,height,stride,format); }
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto resize (int size) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.resize, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , size); }

  // Opcodes
  enum
  opcode : uint {
    create_buffer = 0,
    destroy = 1,
    resize = 2,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_shm_pool_interface;

// module wayland.wl_shm;

struct
wl_shm {
  @disable this();
  @disable this(wl_shm);
  @disable this(ref wl_shm);

  // Requests
  pragma (inline,true):
  auto create_pool (int fd,int size) { return cast (wl_shm_pool*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.create_pool, /* ret interface: */ &wl_shm_pool_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null,fd,size); }
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    format_cb format = &_format_impl_default;

    alias format_cb = extern (C) void function (void* data, wl_shm* _this /* args: */ , uint format);

    extern (C)
    static
    void
    _format_impl_default (void* data, wl_shm* _this /* args: */ , uint format) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_format = 0,
    invalid_stride = 1,
    invalid_fd = 2,
  }
  enum
  format_ {
    argb8888 = 0,
    xrgb8888 = 1,
    c8 = 0x20203843,
    rgb332 = 0x38424752,
    bgr233 = 0x38524742,
    xrgb4444 = 0x32315258,
    xbgr4444 = 0x32314258,
    rgbx4444 = 0x32315852,
    bgrx4444 = 0x32315842,
    argb4444 = 0x32315241,
    abgr4444 = 0x32314241,
    rgba4444 = 0x32314152,
    bgra4444 = 0x32314142,
    xrgb1555 = 0x35315258,
    xbgr1555 = 0x35314258,
    rgbx5551 = 0x35315852,
    bgrx5551 = 0x35315842,
    argb1555 = 0x35315241,
    abgr1555 = 0x35314241,
    rgba5551 = 0x35314152,
    bgra5551 = 0x35314142,
    rgb565 = 0x36314752,
    bgr565 = 0x36314742,
    rgb888 = 0x34324752,
    bgr888 = 0x34324742,
    xbgr8888 = 0x34324258,
    rgbx8888 = 0x34325852,
    bgrx8888 = 0x34325842,
    abgr8888 = 0x34324241,
    rgba8888 = 0x34324152,
    bgra8888 = 0x34324142,
    xrgb2101010 = 0x30335258,
    xbgr2101010 = 0x30334258,
    rgbx1010102 = 0x30335852,
    bgrx1010102 = 0x30335842,
    argb2101010 = 0x30335241,
    abgr2101010 = 0x30334241,
    rgba1010102 = 0x30334152,
    bgra1010102 = 0x30334142,
    yuyv = 0x56595559,
    yvyu = 0x55595659,
    uyvy = 0x59565955,
    vyuy = 0x59555956,
    ayuv = 0x56555941,
    nv12 = 0x3231564e,
    nv21 = 0x3132564e,
    nv16 = 0x3631564e,
    nv61 = 0x3136564e,
    yuv410 = 0x39565559,
    yvu410 = 0x39555659,
    yuv411 = 0x31315559,
    yvu411 = 0x31315659,
    yuv420 = 0x32315559,
    yvu420 = 0x32315659,
    yuv422 = 0x36315559,
    yvu422 = 0x36315659,
    yuv444 = 0x34325559,
    yvu444 = 0x34325659,
    r8 = 0x20203852,
    r16 = 0x20363152,
    rg88 = 0x38384752,
    gr88 = 0x38385247,
    rg1616 = 0x32334752,
    gr1616 = 0x32335247,
    xrgb16161616f = 0x48345258,
    xbgr16161616f = 0x48344258,
    argb16161616f = 0x48345241,
    abgr16161616f = 0x48344241,
    xyuv8888 = 0x56555958,
    vuy888 = 0x34325556,
    vuy101010 = 0x30335556,
    y210 = 0x30313259,
    y212 = 0x32313259,
    y216 = 0x36313259,
    y410 = 0x30313459,
    y412 = 0x32313459,
    y416 = 0x36313459,
    xvyu2101010 = 0x30335658,
    xvyu12_16161616 = 0x36335658,
    xvyu16161616 = 0x38345658,
    y0l0 = 0x304c3059,
    x0l0 = 0x304c3058,
    y0l2 = 0x324c3059,
    x0l2 = 0x324c3058,
    yuv420_8bit = 0x38305559,
    yuv420_10bit = 0x30315559,
    xrgb8888_a8 = 0x38415258,
    xbgr8888_a8 = 0x38414258,
    rgbx8888_a8 = 0x38415852,
    bgrx8888_a8 = 0x38415842,
    rgb888_a8 = 0x38413852,
    bgr888_a8 = 0x38413842,
    rgb565_a8 = 0x38413552,
    bgr565_a8 = 0x38413542,
    nv24 = 0x3432564e,
    nv42 = 0x3234564e,
    p210 = 0x30313250,
    p010 = 0x30313050,
    p012 = 0x32313050,
    p016 = 0x36313050,
    axbxgxrx106106106106 = 0x30314241,
    nv15 = 0x3531564e,
    q410 = 0x30313451,
    q401 = 0x31303451,
    xrgb16161616 = 0x38345258,
    xbgr16161616 = 0x38344258,
    argb16161616 = 0x38345241,
    abgr16161616 = 0x38344241,
    c1 = 0x20203143,
    c2 = 0x20203243,
    c4 = 0x20203443,
    d1 = 0x20203144,
    d2 = 0x20203244,
    d4 = 0x20203444,
    d8 = 0x20203844,
    r1 = 0x20203152,
    r2 = 0x20203252,
    r4 = 0x20203452,
    r10 = 0x20303152,
    r12 = 0x20323152,
    avuy8888 = 0x59555641,
    xvuy8888 = 0x59555658,
    p030 = 0x30333050,
  }

  // Opcodes
  enum
  opcode : uint {
    create_pool = 0,
    release = 1,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_shm_interface;

// module wayland.wl_buffer;

struct
wl_buffer {
  @disable this();
  @disable this(wl_buffer);
  @disable this(ref wl_buffer);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    release_cb release = &_release_impl_default;

    alias release_cb = extern (C) void function (void* data, wl_buffer* _this /* args: */ );

    extern (C)
    static
    void
    _release_impl_default (void* data, wl_buffer* _this /* args: */ ) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_buffer_interface;

// module wayland.wl_data_offer;

struct
wl_data_offer {
  @disable this();
  @disable this(wl_data_offer);
  @disable this(ref wl_data_offer);

  // Requests
  pragma (inline,true):
  auto accept (uint serial,const(char)* mime_type) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.accept, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , serial,mime_type); }
  auto receive (const(char)* mime_type,int fd) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.receive, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , mime_type,fd); }
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto finish () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.finish, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ ); }
  auto set_actions (uint dnd_actions,uint preferred_action) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_actions, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , dnd_actions,preferred_action); }

  // Events
  struct
  Listener {
    offer_cb          offer          = &_offer_impl_default;
    source_actions_cb source_actions = &_source_actions_impl_default;
    action_cb         action         = &_action_impl_default;

    alias offer_cb          = extern (C) void function (void* data, wl_data_offer* _this /* args: */ , const(char)* mime_type);
    alias source_actions_cb = extern (C) void function (void* data, wl_data_offer* _this /* args: */ , uint source_actions);
    alias action_cb         = extern (C) void function (void* data, wl_data_offer* _this /* args: */ , uint dnd_action);

    extern (C)
    static
    void
    _offer_impl_default (void* data, wl_data_offer* _this /* args: */ , const(char)* mime_type) {
        // 
    }

    extern (C)
    static
    void
    _source_actions_impl_default (void* data, wl_data_offer* _this /* args: */ , uint source_actions) {
        // 
    }

    extern (C)
    static
    void
    _action_impl_default (void* data, wl_data_offer* _this /* args: */ , uint dnd_action) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_finish = 0,
    invalid_action_mask = 1,
    invalid_action = 2,
    invalid_offer = 3,
  }

  // Opcodes
  enum
  opcode : uint {
    accept = 0,
    receive = 1,
    destroy = 2,
    finish = 3,
    set_actions = 4,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_data_offer_interface;

// module wayland.wl_data_source;

struct
wl_data_source {
  @disable this();
  @disable this(wl_data_source);
  @disable this(ref wl_data_source);

  // Requests
  pragma (inline,true):
  auto offer (const(char)* mime_type) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.offer, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , mime_type); }
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto set_actions (uint dnd_actions) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_actions, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , dnd_actions); }

  // Events
  struct
  Listener {
    target_cb             target             = &_target_impl_default;
    send_cb               send               = &_send_impl_default;
    cancelled_cb          cancelled          = &_cancelled_impl_default;
    dnd_drop_performed_cb dnd_drop_performed = &_dnd_drop_performed_impl_default;
    dnd_finished_cb       dnd_finished       = &_dnd_finished_impl_default;
    action_cb             action             = &_action_impl_default;

    alias target_cb             = extern (C) void function (void* data, wl_data_source* _this /* args: */ , const(char)* mime_type);
    alias send_cb               = extern (C) void function (void* data, wl_data_source* _this /* args: */ , const(char)* mime_type, int fd);
    alias cancelled_cb          = extern (C) void function (void* data, wl_data_source* _this /* args: */ );
    alias dnd_drop_performed_cb = extern (C) void function (void* data, wl_data_source* _this /* args: */ );
    alias dnd_finished_cb       = extern (C) void function (void* data, wl_data_source* _this /* args: */ );
    alias action_cb             = extern (C) void function (void* data, wl_data_source* _this /* args: */ , uint dnd_action);

    extern (C)
    static
    void
    _target_impl_default (void* data, wl_data_source* _this /* args: */ , const(char)* mime_type) {
        // 
    }

    extern (C)
    static
    void
    _send_impl_default (void* data, wl_data_source* _this /* args: */ , const(char)* mime_type, int fd) {
        // 
    }

    extern (C)
    static
    void
    _cancelled_impl_default (void* data, wl_data_source* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _dnd_drop_performed_impl_default (void* data, wl_data_source* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _dnd_finished_impl_default (void* data, wl_data_source* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _action_impl_default (void* data, wl_data_source* _this /* args: */ , uint dnd_action) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_action_mask = 0,
    invalid_source = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    offer = 0,
    destroy = 1,
    set_actions = 2,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_data_source_interface;

// module wayland.wl_data_device;

struct
wl_data_device {
  @disable this();
  @disable this(wl_data_device);
  @disable this(ref wl_data_device);

  // Requests
  pragma (inline,true):
  auto start_drag (void* source,void* origin,void* icon,uint serial) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.start_drag, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , source,origin,icon,serial); }
  auto set_selection (void* source,uint serial) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_selection, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , source,serial); }
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    data_offer_cb data_offer = &_data_offer_impl_default;
    enter_cb      enter      = &_enter_impl_default;
    leave_cb      leave      = &_leave_impl_default;
    motion_cb     motion     = &_motion_impl_default;
    drop_cb       drop       = &_drop_impl_default;
    selection_cb  selection  = &_selection_impl_default;

    alias data_offer_cb = extern (C) void function (void* data, wl_data_device* _this /* args: */ , wl_data_offer id);
    alias enter_cb      = extern (C) void function (void* data, wl_data_device* _this /* args: */ , uint serial, void* surface, wl_fixed_t x, wl_fixed_t y, void* id);
    alias leave_cb      = extern (C) void function (void* data, wl_data_device* _this /* args: */ );
    alias motion_cb     = extern (C) void function (void* data, wl_data_device* _this /* args: */ , uint time, wl_fixed_t x, wl_fixed_t y);
    alias drop_cb       = extern (C) void function (void* data, wl_data_device* _this /* args: */ );
    alias selection_cb  = extern (C) void function (void* data, wl_data_device* _this /* args: */ , void* id);

    extern (C)
    static
    void
    _data_offer_impl_default (void* data, wl_data_device* _this /* args: */ , wl_data_offer id) {
        // 
    }

    extern (C)
    static
    void
    _enter_impl_default (void* data, wl_data_device* _this /* args: */ , uint serial, void* surface, wl_fixed_t x, wl_fixed_t y, void* id) {
        // 
    }

    extern (C)
    static
    void
    _leave_impl_default (void* data, wl_data_device* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _motion_impl_default (void* data, wl_data_device* _this /* args: */ , uint time, wl_fixed_t x, wl_fixed_t y) {
        // 
    }

    extern (C)
    static
    void
    _drop_impl_default (void* data, wl_data_device* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _selection_impl_default (void* data, wl_data_device* _this /* args: */ , void* id) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    role = 0,
    used_source = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    start_drag = 0,
    set_selection = 1,
    release = 2,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_data_device_interface;

// module wayland.wl_data_device_manager;

struct
wl_data_device_manager {
  @disable this();
  @disable this(wl_data_device_manager);
  @disable this(ref wl_data_device_manager);

  // Requests
  pragma (inline,true):
  auto create_data_source () { return cast (wl_data_source*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.create_data_source, /* ret interface: */ &wl_data_source_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto get_data_device (void* seat) { return cast (wl_data_device*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_data_device, /* ret interface: */ &wl_data_device_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null,seat); }

  // Enums
  enum
  dnd_action_ {
    none = 0,
    copy = 1,
    move = 2,
    ask = 4,
  }

  // Opcodes
  enum
  opcode : uint {
    create_data_source = 0,
    get_data_device = 1,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_data_device_manager_interface;

// module wayland.wl_shell;

struct
wl_shell {
  @disable this();
  @disable this(wl_shell);
  @disable this(ref wl_shell);

  // Requests
  pragma (inline,true):
  auto get_shell_surface (void* surface) { return cast (wl_shell_surface*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_shell_surface, /* ret interface: */ &wl_shell_surface_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null,surface); }

  // Enums
  enum
  error_ {
    role = 0,
  }

  // Opcodes
  enum
  opcode : uint {
    get_shell_surface = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_shell_interface;

// module wayland.wl_shell_surface;

struct
wl_shell_surface {
  @disable this();
  @disable this(wl_shell_surface);
  @disable this(ref wl_shell_surface);

  // Requests
  pragma (inline,true):
  auto pong (uint serial) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.pong, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , serial); }
  auto move (void* seat,uint serial) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.move, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , seat,serial); }
  auto resize (void* seat,uint serial,uint edges) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.resize, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , seat,serial,edges); }
  auto set_toplevel () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_toplevel, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ ); }
  auto set_transient (void* parent,int x,int y,uint flags) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_transient, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , parent,x,y,flags); }
  auto set_fullscreen (uint method,uint framerate,void* output) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_fullscreen, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , method,framerate,output); }
  auto set_popup (void* seat,uint serial,void* parent,int x,int y,uint flags) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_popup, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , seat,serial,parent,x,y,flags); }
  auto set_maximized (void* output) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_maximized, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , output); }
  auto set_title (const(char)* title) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_title, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , title); }
  auto set_class (const(char)* class_) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_class, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , class_); }

  // Events
  struct
  Listener {
    ping_cb       ping       = &_ping_impl_default;
    configure_cb  configure  = &_configure_impl_default;
    popup_done_cb popup_done = &_popup_done_impl_default;

    alias ping_cb       = extern (C) void function (void* data, wl_shell_surface* _this /* args: */ , uint serial);
    alias configure_cb  = extern (C) void function (void* data, wl_shell_surface* _this /* args: */ , uint edges, int width, int height);
    alias popup_done_cb = extern (C) void function (void* data, wl_shell_surface* _this /* args: */ );

    extern (C)
    static
    void
    _ping_impl_default (void* data, wl_shell_surface* _this /* args: */ , uint serial) {
        // 
    }

    extern (C)
    static
    void
    _configure_impl_default (void* data, wl_shell_surface* _this /* args: */ , uint edges, int width, int height) {
        // 
    }

    extern (C)
    static
    void
    _popup_done_impl_default (void* data, wl_shell_surface* _this /* args: */ ) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  resize_ {
    none = 0,
    top = 1,
    bottom = 2,
    left = 4,
    top_left = 5,
    bottom_left = 6,
    right = 8,
    top_right = 9,
    bottom_right = 10,
  }
  enum
  transient_ {
    inactive = 0x1,
  }
  enum
  fullscreen_method_ {
    default_ = 0,
    scale = 1,
    driver = 2,
    fill = 3,
  }

  // Opcodes
  enum
  opcode : uint {
    pong = 0,
    move = 1,
    resize = 2,
    set_toplevel = 3,
    set_transient = 4,
    set_fullscreen = 5,
    set_popup = 6,
    set_maximized = 7,
    set_title = 8,
    set_class = 9,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_shell_surface_interface;

// module wayland.wl_surface;

struct
wl_surface {
  @disable this();
  @disable this(wl_surface);
  @disable this(ref wl_surface);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto attach (void* buffer,int x,int y) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.attach, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , buffer,x,y); }
  auto damage (int x,int y,int width,int height) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.damage, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y,width,height); }
  auto frame () { return cast (wl_callback*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.frame, /* ret interface: */ &wl_callback_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto set_opaque_region (void* region) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_opaque_region, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , region); }
  auto set_input_region (void* region) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_input_region, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , region); }
  auto commit () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.commit, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ ); }
  auto set_buffer_transform (int transform) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_buffer_transform, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , transform); }
  auto set_buffer_scale (int scale) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_buffer_scale, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , scale); }
  auto damage_buffer (int x,int y,int width,int height) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.damage_buffer, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y,width,height); }
  auto offset (int x,int y) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.offset, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y); }

  // Events
  struct
  Listener {
    enter_cb                      enter                      = &_enter_impl_default;
    leave_cb                      leave                      = &_leave_impl_default;
    preferred_buffer_scale_cb     preferred_buffer_scale     = &_preferred_buffer_scale_impl_default;
    preferred_buffer_transform_cb preferred_buffer_transform = &_preferred_buffer_transform_impl_default;

    alias enter_cb                      = extern (C) void function (void* data, wl_surface* _this /* args: */ , void* output);
    alias leave_cb                      = extern (C) void function (void* data, wl_surface* _this /* args: */ , void* output);
    alias preferred_buffer_scale_cb     = extern (C) void function (void* data, wl_surface* _this /* args: */ , int factor);
    alias preferred_buffer_transform_cb = extern (C) void function (void* data, wl_surface* _this /* args: */ , uint transform);

    extern (C)
    static
    void
    _enter_impl_default (void* data, wl_surface* _this /* args: */ , void* output) {
        // 
    }

    extern (C)
    static
    void
    _leave_impl_default (void* data, wl_surface* _this /* args: */ , void* output) {
        // 
    }

    extern (C)
    static
    void
    _preferred_buffer_scale_impl_default (void* data, wl_surface* _this /* args: */ , int factor) {
        // 
    }

    extern (C)
    static
    void
    _preferred_buffer_transform_impl_default (void* data, wl_surface* _this /* args: */ , uint transform) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_scale = 0,
    invalid_transform = 1,
    invalid_size = 2,
    invalid_offset = 3,
    defunct_role_object = 4,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    attach = 1,
    damage = 2,
    frame = 3,
    set_opaque_region = 4,
    set_input_region = 5,
    commit = 6,
    set_buffer_transform = 7,
    set_buffer_scale = 8,
    damage_buffer = 9,
    offset = 10,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_surface_interface;

// module wayland.wl_seat;

struct
wl_seat {
  @disable this();
  @disable this(wl_seat);
  @disable this(ref wl_seat);

  // Requests
  pragma (inline,true):
  auto get_pointer () { return cast (wl_pointer*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_pointer, /* ret interface: */ &wl_pointer_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto get_keyboard () { return cast (wl_keyboard*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_keyboard, /* ret interface: */ &wl_keyboard_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto get_touch () { return cast (wl_touch*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_touch, /* ret interface: */ &wl_touch_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null); }
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    capabilities_cb capabilities = &_capabilities_impl_default;
    name_cb         name         = &_name_impl_default;

    alias capabilities_cb = extern (C) void function (void* data, wl_seat* _this /* args: */ , uint capabilities);
    alias name_cb         = extern (C) void function (void* data, wl_seat* _this /* args: */ , const(char)* name);

    extern (C)
    static
    void
    _capabilities_impl_default (void* data, wl_seat* _this /* args: */ , uint capabilities) {
        // 
    }

    extern (C)
    static
    void
    _name_impl_default (void* data, wl_seat* _this /* args: */ , const(char)* name) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  capability_ {
    pointer = 1,
    keyboard = 2,
    touch = 4,
  }
  enum
  error_ {
    missing_capability = 0,
  }

  // Opcodes
  enum
  opcode : uint {
    get_pointer = 0,
    get_keyboard = 1,
    get_touch = 2,
    release = 3,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_seat_interface;

// module wayland.wl_pointer;

struct
wl_pointer {
  @disable this();
  @disable this(wl_pointer);
  @disable this(ref wl_pointer);

  // Requests
  pragma (inline,true):
  auto set_cursor (uint serial,void* surface,int hotspot_x,int hotspot_y) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_cursor, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , serial,surface,hotspot_x,hotspot_y); }
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    enter_cb                   enter                   = &_enter_impl_default;
    leave_cb                   leave                   = &_leave_impl_default;
    motion_cb                  motion                  = &_motion_impl_default;
    button_cb                  button                  = &_button_impl_default;
    axis_cb                    axis                    = &_axis_impl_default;
    frame_cb                   frame                   = &_frame_impl_default;
    axis_source_cb             axis_source             = &_axis_source_impl_default;
    axis_stop_cb               axis_stop               = &_axis_stop_impl_default;
    axis_discrete_cb           axis_discrete           = &_axis_discrete_impl_default;
    axis_value120_cb           axis_value120           = &_axis_value120_impl_default;
    axis_relative_direction_cb axis_relative_direction = &_axis_relative_direction_impl_default;

    alias enter_cb                   = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint serial, void* surface, wl_fixed_t surface_x, wl_fixed_t surface_y);
    alias leave_cb                   = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint serial, void* surface);
    alias motion_cb                  = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint time, wl_fixed_t surface_x, wl_fixed_t surface_y);
    alias button_cb                  = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint serial, uint time, uint button, uint state);
    alias axis_cb                    = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint time, uint axis, wl_fixed_t value);
    alias frame_cb                   = extern (C) void function (void* data, wl_pointer* _this /* args: */ );
    alias axis_source_cb             = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint axis_source);
    alias axis_stop_cb               = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint time, uint axis);
    alias axis_discrete_cb           = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint axis, int discrete);
    alias axis_value120_cb           = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint axis, int value120);
    alias axis_relative_direction_cb = extern (C) void function (void* data, wl_pointer* _this /* args: */ , uint axis, uint direction);

    extern (C)
    static
    void
    _enter_impl_default (void* data, wl_pointer* _this /* args: */ , uint serial, void* surface, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        // 
    }

    extern (C)
    static
    void
    _leave_impl_default (void* data, wl_pointer* _this /* args: */ , uint serial, void* surface) {
        // 
    }

    extern (C)
    static
    void
    _motion_impl_default (void* data, wl_pointer* _this /* args: */ , uint time, wl_fixed_t surface_x, wl_fixed_t surface_y) {
        // 
    }

    extern (C)
    static
    void
    _button_impl_default (void* data, wl_pointer* _this /* args: */ , uint serial, uint time, uint button, uint state) {
        // 
    }

    extern (C)
    static
    void
    _axis_impl_default (void* data, wl_pointer* _this /* args: */ , uint time, uint axis, wl_fixed_t value) {
        // 
    }

    extern (C)
    static
    void
    _frame_impl_default (void* data, wl_pointer* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _axis_source_impl_default (void* data, wl_pointer* _this /* args: */ , uint axis_source) {
        // 
    }

    extern (C)
    static
    void
    _axis_stop_impl_default (void* data, wl_pointer* _this /* args: */ , uint time, uint axis) {
        // 
    }

    extern (C)
    static
    void
    _axis_discrete_impl_default (void* data, wl_pointer* _this /* args: */ , uint axis, int discrete) {
        // 
    }

    extern (C)
    static
    void
    _axis_value120_impl_default (void* data, wl_pointer* _this /* args: */ , uint axis, int value120) {
        // 
    }

    extern (C)
    static
    void
    _axis_relative_direction_impl_default (void* data, wl_pointer* _this /* args: */ , uint axis, uint direction) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    role = 0,
  }
  enum
  button_state_ {
    released = 0,
    pressed = 1,
  }
  enum
  axis_ {
    vertical_scroll = 0,
    horizontal_scroll = 1,
  }
  enum
  axis_source_ {
    wheel = 0,
    finger = 1,
    continuous = 2,
    wheel_tilt = 3,
  }
  enum
  axis_relative_direction_ {
    identical = 0,
    inverted = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    set_cursor = 0,
    release = 1,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_pointer_interface;

// module wayland.wl_keyboard;

struct
wl_keyboard {
  @disable this();
  @disable this(wl_keyboard);
  @disable this(ref wl_keyboard);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    keymap_cb      keymap      = &_keymap_impl_default;
    enter_cb       enter       = &_enter_impl_default;
    leave_cb       leave       = &_leave_impl_default;
    key_cb         key         = &_key_impl_default;
    modifiers_cb   modifiers   = &_modifiers_impl_default;
    repeat_info_cb repeat_info = &_repeat_info_impl_default;

    alias keymap_cb      = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , uint format, int fd, uint size);
    alias enter_cb       = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , uint serial, void* surface, wl_array* keys);
    alias leave_cb       = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , uint serial, void* surface);
    alias key_cb         = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , uint serial, uint time, uint key, uint state);
    alias modifiers_cb   = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group);
    alias repeat_info_cb = extern (C) void function (void* data, wl_keyboard* _this /* args: */ , int rate, int delay);

    extern (C)
    static
    void
    _keymap_impl_default (void* data, wl_keyboard* _this /* args: */ , uint format, int fd, uint size) {
        // 
    }

    extern (C)
    static
    void
    _enter_impl_default (void* data, wl_keyboard* _this /* args: */ , uint serial, void* surface, wl_array* keys) {
        // 
    }

    extern (C)
    static
    void
    _leave_impl_default (void* data, wl_keyboard* _this /* args: */ , uint serial, void* surface) {
        // 
    }

    extern (C)
    static
    void
    _key_impl_default (void* data, wl_keyboard* _this /* args: */ , uint serial, uint time, uint key, uint state) {
        // 
    }

    extern (C)
    static
    void
    _modifiers_impl_default (void* data, wl_keyboard* _this /* args: */ , uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group) {
        // 
    }

    extern (C)
    static
    void
    _repeat_info_impl_default (void* data, wl_keyboard* _this /* args: */ , int rate, int delay) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  keymap_format_ {
    no_keymap = 0,
    xkb_v1 = 1,
  }
  enum
  key_state_ {
    released = 0,
    pressed = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_keyboard_interface;

// module wayland.wl_touch;

struct
wl_touch {
  @disable this();
  @disable this(wl_touch);
  @disable this(ref wl_touch);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    down_cb        down        = &_down_impl_default;
    up_cb          up          = &_up_impl_default;
    motion_cb      motion      = &_motion_impl_default;
    frame_cb       frame       = &_frame_impl_default;
    cancel_cb      cancel      = &_cancel_impl_default;
    shape_cb       shape       = &_shape_impl_default;
    orientation_cb orientation = &_orientation_impl_default;

    alias down_cb        = extern (C) void function (void* data, wl_touch* _this /* args: */ , uint serial, uint time, void* surface, int id, wl_fixed_t x, wl_fixed_t y);
    alias up_cb          = extern (C) void function (void* data, wl_touch* _this /* args: */ , uint serial, uint time, int id);
    alias motion_cb      = extern (C) void function (void* data, wl_touch* _this /* args: */ , uint time, int id, wl_fixed_t x, wl_fixed_t y);
    alias frame_cb       = extern (C) void function (void* data, wl_touch* _this /* args: */ );
    alias cancel_cb      = extern (C) void function (void* data, wl_touch* _this /* args: */ );
    alias shape_cb       = extern (C) void function (void* data, wl_touch* _this /* args: */ , int id, wl_fixed_t major, wl_fixed_t minor);
    alias orientation_cb = extern (C) void function (void* data, wl_touch* _this /* args: */ , int id, wl_fixed_t orientation);

    extern (C)
    static
    void
    _down_impl_default (void* data, wl_touch* _this /* args: */ , uint serial, uint time, void* surface, int id, wl_fixed_t x, wl_fixed_t y) {
        // 
    }

    extern (C)
    static
    void
    _up_impl_default (void* data, wl_touch* _this /* args: */ , uint serial, uint time, int id) {
        // 
    }

    extern (C)
    static
    void
    _motion_impl_default (void* data, wl_touch* _this /* args: */ , uint time, int id, wl_fixed_t x, wl_fixed_t y) {
        // 
    }

    extern (C)
    static
    void
    _frame_impl_default (void* data, wl_touch* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _cancel_impl_default (void* data, wl_touch* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _shape_impl_default (void* data, wl_touch* _this /* args: */ , int id, wl_fixed_t major, wl_fixed_t minor) {
        // 
    }

    extern (C)
    static
    void
    _orientation_impl_default (void* data, wl_touch* _this /* args: */ , int id, wl_fixed_t orientation) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_touch_interface;

// module wayland.wl_output;

struct
wl_output {
  @disable this();
  @disable this(wl_output);
  @disable this(ref wl_output);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.release, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }

  // Events
  struct
  Listener {
    geometry_cb    geometry    = &_geometry_impl_default;
    mode_cb        mode        = &_mode_impl_default;
    done_cb        done        = &_done_impl_default;
    scale_cb       scale       = &_scale_impl_default;
    name_cb        name        = &_name_impl_default;
    description_cb description = &_description_impl_default;

    alias geometry_cb    = extern (C) void function (void* data, wl_output* _this /* args: */ , int x, int y, int physical_width, int physical_height, int subpixel, const(char)* make, const(char)* model, int transform);
    alias mode_cb        = extern (C) void function (void* data, wl_output* _this /* args: */ , uint flags, int width, int height, int refresh);
    alias done_cb        = extern (C) void function (void* data, wl_output* _this /* args: */ );
    alias scale_cb       = extern (C) void function (void* data, wl_output* _this /* args: */ , int factor);
    alias name_cb        = extern (C) void function (void* data, wl_output* _this /* args: */ , const(char)* name);
    alias description_cb = extern (C) void function (void* data, wl_output* _this /* args: */ , const(char)* description);

    extern (C)
    static
    void
    _geometry_impl_default (void* data, wl_output* _this /* args: */ , int x, int y, int physical_width, int physical_height, int subpixel, const(char)* make, const(char)* model, int transform) {
        // 
    }

    extern (C)
    static
    void
    _mode_impl_default (void* data, wl_output* _this /* args: */ , uint flags, int width, int height, int refresh) {
        // 
    }

    extern (C)
    static
    void
    _done_impl_default (void* data, wl_output* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _scale_impl_default (void* data, wl_output* _this /* args: */ , int factor) {
        // 
    }

    extern (C)
    static
    void
    _name_impl_default (void* data, wl_output* _this /* args: */ , const(char)* name) {
        // 
    }

    extern (C)
    static
    void
    _description_impl_default (void* data, wl_output* _this /* args: */ , const(char)* description) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  subpixel_ {
    unknown = 0,
    none = 1,
    horizontal_rgb = 2,
    horizontal_bgr = 3,
    vertical_rgb = 4,
    vertical_bgr = 5,
  }
  enum
  transform_ {
    normal = 0,
    _90 = 1,
    _180 = 2,
    _270 = 3,
    flipped = 4,
    flipped_90 = 5,
    flipped_180 = 6,
    flipped_270 = 7,
  }
  enum
  mode_ {
    current = 0x1,
    preferred = 0x2,
  }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_output_interface;

// module wayland.wl_region;

struct
wl_region {
  @disable this();
  @disable this(wl_region);
  @disable this(ref wl_region);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto add (int x,int y,int width,int height) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.add, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y,width,height); }
  auto subtract (int x,int y,int width,int height) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.subtract, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y,width,height); }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    add = 1,
    subtract = 2,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_region_interface;

// module wayland.wl_subcompositor;

struct
wl_subcompositor {
  @disable this();
  @disable this(wl_subcompositor);
  @disable this(ref wl_subcompositor);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto get_subsurface (void* surface,void* parent) { return cast (wl_subsurface*) wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.get_subsurface, /* ret interface: */ &wl_subsurface_interface, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , null,surface,parent); }

  // Enums
  enum
  error_ {
    bad_surface = 0,
    bad_parent = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    get_subsurface = 1,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_subcompositor_interface;

// module wayland.wl_subsurface;

struct
wl_subsurface {
  @disable this();
  @disable this(wl_subsurface);
  @disable this(ref wl_subsurface);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.destroy, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ WL_MARSHAL_FLAG_DESTROY /* request args: */ ); }
  auto set_position (int x,int y) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_position, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , x,y); }
  auto place_above (void* sibling) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.place_above, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , sibling); }
  auto place_below (void* sibling) {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.place_below, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ , sibling); }
  auto set_sync () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_sync, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ ); }
  auto set_desync () {  wl_proxy_marshal_flags (cast (wl_proxy*) &this, opcode.set_desync, /* ret interface: */ null, /* version: */ wl_proxy_get_version (cast (wl_proxy *) &this), /* flags: */ 0 /* request args: */ ); }

  // Enums
  enum
  error_ {
    bad_surface = 0,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    set_position = 1,
    place_above = 2,
    place_below = 3,
    set_sync = 4,
    set_desync = 5,
  }
}

// interface
extern (C) extern __gshared wl_interface wl_subsurface_interface;

