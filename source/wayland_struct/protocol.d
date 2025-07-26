// protocol wayland
module wayland_struct.protocol;

import wayland_struct.proxy : wl_proxy;
import wayland_struct.proxy : wl_proxy_marshal;
import wayland_struct.proxy : wl_proxy_marshal_constructor;
import wayland_struct.proxy : wl_proxy_marshal_constructor_versioned;
import wayland_struct.proxy : wl_proxy_get_version;
import wayland_struct.proxy : wl_proxy_add_listener;
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
  auto bind (uint name) { return cast (wl_proxy*) 
    wl_proxy_marshal_constructor (
      cast(wl_proxy*)&this, opcode.bind , &wl_proxy_interface  , null, name);  }

  // Events
  struct
  Listener {
    global_cb global;
    global_remove_cb global_remove;

    alias global_cb = void function (void* data, wl_registry* _wl_registry, uint name, const(char)* interface_, uint version_);
    alias global_remove_cb = void function (void* data, wl_registry* _wl_registry, uint name);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

  // Opcodes
  enum
  opcode : uint {
    bind = 0,
  }
}

// Interface
static const wl_interface*[2] _wl_registry_request_bind_types = [null,null,];
static const wl_interface*[3] _wl_registry_event_global_types = [null,null,null,];
static const wl_interface*[1] _wl_registry_event_global_remove_types = [null,];
static const wl_message[1] _wl_registry_requests  = [wl_message ("bind","un",_wl_registry_request_bind_types.ptr),];
static const wl_message[2] _wl_registry_events    = [wl_message ("global","usu",_wl_registry_event_global_types.ptr),wl_message ("global_remove","u",_wl_registry_event_global_remove_types.ptr),];
static const wl_interface wl_registry_interface = {
    "wl_registry", 1,
    1, _wl_registry_requests.ptr,
    2, _wl_registry_events.ptr
};

// module wayland.wl_callback;

struct
wl_callback {
  @disable this();
  @disable this(wl_callback);
  @disable this(ref wl_callback);

  // Events
  struct
  Listener {
    done_cb done;

    alias done_cb = void function (void* data, wl_callback* _wl_callback, uint callback_data);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }
}

// Interface
static const wl_interface*[1] _wl_callback_event_done_types = [null,];
static const wl_message[0] _wl_callback_requests  = [];
static const wl_message[1] _wl_callback_events    = [wl_message ("done","u",_wl_callback_event_done_types.ptr),];
static const wl_interface wl_callback_interface = {
    "wl_callback", 1,
    0, _wl_callback_requests.ptr,
    1, _wl_callback_events.ptr
};

// module wayland.wl_compositor;

struct
wl_compositor {
  @disable this();
  @disable this(wl_compositor);
  @disable this(ref wl_compositor);

  // Requests
  pragma (inline,true):
  auto create_surface () { return cast (wl_surface*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.create_surface , &wl_surface_interface  , null);  }
  auto create_region () { return cast (wl_region*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.create_region , &wl_region_interface  , null);  }

  // Opcodes
  enum
  opcode : uint {
    create_surface = 0,
    create_region = 1,
  }
}

// Interface
static const wl_interface*[1] _wl_compositor_request_create_surface_types = [null,];
static const wl_interface*[1] _wl_compositor_request_create_region_types = [null,];
static const wl_message[2] _wl_compositor_requests  = [wl_message ("create_surface","6n",_wl_compositor_request_create_surface_types.ptr),wl_message ("create_region","6n",_wl_compositor_request_create_region_types.ptr),];
static const wl_message[0] _wl_compositor_events    = [];
static const wl_interface wl_compositor_interface = {
    "wl_compositor", 6,
    2, _wl_compositor_requests.ptr,
    0, _wl_compositor_events.ptr
};

// module wayland.wl_shm_pool;

struct
wl_shm_pool {
  @disable this();
  @disable this(wl_shm_pool);
  @disable this(ref wl_shm_pool);

  // Requests
  pragma (inline,true):
  auto create_buffer (int offset, int width, int height, int stride, uint format) { return cast (wl_buffer*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.create_buffer , &wl_buffer_interface  , null, offset, width, height, stride, format);  }
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto resize (int size) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.resize   , size);  }

  // Opcodes
  enum
  opcode : uint {
    create_buffer = 0,
    destroy = 1,
    resize = 2,
  }
}

// Interface
static const wl_interface*[6] _wl_shm_pool_request_create_buffer_types = [null,null,null,null,null,null,];
static const wl_interface*[0] _wl_shm_pool_request_destroy_types = [];
static const wl_interface*[1] _wl_shm_pool_request_resize_types = [null,];
static const wl_message[3] _wl_shm_pool_requests  = [wl_message ("create_buffer","2niiiiu",_wl_shm_pool_request_create_buffer_types.ptr),wl_message ("destroy","2",_wl_shm_pool_request_destroy_types.ptr),wl_message ("resize","2i",_wl_shm_pool_request_resize_types.ptr),];
static const wl_message[0] _wl_shm_pool_events    = [];
static const wl_interface wl_shm_pool_interface = {
    "wl_shm_pool", 2,
    3, _wl_shm_pool_requests.ptr,
    0, _wl_shm_pool_events.ptr
};

// module wayland.wl_shm;

struct
wl_shm {
  @disable this();
  @disable this(wl_shm);
  @disable this(ref wl_shm);

  // Requests
  pragma (inline,true):
  auto create_pool (int fd, int size) { return cast (wl_shm_pool*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.create_pool , &wl_shm_pool_interface  , null, fd, size);  }
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    format_cb format;

    alias format_cb = void function (void* data, wl_shm* _wl_shm, uint format);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[3] _wl_shm_request_create_pool_types = [null,null,null,];
static const wl_interface*[0] _wl_shm_request_release_types = [];
static const wl_interface*[1] _wl_shm_event_format_types = [null,];
static const wl_message[2] _wl_shm_requests  = [wl_message ("create_pool","2nhi",_wl_shm_request_create_pool_types.ptr),wl_message ("release","2",_wl_shm_request_release_types.ptr),];
static const wl_message[1] _wl_shm_events    = [wl_message ("format","2u",_wl_shm_event_format_types.ptr),];
static const wl_interface wl_shm_interface = {
    "wl_shm", 2,
    2, _wl_shm_requests.ptr,
    1, _wl_shm_events.ptr
};

// module wayland.wl_buffer;

struct
wl_buffer {
  @disable this();
  @disable this(wl_buffer);
  @disable this(ref wl_buffer);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }

  // Events
  struct
  Listener {
    release_cb release;

    alias release_cb = void function (void* data, wl_buffer* _wl_buffer);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
  }
}

// Interface
static const wl_interface*[0] _wl_buffer_request_destroy_types = [];
static const wl_interface*[0] _wl_buffer_event_release_types = [];
static const wl_message[1] _wl_buffer_requests  = [wl_message ("destroy","",_wl_buffer_request_destroy_types.ptr),];
static const wl_message[1] _wl_buffer_events    = [wl_message ("release","",_wl_buffer_event_release_types.ptr),];
static const wl_interface wl_buffer_interface = {
    "wl_buffer", 1,
    1, _wl_buffer_requests.ptr,
    1, _wl_buffer_events.ptr
};

// module wayland.wl_data_offer;

struct
wl_data_offer {
  @disable this();
  @disable this(wl_data_offer);
  @disable this(ref wl_data_offer);

  // Requests
  pragma (inline,true):
  auto accept (uint serial, const(char)* mime_type) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.accept   , serial, mime_type);  }
  auto receive (const(char)* mime_type, int fd) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.receive   , mime_type, fd);  }
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto finish () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.finish   );  }
  auto set_actions (uint dnd_actions, uint preferred_action) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_actions   , dnd_actions, preferred_action);  }

  // Events
  struct
  Listener {
    offer_cb offer;
    source_actions_cb source_actions;
    action_cb action;

    alias offer_cb = void function (void* data, wl_data_offer* _wl_data_offer, const(char)* mime_type);
    alias source_actions_cb = void function (void* data, wl_data_offer* _wl_data_offer, uint source_actions);
    alias action_cb = void function (void* data, wl_data_offer* _wl_data_offer, uint dnd_action);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[2] _wl_data_offer_request_accept_types = [null,null,];
static const wl_interface*[2] _wl_data_offer_request_receive_types = [null,null,];
static const wl_interface*[0] _wl_data_offer_request_destroy_types = [];
static const wl_interface*[0] _wl_data_offer_request_finish_types = [];
static const wl_interface*[2] _wl_data_offer_request_set_actions_types = [null,null,];
static const wl_interface*[1] _wl_data_offer_event_offer_types = [null,];
static const wl_interface*[1] _wl_data_offer_event_source_actions_types = [null,];
static const wl_interface*[1] _wl_data_offer_event_action_types = [null,];
static const wl_message[5] _wl_data_offer_requests  = [wl_message ("accept","3u?s",_wl_data_offer_request_accept_types.ptr),wl_message ("receive","3sh",_wl_data_offer_request_receive_types.ptr),wl_message ("destroy","3",_wl_data_offer_request_destroy_types.ptr),wl_message ("finish","3",_wl_data_offer_request_finish_types.ptr),wl_message ("set_actions","3uu",_wl_data_offer_request_set_actions_types.ptr),];
static const wl_message[3] _wl_data_offer_events    = [wl_message ("offer","3s",_wl_data_offer_event_offer_types.ptr),wl_message ("source_actions","3u",_wl_data_offer_event_source_actions_types.ptr),wl_message ("action","3u",_wl_data_offer_event_action_types.ptr),];
static const wl_interface wl_data_offer_interface = {
    "wl_data_offer", 3,
    5, _wl_data_offer_requests.ptr,
    3, _wl_data_offer_events.ptr
};

// module wayland.wl_data_source;

struct
wl_data_source {
  @disable this();
  @disable this(wl_data_source);
  @disable this(ref wl_data_source);

  // Requests
  pragma (inline,true):
  auto offer (const(char)* mime_type) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.offer   , mime_type);  }
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto set_actions (uint dnd_actions) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_actions   , dnd_actions);  }

  // Events
  struct
  Listener {
    target_cb target;
    send_cb send;
    cancelled_cb cancelled;
    dnd_drop_performed_cb dnd_drop_performed;
    dnd_finished_cb dnd_finished;
    action_cb action;

    alias target_cb = void function (void* data, wl_data_source* _wl_data_source, const(char)* mime_type);
    alias send_cb = void function (void* data, wl_data_source* _wl_data_source, const(char)* mime_type, int fd);
    alias cancelled_cb = void function (void* data, wl_data_source* _wl_data_source);
    alias dnd_drop_performed_cb = void function (void* data, wl_data_source* _wl_data_source);
    alias dnd_finished_cb = void function (void* data, wl_data_source* _wl_data_source);
    alias action_cb = void function (void* data, wl_data_source* _wl_data_source, uint dnd_action);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[1] _wl_data_source_request_offer_types = [null,];
static const wl_interface*[0] _wl_data_source_request_destroy_types = [];
static const wl_interface*[1] _wl_data_source_request_set_actions_types = [null,];
static const wl_interface*[1] _wl_data_source_event_target_types = [null,];
static const wl_interface*[2] _wl_data_source_event_send_types = [null,null,];
static const wl_interface*[0] _wl_data_source_event_cancelled_types = [];
static const wl_interface*[0] _wl_data_source_event_dnd_drop_performed_types = [];
static const wl_interface*[0] _wl_data_source_event_dnd_finished_types = [];
static const wl_interface*[1] _wl_data_source_event_action_types = [null,];
static const wl_message[3] _wl_data_source_requests  = [wl_message ("offer","3s",_wl_data_source_request_offer_types.ptr),wl_message ("destroy","3",_wl_data_source_request_destroy_types.ptr),wl_message ("set_actions","3u",_wl_data_source_request_set_actions_types.ptr),];
static const wl_message[6] _wl_data_source_events    = [wl_message ("target","3?s",_wl_data_source_event_target_types.ptr),wl_message ("send","3sh",_wl_data_source_event_send_types.ptr),wl_message ("cancelled","3",_wl_data_source_event_cancelled_types.ptr),wl_message ("dnd_drop_performed","3",_wl_data_source_event_dnd_drop_performed_types.ptr),wl_message ("dnd_finished","3",_wl_data_source_event_dnd_finished_types.ptr),wl_message ("action","3u",_wl_data_source_event_action_types.ptr),];
static const wl_interface wl_data_source_interface = {
    "wl_data_source", 3,
    3, _wl_data_source_requests.ptr,
    6, _wl_data_source_events.ptr
};

// module wayland.wl_data_device;

struct
wl_data_device {
  @disable this();
  @disable this(wl_data_device);
  @disable this(ref wl_data_device);

  // Requests
  pragma (inline,true):
  auto start_drag (void* source, void* origin, void* icon, uint serial) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.start_drag   , source, origin, icon, serial);  }
  auto set_selection (void* source, uint serial) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_selection   , source, serial);  }
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    data_offer_cb data_offer;
    enter_cb enter;
    leave_cb leave;
    motion_cb motion;
    drop_cb drop;
    selection_cb selection;

    alias data_offer_cb = void function (void* data, wl_data_device* _wl_data_device, wl_data_offer id);
    alias enter_cb = void function (void* data, wl_data_device* _wl_data_device, uint serial, void* surface, wl_fixed_t x, wl_fixed_t y, void* id);
    alias leave_cb = void function (void* data, wl_data_device* _wl_data_device);
    alias motion_cb = void function (void* data, wl_data_device* _wl_data_device, uint time, wl_fixed_t x, wl_fixed_t y);
    alias drop_cb = void function (void* data, wl_data_device* _wl_data_device);
    alias selection_cb = void function (void* data, wl_data_device* _wl_data_device, void* id);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[4] _wl_data_device_request_start_drag_types = [&wl_data_source_interface,&wl_surface_interface,&wl_surface_interface,null,];
static const wl_interface*[2] _wl_data_device_request_set_selection_types = [&wl_data_source_interface,null,];
static const wl_interface*[0] _wl_data_device_request_release_types = [];
static const wl_interface*[1] _wl_data_device_event_data_offer_types = [null,];
static const wl_interface*[5] _wl_data_device_event_enter_types = [null,&wl_surface_interface,null,null,&wl_data_offer_interface,];
static const wl_interface*[0] _wl_data_device_event_leave_types = [];
static const wl_interface*[3] _wl_data_device_event_motion_types = [null,null,null,];
static const wl_interface*[0] _wl_data_device_event_drop_types = [];
static const wl_interface*[1] _wl_data_device_event_selection_types = [&wl_data_offer_interface,];
static const wl_message[3] _wl_data_device_requests  = [wl_message ("start_drag","3?oo?ou",_wl_data_device_request_start_drag_types.ptr),wl_message ("set_selection","3?ou",_wl_data_device_request_set_selection_types.ptr),wl_message ("release","3",_wl_data_device_request_release_types.ptr),];
static const wl_message[6] _wl_data_device_events    = [wl_message ("data_offer","3n",_wl_data_device_event_data_offer_types.ptr),wl_message ("enter","3uoff?o",_wl_data_device_event_enter_types.ptr),wl_message ("leave","3",_wl_data_device_event_leave_types.ptr),wl_message ("motion","3uff",_wl_data_device_event_motion_types.ptr),wl_message ("drop","3",_wl_data_device_event_drop_types.ptr),wl_message ("selection","3?o",_wl_data_device_event_selection_types.ptr),];
static const wl_interface wl_data_device_interface = {
    "wl_data_device", 3,
    3, _wl_data_device_requests.ptr,
    6, _wl_data_device_events.ptr
};

// module wayland.wl_data_device_manager;

struct
wl_data_device_manager {
  @disable this();
  @disable this(wl_data_device_manager);
  @disable this(ref wl_data_device_manager);

  // Requests
  pragma (inline,true):
  auto create_data_source () { return cast (wl_data_source*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.create_data_source , &wl_data_source_interface  , null);  }
  auto get_data_device (void* seat) { return cast (wl_data_device*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_data_device , &wl_data_device_interface  , null, seat);  }

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

// Interface
static const wl_interface*[1] _wl_data_device_manager_request_create_data_source_types = [null,];
static const wl_interface*[2] _wl_data_device_manager_request_get_data_device_types = [null,&wl_seat_interface,];
static const wl_message[2] _wl_data_device_manager_requests  = [wl_message ("create_data_source","3n",_wl_data_device_manager_request_create_data_source_types.ptr),wl_message ("get_data_device","3no",_wl_data_device_manager_request_get_data_device_types.ptr),];
static const wl_message[0] _wl_data_device_manager_events    = [];
static const wl_interface wl_data_device_manager_interface = {
    "wl_data_device_manager", 3,
    2, _wl_data_device_manager_requests.ptr,
    0, _wl_data_device_manager_events.ptr
};

// module wayland.wl_shell;

struct
wl_shell {
  @disable this();
  @disable this(wl_shell);
  @disable this(ref wl_shell);

  // Requests
  pragma (inline,true):
  auto get_shell_surface (void* surface) { return cast (wl_shell_surface*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_shell_surface , &wl_shell_surface_interface  , null, surface);  }

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

// Interface
static const wl_interface*[2] _wl_shell_request_get_shell_surface_types = [null,&wl_surface_interface,];
static const wl_message[1] _wl_shell_requests  = [wl_message ("get_shell_surface","no",_wl_shell_request_get_shell_surface_types.ptr),];
static const wl_message[0] _wl_shell_events    = [];
static const wl_interface wl_shell_interface = {
    "wl_shell", 1,
    1, _wl_shell_requests.ptr,
    0, _wl_shell_events.ptr
};

// module wayland.wl_shell_surface;

struct
wl_shell_surface {
  @disable this();
  @disable this(wl_shell_surface);
  @disable this(ref wl_shell_surface);

  // Requests
  pragma (inline,true):
  auto pong (uint serial) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.pong   , serial);  }
  auto move (void* seat, uint serial) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.move   , seat, serial);  }
  auto resize (void* seat, uint serial, uint edges) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.resize   , seat, serial, edges);  }
  auto set_toplevel () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_toplevel   );  }
  auto set_transient (void* parent, int x, int y, uint flags) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_transient   , parent, x, y, flags);  }
  auto set_fullscreen (uint method, uint framerate, void* output) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_fullscreen   , method, framerate, output);  }
  auto set_popup (void* seat, uint serial, void* parent, int x, int y, uint flags) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_popup   , seat, serial, parent, x, y, flags);  }
  auto set_maximized (void* output) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_maximized   , output);  }
  auto set_title (const(char)* title) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_title   , title);  }
  auto set_class (const(char)* class_) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_class   , class_);  }

  // Events
  struct
  Listener {
    ping_cb ping;
    configure_cb configure;
    popup_done_cb popup_done;

    alias ping_cb = void function (void* data, wl_shell_surface* _wl_shell_surface, uint serial);
    alias configure_cb = void function (void* data, wl_shell_surface* _wl_shell_surface, uint edges, int width, int height);
    alias popup_done_cb = void function (void* data, wl_shell_surface* _wl_shell_surface);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[1] _wl_shell_surface_request_pong_types = [null,];
static const wl_interface*[2] _wl_shell_surface_request_move_types = [&wl_seat_interface,null,];
static const wl_interface*[3] _wl_shell_surface_request_resize_types = [&wl_seat_interface,null,null,];
static const wl_interface*[0] _wl_shell_surface_request_set_toplevel_types = [];
static const wl_interface*[4] _wl_shell_surface_request_set_transient_types = [&wl_surface_interface,null,null,null,];
static const wl_interface*[3] _wl_shell_surface_request_set_fullscreen_types = [null,null,&wl_output_interface,];
static const wl_interface*[6] _wl_shell_surface_request_set_popup_types = [&wl_seat_interface,null,&wl_surface_interface,null,null,null,];
static const wl_interface*[1] _wl_shell_surface_request_set_maximized_types = [&wl_output_interface,];
static const wl_interface*[1] _wl_shell_surface_request_set_title_types = [null,];
static const wl_interface*[1] _wl_shell_surface_request_set_class_types = [null,];
static const wl_interface*[1] _wl_shell_surface_event_ping_types = [null,];
static const wl_interface*[3] _wl_shell_surface_event_configure_types = [null,null,null,];
static const wl_interface*[0] _wl_shell_surface_event_popup_done_types = [];
static const wl_message[10] _wl_shell_surface_requests  = [wl_message ("pong","u",_wl_shell_surface_request_pong_types.ptr),wl_message ("move","ou",_wl_shell_surface_request_move_types.ptr),wl_message ("resize","ouu",_wl_shell_surface_request_resize_types.ptr),wl_message ("set_toplevel","",_wl_shell_surface_request_set_toplevel_types.ptr),wl_message ("set_transient","oiiu",_wl_shell_surface_request_set_transient_types.ptr),wl_message ("set_fullscreen","uu?o",_wl_shell_surface_request_set_fullscreen_types.ptr),wl_message ("set_popup","ouoiiu",_wl_shell_surface_request_set_popup_types.ptr),wl_message ("set_maximized","?o",_wl_shell_surface_request_set_maximized_types.ptr),wl_message ("set_title","s",_wl_shell_surface_request_set_title_types.ptr),wl_message ("set_class","s",_wl_shell_surface_request_set_class_types.ptr),];
static const wl_message[3] _wl_shell_surface_events    = [wl_message ("ping","u",_wl_shell_surface_event_ping_types.ptr),wl_message ("configure","uii",_wl_shell_surface_event_configure_types.ptr),wl_message ("popup_done","",_wl_shell_surface_event_popup_done_types.ptr),];
static const wl_interface wl_shell_surface_interface = {
    "wl_shell_surface", 1,
    10, _wl_shell_surface_requests.ptr,
    3, _wl_shell_surface_events.ptr
};

// module wayland.wl_surface;

struct
wl_surface {
  @disable this();
  @disable this(wl_surface);
  @disable this(ref wl_surface);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto attach (void* buffer, int x, int y) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.attach   , buffer, x, y);  }
  auto damage (int x, int y, int width, int height) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.damage   , x, y, width, height);  }
  auto frame () { return cast (wl_callback*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.frame , &wl_callback_interface  , null);  }
  auto set_opaque_region (void* region) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_opaque_region   , region);  }
  auto set_input_region (void* region) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_input_region   , region);  }
  auto commit () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.commit   );  }
  auto set_buffer_transform (int transform) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_buffer_transform   , transform);  }
  auto set_buffer_scale (int scale) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_buffer_scale   , scale);  }
  auto damage_buffer (int x, int y, int width, int height) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.damage_buffer   , x, y, width, height);  }
  auto offset (int x, int y) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.offset   , x, y);  }

  // Events
  struct
  Listener {
    enter_cb enter;
    leave_cb leave;
    preferred_buffer_scale_cb preferred_buffer_scale;
    preferred_buffer_transform_cb preferred_buffer_transform;

    alias enter_cb = void function (void* data, wl_surface* _wl_surface, void* output);
    alias leave_cb = void function (void* data, wl_surface* _wl_surface, void* output);
    alias preferred_buffer_scale_cb = void function (void* data, wl_surface* _wl_surface, int factor);
    alias preferred_buffer_transform_cb = void function (void* data, wl_surface* _wl_surface, uint transform);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[0] _wl_surface_request_destroy_types = [];
static const wl_interface*[3] _wl_surface_request_attach_types = [&wl_buffer_interface,null,null,];
static const wl_interface*[4] _wl_surface_request_damage_types = [null,null,null,null,];
static const wl_interface*[1] _wl_surface_request_frame_types = [null,];
static const wl_interface*[1] _wl_surface_request_set_opaque_region_types = [&wl_region_interface,];
static const wl_interface*[1] _wl_surface_request_set_input_region_types = [&wl_region_interface,];
static const wl_interface*[0] _wl_surface_request_commit_types = [];
static const wl_interface*[1] _wl_surface_request_set_buffer_transform_types = [null,];
static const wl_interface*[1] _wl_surface_request_set_buffer_scale_types = [null,];
static const wl_interface*[4] _wl_surface_request_damage_buffer_types = [null,null,null,null,];
static const wl_interface*[2] _wl_surface_request_offset_types = [null,null,];
static const wl_interface*[1] _wl_surface_event_enter_types = [&wl_output_interface,];
static const wl_interface*[1] _wl_surface_event_leave_types = [&wl_output_interface,];
static const wl_interface*[1] _wl_surface_event_preferred_buffer_scale_types = [null,];
static const wl_interface*[1] _wl_surface_event_preferred_buffer_transform_types = [null,];
static const wl_message[11] _wl_surface_requests  = [wl_message ("destroy","6",_wl_surface_request_destroy_types.ptr),wl_message ("attach","6?oii",_wl_surface_request_attach_types.ptr),wl_message ("damage","6iiii",_wl_surface_request_damage_types.ptr),wl_message ("frame","6n",_wl_surface_request_frame_types.ptr),wl_message ("set_opaque_region","6?o",_wl_surface_request_set_opaque_region_types.ptr),wl_message ("set_input_region","6?o",_wl_surface_request_set_input_region_types.ptr),wl_message ("commit","6",_wl_surface_request_commit_types.ptr),wl_message ("set_buffer_transform","6i",_wl_surface_request_set_buffer_transform_types.ptr),wl_message ("set_buffer_scale","6i",_wl_surface_request_set_buffer_scale_types.ptr),wl_message ("damage_buffer","6iiii",_wl_surface_request_damage_buffer_types.ptr),wl_message ("offset","6ii",_wl_surface_request_offset_types.ptr),];
static const wl_message[4] _wl_surface_events    = [wl_message ("enter","6o",_wl_surface_event_enter_types.ptr),wl_message ("leave","6o",_wl_surface_event_leave_types.ptr),wl_message ("preferred_buffer_scale","6i",_wl_surface_event_preferred_buffer_scale_types.ptr),wl_message ("preferred_buffer_transform","6u",_wl_surface_event_preferred_buffer_transform_types.ptr),];
static const wl_interface wl_surface_interface = {
    "wl_surface", 6,
    11, _wl_surface_requests.ptr,
    4, _wl_surface_events.ptr
};

// module wayland.wl_seat;

struct
wl_seat {
  @disable this();
  @disable this(wl_seat);
  @disable this(ref wl_seat);

  // Requests
  pragma (inline,true):
  auto get_pointer () { return cast (wl_pointer*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_pointer , &wl_pointer_interface  , null);  }
  auto get_keyboard () { return cast (wl_keyboard*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_keyboard , &wl_keyboard_interface  , null);  }
  auto get_touch () { return cast (wl_touch*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_touch , &wl_touch_interface  , null);  }
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    capabilities_cb capabilities;
    name_cb name;

    alias capabilities_cb = void function (void* data, wl_seat* _wl_seat, uint capabilities);
    alias name_cb = void function (void* data, wl_seat* _wl_seat, const(char)* name);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[1] _wl_seat_request_get_pointer_types = [null,];
static const wl_interface*[1] _wl_seat_request_get_keyboard_types = [null,];
static const wl_interface*[1] _wl_seat_request_get_touch_types = [null,];
static const wl_interface*[0] _wl_seat_request_release_types = [];
static const wl_interface*[1] _wl_seat_event_capabilities_types = [null,];
static const wl_interface*[1] _wl_seat_event_name_types = [null,];
static const wl_message[4] _wl_seat_requests  = [wl_message ("get_pointer","9n",_wl_seat_request_get_pointer_types.ptr),wl_message ("get_keyboard","9n",_wl_seat_request_get_keyboard_types.ptr),wl_message ("get_touch","9n",_wl_seat_request_get_touch_types.ptr),wl_message ("release","9",_wl_seat_request_release_types.ptr),];
static const wl_message[2] _wl_seat_events    = [wl_message ("capabilities","9u",_wl_seat_event_capabilities_types.ptr),wl_message ("name","9s",_wl_seat_event_name_types.ptr),];
static const wl_interface wl_seat_interface = {
    "wl_seat", 9,
    4, _wl_seat_requests.ptr,
    2, _wl_seat_events.ptr
};

// module wayland.wl_pointer;

struct
wl_pointer {
  @disable this();
  @disable this(wl_pointer);
  @disable this(ref wl_pointer);

  // Requests
  pragma (inline,true):
  auto set_cursor (uint serial, void* surface, int hotspot_x, int hotspot_y) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_cursor   , serial, surface, hotspot_x, hotspot_y);  }
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    enter_cb enter;
    leave_cb leave;
    motion_cb motion;
    button_cb button;
    axis_cb axis;
    frame_cb frame;
    axis_source_cb axis_source;
    axis_stop_cb axis_stop;
    axis_discrete_cb axis_discrete;
    axis_value120_cb axis_value120;
    axis_relative_direction_cb axis_relative_direction;

    alias enter_cb = void function (void* data, wl_pointer* _wl_pointer, uint serial, void* surface, wl_fixed_t surface_x, wl_fixed_t surface_y);
    alias leave_cb = void function (void* data, wl_pointer* _wl_pointer, uint serial, void* surface);
    alias motion_cb = void function (void* data, wl_pointer* _wl_pointer, uint time, wl_fixed_t surface_x, wl_fixed_t surface_y);
    alias button_cb = void function (void* data, wl_pointer* _wl_pointer, uint serial, uint time, uint button, uint state);
    alias axis_cb = void function (void* data, wl_pointer* _wl_pointer, uint time, uint axis, wl_fixed_t value);
    alias frame_cb = void function (void* data, wl_pointer* _wl_pointer);
    alias axis_source_cb = void function (void* data, wl_pointer* _wl_pointer, uint axis_source);
    alias axis_stop_cb = void function (void* data, wl_pointer* _wl_pointer, uint time, uint axis);
    alias axis_discrete_cb = void function (void* data, wl_pointer* _wl_pointer, uint axis, int discrete);
    alias axis_value120_cb = void function (void* data, wl_pointer* _wl_pointer, uint axis, int value120);
    alias axis_relative_direction_cb = void function (void* data, wl_pointer* _wl_pointer, uint axis, uint direction);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[4] _wl_pointer_request_set_cursor_types = [null,&wl_surface_interface,null,null,];
static const wl_interface*[0] _wl_pointer_request_release_types = [];
static const wl_interface*[4] _wl_pointer_event_enter_types = [null,&wl_surface_interface,null,null,];
static const wl_interface*[2] _wl_pointer_event_leave_types = [null,&wl_surface_interface,];
static const wl_interface*[3] _wl_pointer_event_motion_types = [null,null,null,];
static const wl_interface*[4] _wl_pointer_event_button_types = [null,null,null,null,];
static const wl_interface*[3] _wl_pointer_event_axis_types = [null,null,null,];
static const wl_interface*[0] _wl_pointer_event_frame_types = [];
static const wl_interface*[1] _wl_pointer_event_axis_source_types = [null,];
static const wl_interface*[2] _wl_pointer_event_axis_stop_types = [null,null,];
static const wl_interface*[2] _wl_pointer_event_axis_discrete_types = [null,null,];
static const wl_interface*[2] _wl_pointer_event_axis_value120_types = [null,null,];
static const wl_interface*[2] _wl_pointer_event_axis_relative_direction_types = [null,null,];
static const wl_message[2] _wl_pointer_requests  = [wl_message ("set_cursor","9u?oii",_wl_pointer_request_set_cursor_types.ptr),wl_message ("release","9",_wl_pointer_request_release_types.ptr),];
static const wl_message[11] _wl_pointer_events    = [wl_message ("enter","9uoff",_wl_pointer_event_enter_types.ptr),wl_message ("leave","9uo",_wl_pointer_event_leave_types.ptr),wl_message ("motion","9uff",_wl_pointer_event_motion_types.ptr),wl_message ("button","9uuuu",_wl_pointer_event_button_types.ptr),wl_message ("axis","9uuf",_wl_pointer_event_axis_types.ptr),wl_message ("frame","9",_wl_pointer_event_frame_types.ptr),wl_message ("axis_source","9u",_wl_pointer_event_axis_source_types.ptr),wl_message ("axis_stop","9uu",_wl_pointer_event_axis_stop_types.ptr),wl_message ("axis_discrete","9ui",_wl_pointer_event_axis_discrete_types.ptr),wl_message ("axis_value120","9ui",_wl_pointer_event_axis_value120_types.ptr),wl_message ("axis_relative_direction","9uu",_wl_pointer_event_axis_relative_direction_types.ptr),];
static const wl_interface wl_pointer_interface = {
    "wl_pointer", 9,
    2, _wl_pointer_requests.ptr,
    11, _wl_pointer_events.ptr
};

// module wayland.wl_keyboard;

struct
wl_keyboard {
  @disable this();
  @disable this(wl_keyboard);
  @disable this(ref wl_keyboard);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    keymap_cb keymap;
    enter_cb enter;
    leave_cb leave;
    key_cb key;
    modifiers_cb modifiers;
    repeat_info_cb repeat_info;

    alias keymap_cb = void function (void* data, wl_keyboard* _wl_keyboard, uint format, int fd, uint size);
    alias enter_cb = void function (void* data, wl_keyboard* _wl_keyboard, uint serial, void* surface, wl_array* keys);
    alias leave_cb = void function (void* data, wl_keyboard* _wl_keyboard, uint serial, void* surface);
    alias key_cb = void function (void* data, wl_keyboard* _wl_keyboard, uint serial, uint time, uint key, uint state);
    alias modifiers_cb = void function (void* data, wl_keyboard* _wl_keyboard, uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group);
    alias repeat_info_cb = void function (void* data, wl_keyboard* _wl_keyboard, int rate, int delay);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[0] _wl_keyboard_request_release_types = [];
static const wl_interface*[3] _wl_keyboard_event_keymap_types = [null,null,null,];
static const wl_interface*[3] _wl_keyboard_event_enter_types = [null,&wl_surface_interface,null,];
static const wl_interface*[2] _wl_keyboard_event_leave_types = [null,&wl_surface_interface,];
static const wl_interface*[4] _wl_keyboard_event_key_types = [null,null,null,null,];
static const wl_interface*[5] _wl_keyboard_event_modifiers_types = [null,null,null,null,null,];
static const wl_interface*[2] _wl_keyboard_event_repeat_info_types = [null,null,];
static const wl_message[1] _wl_keyboard_requests  = [wl_message ("release","9",_wl_keyboard_request_release_types.ptr),];
static const wl_message[6] _wl_keyboard_events    = [wl_message ("keymap","9uhu",_wl_keyboard_event_keymap_types.ptr),wl_message ("enter","9uoa",_wl_keyboard_event_enter_types.ptr),wl_message ("leave","9uo",_wl_keyboard_event_leave_types.ptr),wl_message ("key","9uuuu",_wl_keyboard_event_key_types.ptr),wl_message ("modifiers","9uuuuu",_wl_keyboard_event_modifiers_types.ptr),wl_message ("repeat_info","9ii",_wl_keyboard_event_repeat_info_types.ptr),];
static const wl_interface wl_keyboard_interface = {
    "wl_keyboard", 9,
    1, _wl_keyboard_requests.ptr,
    6, _wl_keyboard_events.ptr
};

// module wayland.wl_touch;

struct
wl_touch {
  @disable this();
  @disable this(wl_touch);
  @disable this(ref wl_touch);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    down_cb down;
    up_cb up;
    motion_cb motion;
    frame_cb frame;
    cancel_cb cancel;
    shape_cb shape;
    orientation_cb orientation;

    alias down_cb = void function (void* data, wl_touch* _wl_touch, uint serial, uint time, void* surface, int id, wl_fixed_t x, wl_fixed_t y);
    alias up_cb = void function (void* data, wl_touch* _wl_touch, uint serial, uint time, int id);
    alias motion_cb = void function (void* data, wl_touch* _wl_touch, uint time, int id, wl_fixed_t x, wl_fixed_t y);
    alias frame_cb = void function (void* data, wl_touch* _wl_touch);
    alias cancel_cb = void function (void* data, wl_touch* _wl_touch);
    alias shape_cb = void function (void* data, wl_touch* _wl_touch, int id, wl_fixed_t major, wl_fixed_t minor);
    alias orientation_cb = void function (void* data, wl_touch* _wl_touch, int id, wl_fixed_t orientation);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }
}

// Interface
static const wl_interface*[0] _wl_touch_request_release_types = [];
static const wl_interface*[6] _wl_touch_event_down_types = [null,null,&wl_surface_interface,null,null,null,];
static const wl_interface*[3] _wl_touch_event_up_types = [null,null,null,];
static const wl_interface*[4] _wl_touch_event_motion_types = [null,null,null,null,];
static const wl_interface*[0] _wl_touch_event_frame_types = [];
static const wl_interface*[0] _wl_touch_event_cancel_types = [];
static const wl_interface*[3] _wl_touch_event_shape_types = [null,null,null,];
static const wl_interface*[2] _wl_touch_event_orientation_types = [null,null,];
static const wl_message[1] _wl_touch_requests  = [wl_message ("release","9",_wl_touch_request_release_types.ptr),];
static const wl_message[7] _wl_touch_events    = [wl_message ("down","9uuoiff",_wl_touch_event_down_types.ptr),wl_message ("up","9uui",_wl_touch_event_up_types.ptr),wl_message ("motion","9uiff",_wl_touch_event_motion_types.ptr),wl_message ("frame","9",_wl_touch_event_frame_types.ptr),wl_message ("cancel","9",_wl_touch_event_cancel_types.ptr),wl_message ("shape","9iff",_wl_touch_event_shape_types.ptr),wl_message ("orientation","9if",_wl_touch_event_orientation_types.ptr),];
static const wl_interface wl_touch_interface = {
    "wl_touch", 9,
    1, _wl_touch_requests.ptr,
    7, _wl_touch_events.ptr
};

// module wayland.wl_output;

struct
wl_output {
  @disable this();
  @disable this(wl_output);
  @disable this(ref wl_output);

  // Requests
  pragma (inline,true):
  auto release () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.release   );  }

  // Events
  struct
  Listener {
    geometry_cb geometry;
    mode_cb mode;
    done_cb done;
    scale_cb scale;
    name_cb name;
    description_cb description;

    alias geometry_cb = void function (void* data, wl_output* _wl_output, int x, int y, int physical_width, int physical_height, int subpixel, const(char)* make, const(char)* model, int transform);
    alias mode_cb = void function (void* data, wl_output* _wl_output, uint flags, int width, int height, int refresh);
    alias done_cb = void function (void* data, wl_output* _wl_output);
    alias scale_cb = void function (void* data, wl_output* _wl_output, int factor);
    alias name_cb = void function (void* data, wl_output* _wl_output, const(char)* name);
    alias description_cb = void function (void* data, wl_output* _wl_output, const(char)* description);
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }

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

// Interface
static const wl_interface*[0] _wl_output_request_release_types = [];
static const wl_interface*[8] _wl_output_event_geometry_types = [null,null,null,null,null,null,null,null,];
static const wl_interface*[4] _wl_output_event_mode_types = [null,null,null,null,];
static const wl_interface*[0] _wl_output_event_done_types = [];
static const wl_interface*[1] _wl_output_event_scale_types = [null,];
static const wl_interface*[1] _wl_output_event_name_types = [null,];
static const wl_interface*[1] _wl_output_event_description_types = [null,];
static const wl_message[1] _wl_output_requests  = [wl_message ("release","4",_wl_output_request_release_types.ptr),];
static const wl_message[6] _wl_output_events    = [wl_message ("geometry","4iiiiissi",_wl_output_event_geometry_types.ptr),wl_message ("mode","4uiii",_wl_output_event_mode_types.ptr),wl_message ("done","4",_wl_output_event_done_types.ptr),wl_message ("scale","4i",_wl_output_event_scale_types.ptr),wl_message ("name","4s",_wl_output_event_name_types.ptr),wl_message ("description","4s",_wl_output_event_description_types.ptr),];
static const wl_interface wl_output_interface = {
    "wl_output", 4,
    1, _wl_output_requests.ptr,
    6, _wl_output_events.ptr
};

// module wayland.wl_region;

struct
wl_region {
  @disable this();
  @disable this(wl_region);
  @disable this(ref wl_region);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto add (int x, int y, int width, int height) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.add   , x, y, width, height);  }
  auto subtract (int x, int y, int width, int height) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.subtract   , x, y, width, height);  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    add = 1,
    subtract = 2,
  }
}

// Interface
static const wl_interface*[0] _wl_region_request_destroy_types = [];
static const wl_interface*[4] _wl_region_request_add_types = [null,null,null,null,];
static const wl_interface*[4] _wl_region_request_subtract_types = [null,null,null,null,];
static const wl_message[3] _wl_region_requests  = [wl_message ("destroy","",_wl_region_request_destroy_types.ptr),wl_message ("add","iiii",_wl_region_request_add_types.ptr),wl_message ("subtract","iiii",_wl_region_request_subtract_types.ptr),];
static const wl_message[0] _wl_region_events    = [];
static const wl_interface wl_region_interface = {
    "wl_region", 1,
    3, _wl_region_requests.ptr,
    0, _wl_region_events.ptr
};

// module wayland.wl_subcompositor;

struct
wl_subcompositor {
  @disable this();
  @disable this(wl_subcompositor);
  @disable this(ref wl_subcompositor);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto get_subsurface (void* surface, void* parent) { return cast (wl_subsurface*) wl_proxy_marshal_constructor (cast(wl_proxy*)&this, opcode.get_subsurface , &wl_subsurface_interface  , null, surface, parent);  }

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

// Interface
static const wl_interface*[0] _wl_subcompositor_request_destroy_types = [];
static const wl_interface*[3] _wl_subcompositor_request_get_subsurface_types = [null,&wl_surface_interface,&wl_surface_interface,];
static const wl_message[2] _wl_subcompositor_requests  = [wl_message ("destroy","",_wl_subcompositor_request_destroy_types.ptr),wl_message ("get_subsurface","noo",_wl_subcompositor_request_get_subsurface_types.ptr),];
static const wl_message[0] _wl_subcompositor_events    = [];
static const wl_interface wl_subcompositor_interface = {
    "wl_subcompositor", 1,
    2, _wl_subcompositor_requests.ptr,
    0, _wl_subcompositor_events.ptr
};

// module wayland.wl_subsurface;

struct
wl_subsurface {
  @disable this();
  @disable this(wl_subsurface);
  @disable this(ref wl_subsurface);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.destroy   );  }
  auto set_position (int x, int y) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_position   , x, y);  }
  auto place_above (void* sibling) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.place_above   , sibling);  }
  auto place_below (void* sibling) {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.place_below   , sibling);  }
  auto set_sync () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_sync   );  }
  auto set_desync () {  wl_proxy_marshal (cast(wl_proxy*)&this, opcode.set_desync   );  }

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

// Interface
static const wl_interface*[0] _wl_subsurface_request_destroy_types = [];
static const wl_interface*[2] _wl_subsurface_request_set_position_types = [null,null,];
static const wl_interface*[1] _wl_subsurface_request_place_above_types = [&wl_surface_interface,];
static const wl_interface*[1] _wl_subsurface_request_place_below_types = [&wl_surface_interface,];
static const wl_interface*[0] _wl_subsurface_request_set_sync_types = [];
static const wl_interface*[0] _wl_subsurface_request_set_desync_types = [];
static const wl_message[6] _wl_subsurface_requests  = [wl_message ("destroy","",_wl_subsurface_request_destroy_types.ptr),wl_message ("set_position","ii",_wl_subsurface_request_set_position_types.ptr),wl_message ("place_above","o",_wl_subsurface_request_place_above_types.ptr),wl_message ("place_below","o",_wl_subsurface_request_place_below_types.ptr),wl_message ("set_sync","",_wl_subsurface_request_set_sync_types.ptr),wl_message ("set_desync","",_wl_subsurface_request_set_desync_types.ptr),];
static const wl_message[0] _wl_subsurface_events    = [];
static const wl_interface wl_subsurface_interface = {
    "wl_subsurface", 1,
    6, _wl_subsurface_requests.ptr,
    0, _wl_subsurface_events.ptr
};

// wl_proxy interface
static const wl_message[6] _wl_proxy_interface_requests  = [];
static const wl_message[0] _wl_proxy_interface_events    = [];
static const wl_interface wl_proxy_interface = {
    "wl_proxy", 1,
    0, _wl_proxy_interface_requests.ptr,
    0, _wl_proxy_interface_events.ptr
};
