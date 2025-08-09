// protocol xdg_shell
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

// module xdg_shell.xdg_wm_base;

struct
xdg_wm_base {
  @disable this();
  @disable this(xdg_wm_base);
  @disable this(ref xdg_wm_base);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.destroy /* ret interface: */  /* request args: */ ); }
  auto create_positioner () { return cast (xdg_positioner*) wl_proxy_marshal_constructor (cast (wl_proxy*) &this, opcode.create_positioner /* ret interface: */ , &xdg_positioner_interface /* request args: */ ); }
  auto get_xdg_surface (void* surface) { return cast (xdg_surface*) wl_proxy_marshal_constructor (cast (wl_proxy*) &this, opcode.get_xdg_surface /* ret interface: */ , &xdg_surface_interface /* request args: */ , surface); }
  auto pong (uint serial) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.pong /* ret interface: */  /* request args: */ , serial); }

  // Events
  struct
  Listener {
    ping_cb ping = &_ping_impl_default;

    alias ping_cb = extern (C) void function (void* data, xdg_wm_base* _this /* args: */ , uint serial);

    extern (C)
    static
    void
    _ping_impl_default (void* data, xdg_wm_base* _this /* args: */ , uint serial) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    role = 0,
    defunct_surfaces = 1,
    not_the_topmost_popup = 2,
    invalid_popup_parent = 3,
    invalid_surface_state = 4,
    invalid_positioner = 5,
    unresponsive = 6,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    create_positioner = 1,
    get_xdg_surface = 2,
    pong = 3,
  }
}

// interface
extern (C) extern __gshared wl_interface xdg_wm_base_interface;

// module xdg_shell.xdg_positioner;

struct
xdg_positioner {
  @disable this();
  @disable this(xdg_positioner);
  @disable this(ref xdg_positioner);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.destroy /* ret interface: */  /* request args: */ ); }
  auto set_size (int width,int height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_size /* ret interface: */  /* request args: */ , width,height); }
  auto set_anchor_rect (int x,int y,int width,int height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_anchor_rect /* ret interface: */  /* request args: */ , x,y,width,height); }
  auto set_anchor (uint anchor) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_anchor /* ret interface: */  /* request args: */ , anchor); }
  auto set_gravity (uint gravity) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_gravity /* ret interface: */  /* request args: */ , gravity); }
  auto set_constraint_adjustment (uint constraint_adjustment) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_constraint_adjustment /* ret interface: */  /* request args: */ , constraint_adjustment); }
  auto set_offset (int x,int y) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_offset /* ret interface: */  /* request args: */ , x,y); }
  auto set_reactive () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_reactive /* ret interface: */  /* request args: */ ); }
  auto set_parent_size (int parent_width,int parent_height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_parent_size /* ret interface: */  /* request args: */ , parent_width,parent_height); }
  auto set_parent_configure (uint serial) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_parent_configure /* ret interface: */  /* request args: */ , serial); }

  // Enums
  enum
  error_ {
    invalid_input = 0,
  }
  enum
  anchor_ {
    none = 0,
    top = 1,
    bottom = 2,
    left = 3,
    right = 4,
    top_left = 5,
    bottom_left = 6,
    top_right = 7,
    bottom_right = 8,
  }
  enum
  gravity_ {
    none = 0,
    top = 1,
    bottom = 2,
    left = 3,
    right = 4,
    top_left = 5,
    bottom_left = 6,
    top_right = 7,
    bottom_right = 8,
  }
  enum
  constraint_adjustment_ {
    none = 0,
    slide_x = 1,
    slide_y = 2,
    flip_x = 4,
    flip_y = 8,
    resize_x = 16,
    resize_y = 32,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    set_size = 1,
    set_anchor_rect = 2,
    set_anchor = 3,
    set_gravity = 4,
    set_constraint_adjustment = 5,
    set_offset = 6,
    set_reactive = 7,
    set_parent_size = 8,
    set_parent_configure = 9,
  }
}

// interface
extern (C) extern __gshared wl_interface xdg_positioner_interface;

// module xdg_shell.xdg_surface;

struct
xdg_surface {
  @disable this();
  @disable this(xdg_surface);
  @disable this(ref xdg_surface);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.destroy /* ret interface: */  /* request args: */ ); }
  auto get_toplevel () { return cast (xdg_toplevel*) wl_proxy_marshal_constructor (cast (wl_proxy*) &this, opcode.get_toplevel /* ret interface: */ , &xdg_toplevel_interface /* request args: */ ); }
  auto get_popup (void* parent,void* positioner) { return cast (xdg_popup*) wl_proxy_marshal_constructor (cast (wl_proxy*) &this, opcode.get_popup /* ret interface: */ , &xdg_popup_interface /* request args: */ , parent,positioner); }
  auto set_window_geometry (int x,int y,int width,int height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_window_geometry /* ret interface: */  /* request args: */ , x,y,width,height); }
  auto ack_configure (uint serial) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.ack_configure /* ret interface: */  /* request args: */ , serial); }

  // Events
  struct
  Listener {
    configure_cb configure = &_configure_impl_default;

    alias configure_cb = extern (C) void function (void* data, xdg_surface* _this /* args: */ , uint serial);

    extern (C)
    static
    void
    _configure_impl_default (void* data, xdg_surface* _this /* args: */ , uint serial) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    not_constructed = 1,
    already_constructed = 2,
    unconfigured_buffer = 3,
    invalid_serial = 4,
    invalid_size = 5,
    defunct_role_object = 6,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    get_toplevel = 1,
    get_popup = 2,
    set_window_geometry = 3,
    ack_configure = 4,
  }
}

// interface
extern (C) extern __gshared wl_interface xdg_surface_interface;

// module xdg_shell.xdg_toplevel;

struct
xdg_toplevel {
  @disable this();
  @disable this(xdg_toplevel);
  @disable this(ref xdg_toplevel);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.destroy /* ret interface: */  /* request args: */ ); }
  auto set_parent (void* parent) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_parent /* ret interface: */  /* request args: */ , parent); }
  auto set_title (const(char)* title) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_title /* ret interface: */  /* request args: */ , title); }
  auto set_app_id (const(char)* app_id) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_app_id /* ret interface: */  /* request args: */ , app_id); }
  auto show_window_menu (void* seat,uint serial,int x,int y) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.show_window_menu /* ret interface: */  /* request args: */ , seat,serial,x,y); }
  auto move (void* seat,uint serial) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.move /* ret interface: */  /* request args: */ , seat,serial); }
  auto resize (void* seat,uint serial,uint edges) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.resize /* ret interface: */  /* request args: */ , seat,serial,edges); }
  auto set_max_size (int width,int height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_max_size /* ret interface: */  /* request args: */ , width,height); }
  auto set_min_size (int width,int height) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_min_size /* ret interface: */  /* request args: */ , width,height); }
  auto set_maximized () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_maximized /* ret interface: */  /* request args: */ ); }
  auto unset_maximized () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.unset_maximized /* ret interface: */  /* request args: */ ); }
  auto set_fullscreen (void* output) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_fullscreen /* ret interface: */  /* request args: */ , output); }
  auto unset_fullscreen () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.unset_fullscreen /* ret interface: */  /* request args: */ ); }
  auto set_minimized () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.set_minimized /* ret interface: */  /* request args: */ ); }

  // Events
  struct
  Listener {
    configure_cb        configure        = &_configure_impl_default;
    close_cb            close            = &_close_impl_default;
    configure_bounds_cb configure_bounds = &_configure_bounds_impl_default;
    wm_capabilities_cb  wm_capabilities  = &_wm_capabilities_impl_default;

    alias configure_cb        = extern (C) void function (void* data, xdg_toplevel* _this /* args: */ , int width, int height, wl_array* states);
    alias close_cb            = extern (C) void function (void* data, xdg_toplevel* _this /* args: */ );
    alias configure_bounds_cb = extern (C) void function (void* data, xdg_toplevel* _this /* args: */ , int width, int height);
    alias wm_capabilities_cb  = extern (C) void function (void* data, xdg_toplevel* _this /* args: */ , wl_array* capabilities);

    extern (C)
    static
    void
    _configure_impl_default (void* data, xdg_toplevel* _this /* args: */ , int width, int height, wl_array* states) {
        // 
    }

    extern (C)
    static
    void
    _close_impl_default (void* data, xdg_toplevel* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _configure_bounds_impl_default (void* data, xdg_toplevel* _this /* args: */ , int width, int height) {
        // 
    }

    extern (C)
    static
    void
    _wm_capabilities_impl_default (void* data, xdg_toplevel* _this /* args: */ , wl_array* capabilities) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_resize_edge = 0,
    invalid_parent = 1,
    invalid_size = 2,
  }
  enum
  resize_edge_ {
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
  state_ {
    maximized = 1,
    fullscreen = 2,
    resizing = 3,
    activated = 4,
    tiled_left = 5,
    tiled_right = 6,
    tiled_top = 7,
    tiled_bottom = 8,
    suspended = 9,
    constrained_left = 10,
    constrained_right = 11,
    constrained_top = 12,
    constrained_bottom = 13,
  }
  enum
  wm_capabilities_ {
    window_menu = 1,
    maximize = 2,
    fullscreen = 3,
    minimize = 4,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    set_parent = 1,
    set_title = 2,
    set_app_id = 3,
    show_window_menu = 4,
    move = 5,
    resize = 6,
    set_max_size = 7,
    set_min_size = 8,
    set_maximized = 9,
    unset_maximized = 10,
    set_fullscreen = 11,
    unset_fullscreen = 12,
    set_minimized = 13,
  }
}

// interface
extern (C) extern __gshared wl_interface xdg_toplevel_interface;

// module xdg_shell.xdg_popup;

struct
xdg_popup {
  @disable this();
  @disable this(xdg_popup);
  @disable this(ref xdg_popup);

  // Requests
  pragma (inline,true):
  auto destroy () {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.destroy /* ret interface: */  /* request args: */ ); }
  auto grab (void* seat,uint serial) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.grab /* ret interface: */  /* request args: */ , seat,serial); }
  auto reposition (void* positioner,uint token) {  wl_proxy_marshal (cast (wl_proxy*) &this, opcode.reposition /* ret interface: */  /* request args: */ , positioner,token); }

  // Events
  struct
  Listener {
    configure_cb    configure    = &_configure_impl_default;
    popup_done_cb   popup_done   = &_popup_done_impl_default;
    repositioned_cb repositioned = &_repositioned_impl_default;

    alias configure_cb    = extern (C) void function (void* data, xdg_popup* _this /* args: */ , int x, int y, int width, int height);
    alias popup_done_cb   = extern (C) void function (void* data, xdg_popup* _this /* args: */ );
    alias repositioned_cb = extern (C) void function (void* data, xdg_popup* _this /* args: */ , uint token);

    extern (C)
    static
    void
    _configure_impl_default (void* data, xdg_popup* _this /* args: */ , int x, int y, int width, int height) {
        // 
    }

    extern (C)
    static
    void
    _popup_done_impl_default (void* data, xdg_popup* _this /* args: */ ) {
        // 
    }

    extern (C)
    static
    void
    _repositioned_impl_default (void* data, xdg_popup* _this /* args: */ , uint token) {
        // 
    }
  }

  // Event listener
  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, data); }

  // Enums
  enum
  error_ {
    invalid_grab = 0,
  }

  // Opcodes
  enum
  opcode : uint {
    destroy = 0,
    grab = 1,
    reposition = 2,
  }
}

// interface
extern (C) extern __gshared wl_interface xdg_popup_interface;

