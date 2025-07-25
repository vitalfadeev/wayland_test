// protocol wayland
module wayland.protocol;

// module wayland.wl_display;

extern (C):

struct
wl_display {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto sync () { return cast (wl_callback) wl_proxy_marshal_flags (_super, opcode.sync, &wl_callback.interface, wl_proxy_get_version (_super), 0, null);  }
  auto get_registry () { return cast (wl_registry) wl_proxy_marshal_flags (_super, opcode.get_registry, &wl_registry.interface, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    error_cb error;
    delete_id_cb delete_id;

    alias error_cb = void function (void* data, wl_display* wl_display, object object_id, uint code, string message);
    alias delete_id_cb = void function (void* data, wl_display* wl_display, uint id);
  }

  // Enums
  enum
  error {
    invalid_object = 0,
    invalid_method = 1,
    no_memory = 2,
    implementation = 3,
  }

  // Opcodes
  enum
  opcode : uint {
    sync = 0,
    get_registry = 1,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_display", 1,
    2, _requests,
    2, _events
  };
}

// module wayland.wl_registry;

extern (C):

struct
wl_registry {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto bind (uint name) { return           wl_proxy_marshal_flags (_super, opcode.bind, &new_id.interface, wl_proxy_get_version (_super), 0, null, name);  }

  // Events
  struct
  Listener {
    global_cb global;
    global_remove_cb global_remove;

    alias global_cb = void function (void* data, wl_registry* wl_registry, uint name, string iface, uint ver);
    alias global_remove_cb = void function (void* data, wl_registry* wl_registry, uint name);
  }

  // Opcodes
  enum
  opcode : uint {
    bind = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_registry", 1,
    1, _requests,
    2, _events
  };
}

// module wayland.wl_callback;

extern (C):

struct
wl_callback {
  wl_proxy* _super;
  alias _super this;

  // Events
  struct
  Listener {
    done_cb done;

    alias done_cb = void function (void* data, wl_callback* wl_callback, uint callback_data);
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_callback", 1,
    0, _requests,
    1, _events
  };
}

// module wayland.wl_compositor;

extern (C):

struct
wl_compositor {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto create_surface () { return cast (wl_surface) wl_proxy_marshal_flags (_super, opcode.create_surface, &wl_surface.interface, wl_proxy_get_version (_super), 0, null);  }
  auto create_region () { return cast (wl_region) wl_proxy_marshal_flags (_super, opcode.create_region, &wl_region.interface, wl_proxy_get_version (_super), 0, null);  }

  // Opcodes
  enum
  opcode : uint {
    create_surface = 0,
    create_region = 1,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_compositor", 6,
    2, _requests,
    0, _events
  };
}

// module wayland.wl_shm_pool;

extern (C):

struct
wl_shm_pool {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto create_buffer (int offset, int width, int height, int stride, uint format) { return cast (wl_buffer) wl_proxy_marshal_flags (_super, opcode.create_buffer, &wl_buffer.interface, wl_proxy_get_version (_super), 0, null, offset, width, height, stride, format);  }
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto resize (int size) {                  wl_proxy_marshal_flags (_super, opcode.resize,          null, wl_proxy_get_version (_super), 0, null, size);  }

  // Opcodes
  enum
  opcode : uint {
    create_buffer = 0,
    destroy = 1,
    resize = 2,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_shm_pool", 2,
    3, _requests,
    0, _events
  };
}

// module wayland.wl_shm;

extern (C):

struct
wl_shm {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto create_pool (fd fd, int size) { return cast (wl_shm_pool) wl_proxy_marshal_flags (_super, opcode.create_pool, &wl_shm_pool.interface, wl_proxy_get_version (_super), 0, null, fd, size);  }
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    format_cb format;

    alias format_cb = void function (void* data, wl_shm* wl_shm, uint format);
  }

  // Enums
  enum
  error {
    invalid_format = 0,
    invalid_stride = 1,
    invalid_fd = 2,
  }
  enum
  format {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_shm", 2,
    2, _requests,
    1, _events
  };
}

// module wayland.wl_buffer;

extern (C):

struct
wl_buffer {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    release_cb release;

    alias release_cb = void function (void* data, wl_buffer* wl_buffer);
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_buffer", 1,
    1, _requests,
    1, _events
  };
}

// module wayland.wl_data_offer;

extern (C):

struct
wl_data_offer {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto accept (uint serial, string mime_type) {                  wl_proxy_marshal_flags (_super, opcode.accept,          null, wl_proxy_get_version (_super), 0, null, serial, mime_type);  }
  auto receive (string mime_type, fd fd) {                  wl_proxy_marshal_flags (_super, opcode.receive,          null, wl_proxy_get_version (_super), 0, null, mime_type, fd);  }
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto finish () {                  wl_proxy_marshal_flags (_super, opcode.finish,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_actions (uint dnd_actions, uint preferred_action) {                  wl_proxy_marshal_flags (_super, opcode.set_actions,          null, wl_proxy_get_version (_super), 0, null, dnd_actions, preferred_action);  }

  // Events
  struct
  Listener {
    offer_cb offer;
    source_actions_cb source_actions;
    action_cb action;

    alias offer_cb = void function (void* data, wl_data_offer* wl_data_offer, string mime_type);
    alias source_actions_cb = void function (void* data, wl_data_offer* wl_data_offer, uint source_actions);
    alias action_cb = void function (void* data, wl_data_offer* wl_data_offer, uint dnd_action);
  }

  // Enums
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_data_offer", 3,
    5, _requests,
    3, _events
  };
}

// module wayland.wl_data_source;

extern (C):

struct
wl_data_source {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto offer (string mime_type) {                  wl_proxy_marshal_flags (_super, opcode.offer,          null, wl_proxy_get_version (_super), 0, null, mime_type);  }
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_actions (uint dnd_actions) {                  wl_proxy_marshal_flags (_super, opcode.set_actions,          null, wl_proxy_get_version (_super), 0, null, dnd_actions);  }

  // Events
  struct
  Listener {
    target_cb target;
    send_cb send;
    cancelled_cb cancelled;
    dnd_drop_performed_cb dnd_drop_performed;
    dnd_finished_cb dnd_finished;
    action_cb action;

    alias target_cb = void function (void* data, wl_data_source* wl_data_source, string mime_type);
    alias send_cb = void function (void* data, wl_data_source* wl_data_source, string mime_type, fd fd);
    alias cancelled_cb = void function (void* data, wl_data_source* wl_data_source);
    alias dnd_drop_performed_cb = void function (void* data, wl_data_source* wl_data_source);
    alias dnd_finished_cb = void function (void* data, wl_data_source* wl_data_source);
    alias action_cb = void function (void* data, wl_data_source* wl_data_source, uint dnd_action);
  }

  // Enums
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_data_source", 3,
    3, _requests,
    6, _events
  };
}

// module wayland.wl_data_device;

extern (C):

struct
wl_data_device {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto start_drag (wl_data_source source, wl_surface origin, wl_surface icon, uint serial) {                  wl_proxy_marshal_flags (_super, opcode.start_drag,          null, wl_proxy_get_version (_super), 0, null, source, origin, icon, serial);  }
  auto set_selection (wl_data_source source, uint serial) {                  wl_proxy_marshal_flags (_super, opcode.set_selection,          null, wl_proxy_get_version (_super), 0, null, source, serial);  }
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    data_offer_cb data_offer;
    enter_cb enter;
    leave_cb leave;
    motion_cb motion;
    drop_cb drop;
    selection_cb selection;

    alias data_offer_cb = void function (void* data, wl_data_device* wl_data_device, new_id id);
    alias enter_cb = void function (void* data, wl_data_device* wl_data_device, uint serial, object surface, fixed x, fixed y, object id);
    alias leave_cb = void function (void* data, wl_data_device* wl_data_device);
    alias motion_cb = void function (void* data, wl_data_device* wl_data_device, uint time, fixed x, fixed y);
    alias drop_cb = void function (void* data, wl_data_device* wl_data_device);
    alias selection_cb = void function (void* data, wl_data_device* wl_data_device, object id);
  }

  // Enums
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_data_device", 3,
    3, _requests,
    6, _events
  };
}

// module wayland.wl_data_device_manager;

extern (C):

struct
wl_data_device_manager {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto create_data_source () { return cast (wl_data_source) wl_proxy_marshal_flags (_super, opcode.create_data_source, &wl_data_source.interface, wl_proxy_get_version (_super), 0, null);  }
  auto get_data_device (wl_seat seat) { return cast (wl_data_device) wl_proxy_marshal_flags (_super, opcode.get_data_device, &wl_data_device.interface, wl_proxy_get_version (_super), 0, null, seat);  }

  // Enums
  enum
  dnd_action {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_data_device_manager", 3,
    2, _requests,
    0, _events
  };
}

// module wayland.wl_shell;

extern (C):

struct
wl_shell {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto get_shell_surface (wl_surface surface) { return cast (wl_shell_surface) wl_proxy_marshal_flags (_super, opcode.get_shell_surface, &wl_shell_surface.interface, wl_proxy_get_version (_super), 0, null, surface);  }

  // Enums
  enum
  error {
    role = 0,
  }

  // Opcodes
  enum
  opcode : uint {
    get_shell_surface = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_shell", 1,
    1, _requests,
    0, _events
  };
}

// module wayland.wl_shell_surface;

extern (C):

struct
wl_shell_surface {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto pong (uint serial) {                  wl_proxy_marshal_flags (_super, opcode.pong,          null, wl_proxy_get_version (_super), 0, null, serial);  }
  auto move (wl_seat seat, uint serial) {                  wl_proxy_marshal_flags (_super, opcode.move,          null, wl_proxy_get_version (_super), 0, null, seat, serial);  }
  auto resize (wl_seat seat, uint serial, uint edges) {                  wl_proxy_marshal_flags (_super, opcode.resize,          null, wl_proxy_get_version (_super), 0, null, seat, serial, edges);  }
  auto set_toplevel () {                  wl_proxy_marshal_flags (_super, opcode.set_toplevel,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_transient (wl_surface parent, int x, int y, uint flags) {                  wl_proxy_marshal_flags (_super, opcode.set_transient,          null, wl_proxy_get_version (_super), 0, null, parent, x, y, flags);  }
  auto set_fullscreen (uint method, uint framerate, wl_output output) {                  wl_proxy_marshal_flags (_super, opcode.set_fullscreen,          null, wl_proxy_get_version (_super), 0, null, method, framerate, output);  }
  auto set_popup (wl_seat seat, uint serial, wl_surface parent, int x, int y, uint flags) {                  wl_proxy_marshal_flags (_super, opcode.set_popup,          null, wl_proxy_get_version (_super), 0, null, seat, serial, parent, x, y, flags);  }
  auto set_maximized (wl_output output) {                  wl_proxy_marshal_flags (_super, opcode.set_maximized,          null, wl_proxy_get_version (_super), 0, null, output);  }
  auto set_title (string title) {                  wl_proxy_marshal_flags (_super, opcode.set_title,          null, wl_proxy_get_version (_super), 0, null, title);  }
  auto set_class (string class_) {                  wl_proxy_marshal_flags (_super, opcode.set_class,          null, wl_proxy_get_version (_super), 0, null, class_);  }

  // Events
  struct
  Listener {
    ping_cb ping;
    configure_cb configure;
    popup_done_cb popup_done;

    alias ping_cb = void function (void* data, wl_shell_surface* wl_shell_surface, uint serial);
    alias configure_cb = void function (void* data, wl_shell_surface* wl_shell_surface, uint edges, int width, int height);
    alias popup_done_cb = void function (void* data, wl_shell_surface* wl_shell_surface);
  }

  // Enums
  enum
  resize {
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
  transient {
    inactive = 0x1,
  }
  enum
  fullscreen_method {
    default = 0,
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_shell_surface", 1,
    10, _requests,
    3, _events
  };
}

// module wayland.wl_surface;

extern (C):

struct
wl_surface {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto attach (wl_buffer buffer, int x, int y) {                  wl_proxy_marshal_flags (_super, opcode.attach,          null, wl_proxy_get_version (_super), 0, null, buffer, x, y);  }
  auto damage (int x, int y, int width, int height) {                  wl_proxy_marshal_flags (_super, opcode.damage,          null, wl_proxy_get_version (_super), 0, null, x, y, width, height);  }
  auto frame () { return cast (wl_callback) wl_proxy_marshal_flags (_super, opcode.frame, &wl_callback.interface, wl_proxy_get_version (_super), 0, null);  }
  auto set_opaque_region (wl_region region) {                  wl_proxy_marshal_flags (_super, opcode.set_opaque_region,          null, wl_proxy_get_version (_super), 0, null, region);  }
  auto set_input_region (wl_region region) {                  wl_proxy_marshal_flags (_super, opcode.set_input_region,          null, wl_proxy_get_version (_super), 0, null, region);  }
  auto commit () {                  wl_proxy_marshal_flags (_super, opcode.commit,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_buffer_transform (int transform) {                  wl_proxy_marshal_flags (_super, opcode.set_buffer_transform,          null, wl_proxy_get_version (_super), 0, null, transform);  }
  auto set_buffer_scale (int scale) {                  wl_proxy_marshal_flags (_super, opcode.set_buffer_scale,          null, wl_proxy_get_version (_super), 0, null, scale);  }
  auto damage_buffer (int x, int y, int width, int height) {                  wl_proxy_marshal_flags (_super, opcode.damage_buffer,          null, wl_proxy_get_version (_super), 0, null, x, y, width, height);  }
  auto offset (int x, int y) {                  wl_proxy_marshal_flags (_super, opcode.offset,          null, wl_proxy_get_version (_super), 0, null, x, y);  }

  // Events
  struct
  Listener {
    enter_cb enter;
    leave_cb leave;
    preferred_buffer_scale_cb preferred_buffer_scale;
    preferred_buffer_transform_cb preferred_buffer_transform;

    alias enter_cb = void function (void* data, wl_surface* wl_surface, object output);
    alias leave_cb = void function (void* data, wl_surface* wl_surface, object output);
    alias preferred_buffer_scale_cb = void function (void* data, wl_surface* wl_surface, int factor);
    alias preferred_buffer_transform_cb = void function (void* data, wl_surface* wl_surface, uint transform);
  }

  // Enums
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_surface", 6,
    11, _requests,
    4, _events
  };
}

// module wayland.wl_seat;

extern (C):

struct
wl_seat {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto get_pointer () { return cast (wl_pointer) wl_proxy_marshal_flags (_super, opcode.get_pointer, &wl_pointer.interface, wl_proxy_get_version (_super), 0, null);  }
  auto get_keyboard () { return cast (wl_keyboard) wl_proxy_marshal_flags (_super, opcode.get_keyboard, &wl_keyboard.interface, wl_proxy_get_version (_super), 0, null);  }
  auto get_touch () { return cast (wl_touch) wl_proxy_marshal_flags (_super, opcode.get_touch, &wl_touch.interface, wl_proxy_get_version (_super), 0, null);  }
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    capabilities_cb capabilities;
    name_cb name;

    alias capabilities_cb = void function (void* data, wl_seat* wl_seat, uint capabilities);
    alias name_cb = void function (void* data, wl_seat* wl_seat, string name);
  }

  // Enums
  enum
  capability {
    pointer = 1,
    keyboard = 2,
    touch = 4,
  }
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_seat", 9,
    4, _requests,
    2, _events
  };
}

// module wayland.wl_pointer;

extern (C):

struct
wl_pointer {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto set_cursor (uint serial, wl_surface surface, int hotspot_x, int hotspot_y) {                  wl_proxy_marshal_flags (_super, opcode.set_cursor,          null, wl_proxy_get_version (_super), 0, null, serial, surface, hotspot_x, hotspot_y);  }
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

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

    alias enter_cb = void function (void* data, wl_pointer* wl_pointer, uint serial, object surface, fixed surface_x, fixed surface_y);
    alias leave_cb = void function (void* data, wl_pointer* wl_pointer, uint serial, object surface);
    alias motion_cb = void function (void* data, wl_pointer* wl_pointer, uint time, fixed surface_x, fixed surface_y);
    alias button_cb = void function (void* data, wl_pointer* wl_pointer, uint serial, uint time, uint button, uint state);
    alias axis_cb = void function (void* data, wl_pointer* wl_pointer, uint time, uint axis, fixed value);
    alias frame_cb = void function (void* data, wl_pointer* wl_pointer);
    alias axis_source_cb = void function (void* data, wl_pointer* wl_pointer, uint axis_source);
    alias axis_stop_cb = void function (void* data, wl_pointer* wl_pointer, uint time, uint axis);
    alias axis_discrete_cb = void function (void* data, wl_pointer* wl_pointer, uint axis, int discrete);
    alias axis_value120_cb = void function (void* data, wl_pointer* wl_pointer, uint axis, int value120);
    alias axis_relative_direction_cb = void function (void* data, wl_pointer* wl_pointer, uint axis, uint direction);
  }

  // Enums
  enum
  error {
    role = 0,
  }
  enum
  button_state {
    released = 0,
    pressed = 1,
  }
  enum
  axis {
    vertical_scroll = 0,
    horizontal_scroll = 1,
  }
  enum
  axis_source {
    wheel = 0,
    finger = 1,
    continuous = 2,
    wheel_tilt = 3,
  }
  enum
  axis_relative_direction {
    identical = 0,
    inverted = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    set_cursor = 0,
    release = 1,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_pointer", 9,
    2, _requests,
    11, _events
  };
}

// module wayland.wl_keyboard;

extern (C):

struct
wl_keyboard {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    keymap_cb keymap;
    enter_cb enter;
    leave_cb leave;
    key_cb key;
    modifiers_cb modifiers;
    repeat_info_cb repeat_info;

    alias keymap_cb = void function (void* data, wl_keyboard* wl_keyboard, uint format, fd fd, uint size);
    alias enter_cb = void function (void* data, wl_keyboard* wl_keyboard, uint serial, object surface, array keys);
    alias leave_cb = void function (void* data, wl_keyboard* wl_keyboard, uint serial, object surface);
    alias key_cb = void function (void* data, wl_keyboard* wl_keyboard, uint serial, uint time, uint key, uint state);
    alias modifiers_cb = void function (void* data, wl_keyboard* wl_keyboard, uint serial, uint mods_depressed, uint mods_latched, uint mods_locked, uint group);
    alias repeat_info_cb = void function (void* data, wl_keyboard* wl_keyboard, int rate, int delay);
  }

  // Enums
  enum
  keymap_format {
    no_keymap = 0,
    xkb_v1 = 1,
  }
  enum
  key_state {
    released = 0,
    pressed = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_keyboard", 9,
    1, _requests,
    6, _events
  };
}

// module wayland.wl_touch;

extern (C):

struct
wl_touch {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

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

    alias down_cb = void function (void* data, wl_touch* wl_touch, uint serial, uint time, object surface, int id, fixed x, fixed y);
    alias up_cb = void function (void* data, wl_touch* wl_touch, uint serial, uint time, int id);
    alias motion_cb = void function (void* data, wl_touch* wl_touch, uint time, int id, fixed x, fixed y);
    alias frame_cb = void function (void* data, wl_touch* wl_touch);
    alias cancel_cb = void function (void* data, wl_touch* wl_touch);
    alias shape_cb = void function (void* data, wl_touch* wl_touch, int id, fixed major, fixed minor);
    alias orientation_cb = void function (void* data, wl_touch* wl_touch, int id, fixed orientation);
  }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_touch", 9,
    1, _requests,
    7, _events
  };
}

// module wayland.wl_output;

extern (C):

struct
wl_output {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto release () {                  wl_proxy_marshal_flags (_super, opcode.release,          null, wl_proxy_get_version (_super), 0, null);  }

  // Events
  struct
  Listener {
    geometry_cb geometry;
    mode_cb mode;
    done_cb done;
    scale_cb scale;
    name_cb name;
    description_cb description;

    alias geometry_cb = void function (void* data, wl_output* wl_output, int x, int y, int physical_width, int physical_height, int subpixel, string make, string model, int transform);
    alias mode_cb = void function (void* data, wl_output* wl_output, uint flags, int width, int height, int refresh);
    alias done_cb = void function (void* data, wl_output* wl_output);
    alias scale_cb = void function (void* data, wl_output* wl_output, int factor);
    alias name_cb = void function (void* data, wl_output* wl_output, string name);
    alias description_cb = void function (void* data, wl_output* wl_output, string description);
  }

  // Enums
  enum
  subpixel {
    unknown = 0,
    none = 1,
    horizontal_rgb = 2,
    horizontal_bgr = 3,
    vertical_rgb = 4,
    vertical_bgr = 5,
  }
  enum
  transform {
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
  mode {
    current = 0x1,
    preferred = 0x2,
  }

  // Opcodes
  enum
  opcode : uint {
    release = 0,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_output", 4,
    1, _requests,
    6, _events
  };
}

// module wayland.wl_region;

extern (C):

struct
wl_region {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto add (int x, int y, int width, int height) {                  wl_proxy_marshal_flags (_super, opcode.add,          null, wl_proxy_get_version (_super), 0, null, x, y, width, height);  }
  auto subtract (int x, int y, int width, int height) {                  wl_proxy_marshal_flags (_super, opcode.subtract,          null, wl_proxy_get_version (_super), 0, null, x, y, width, height);  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    add = 1,
    subtract = 2,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_region", 1,
    3, _requests,
    0, _events
  };
}

// module wayland.wl_subcompositor;

extern (C):

struct
wl_subcompositor {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto get_subsurface (wl_surface surface, wl_surface parent) { return cast (wl_subsurface) wl_proxy_marshal_flags (_super, opcode.get_subsurface, &wl_subsurface.interface, wl_proxy_get_version (_super), 0, null, surface, parent);  }

  // Enums
  enum
  error {
    bad_surface = 0,
    bad_parent = 1,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    get_subsurface = 1,
  }

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_subcompositor", 1,
    2, _requests,
    0, _events
  };
}

// module wayland.wl_subsurface;

extern (C):

struct
wl_subsurface {
  wl_proxy* _super;
  alias _super this;

  // Requests
  pragma (inline,true):
  auto destroy () {                  wl_proxy_marshal_flags (_super, opcode.destroy,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_position (int x, int y) {                  wl_proxy_marshal_flags (_super, opcode.set_position,          null, wl_proxy_get_version (_super), 0, null, x, y);  }
  auto place_above (wl_surface sibling) {                  wl_proxy_marshal_flags (_super, opcode.place_above,          null, wl_proxy_get_version (_super), 0, null, sibling);  }
  auto place_below (wl_surface sibling) {                  wl_proxy_marshal_flags (_super, opcode.place_below,          null, wl_proxy_get_version (_super), 0, null, sibling);  }
  auto set_sync () {                  wl_proxy_marshal_flags (_super, opcode.set_sync,          null, wl_proxy_get_version (_super), 0, null);  }
  auto set_desync () {                  wl_proxy_marshal_flags (_super, opcode.set_desync,          null, wl_proxy_get_version (_super), 0, null);  }

  // Enums
  enum
  error {
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

  // Interface
  static const wl_message[] _requests = [wl_message ()];
  static const wl_message[] _events   = [wl_message ()];
  static const wl_interface interface = {
    "wl_subsurface", 1,
    6, _requests,
    0, _events
  };
}

