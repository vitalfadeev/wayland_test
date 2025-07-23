module wayland_struct.proxy;

import wayland_struct.types;

extern (C) {
struct wl_proxy;

void            wl_proxy_marshal                             (wl_proxy* p, uint opcode, ...);
void            wl_proxy_marshal_array                       (wl_proxy* p, uint opcode, wl_argument* args);
wl_proxy*       wl_proxy_create                              (wl_proxy* factory, const (wl_interface*) iface);
wl_proxy*       wl_proxy_marshal_constructor                 (wl_proxy* proxy, uint opcode, const (wl_interface*) iface, ...);
wl_proxy*       wl_proxy_marshal_array_constructor           (wl_proxy* proxy, uint opcode, wl_argument* args, const (wl_interface*) iface);
void            wl_proxy_destroy                             (wl_proxy* proxy);
int             wl_proxy_add_listener                        (wl_proxy* proxy, void function()* implementation, void* data);
const (void*)   wl_proxy_get_listener                        (wl_proxy* proxy);
int             wl_proxy_add_dispatcher                      (wl_proxy* proxy, wl_dispatcher_func_t dispatcher_func, const (void*)  dispatcher_data, void* data);
void            wl_proxy_set_user_data                       (wl_proxy* proxy, void* user_data);
void*           wl_proxy_get_user_data                       (wl_proxy* proxy);
uint            wl_proxy_get_id                              (wl_proxy* proxy);
const (char*)   wl_proxy_get_class                           (wl_proxy* proxy);
void            wl_proxy_set_queue                           (wl_proxy* proxy, wl_event_queue* queue);
wl_proxy*       wl_proxy_marshal_flags                       (wl_proxy* proxy, uint32_t opcode, const wl_interface* interface_, uint32_t version_, uint32_t flags, ...);
wl_proxy*       wl_proxy_marshal_array_flags                 (wl_proxy* proxy, uint32_t opcode, const wl_interface* interface_, uint32_t version_, uint32_t flags, wl_argument* args);
void*           wl_proxy_create_wrapper                      (void*     proxy);
void            wl_proxy_wrapper_destroy                     (void*     proxy_wrapper);
wl_proxy*       wl_proxy_marshal_array_constructor_versioned (wl_proxy* proxy, uint32_t opcode, wl_argument* args, const wl_interface* interface_, uint32_t version_);
uint32_t        wl_proxy_get_version                         (wl_proxy* proxy);
void            wl_proxy_set_tag                             (wl_proxy* proxy, const char** tag);
char**          wl_proxy_get_tag                             (wl_proxy* proxy);
wl_proxy*       wl_proxy_marshal_constructor_versioned       (wl_proxy* proxy, uint32_t opcode, const wl_interface *interface_, uint32_t version_, ...);
}

struct
Proxy {
    wl_proxy* _super;
    alias _super this;

    alias Callback = extern (C) void function ();


    pragma (inline,true):
    auto marshal_flags                       (uint32_t opcode, const wl_interface* interface_, uint32_t version_, uint32_t flags ...)                { return wl_proxy_marshal_flags                         (_super,opcode,interface_,version_,flags); }
    auto marshal_array_flags                 (uint32_t opcode, const wl_interface* interface_, uint32_t version_, uint32_t flags, wl_argument* args) { return wl_proxy_marshal_array_flags                   (_super,opcode,interface_,version_,flags,args); }
    auto marshal                             (wl_proxy* p, uint32_t opcode, ...)                                                                     { return wl_proxy_marshal                               (p,opcode,_argptr); }
    auto marshal_array                       (wl_proxy* p, uint32_t opcode, wl_argument* args)                                                       { return wl_proxy_marshal_array                         (p,opcode,args); }
    auto create                              (wl_proxy* factory, const wl_interface* interface_)                                                     { return wl_proxy_create                                (factory,interface_); }
    auto create_wrapper                      (void* proxy)                                                                                           { return wl_proxy_create_wrapper                        (proxy); }
    auto wrapper_destroy                     (void* proxy_wrapper)                                                                                   { return wl_proxy_wrapper_destroy                       (proxy_wrapper); }
    auto marshal_constructor                 (uint32_t opcode, const wl_interface* interface_, ...)                                                  { return wl_proxy_marshal_constructor                   (_super,opcode,interface_,_argptr); }
    auto marshal_constructor_versioned       (uint32_t opcode, const wl_interface* interface_, uint32_t version_, ...)                               { return wl_proxy_marshal_constructor_versioned         (_super,opcode,interface_,version_,_argptr); }
    auto marshal_array_constructor           (uint32_t opcode, wl_argument* args, const wl_interface* interface_)                                    { return wl_proxy_marshal_array_constructor             (_super,opcode,args,interface_); }
    auto marshal_array_constructor_versioned (uint32_t opcode, wl_argument* args, const wl_interface* interface_, uint32_t version_)                 { return wl_proxy_marshal_array_constructor_versioned   (_super,opcode,args,interface_,version_); }
    auto add_listener                        (Callback* callback, void* data)                                                                        { return wl_proxy_add_listener                          (_super,callback,data); }
    auto get_listener                        ()                                                                                                      { return wl_proxy_get_listener                          (_super); }
    auto add_dispatcher                      (wl_dispatcher_func_t dispatcher_func, const void * dispatcher_data, void *data)                        { return wl_proxy_add_dispatcher                        (_super,dispatcher_func,dispatcher_data,data); }
    auto set_user_data                       (void *user_data)                                                                                       { return wl_proxy_set_user_data                         (_super,user_data); }
    auto get_user_data                       ()                                                                                                      { return wl_proxy_get_user_data                         (_super); }
    auto get_version                         ()                                                                                                      { return wl_proxy_get_version                           (_super); }
    auto get_id                              ()                                                                                                      { return wl_proxy_get_id                                (_super); }
    auto set_tag                             (const char** tag)                                                                                      { return wl_proxy_set_tag                               (_super,tag); }
    auto get_tag                             ()                                                                                                      { return wl_proxy_get_tag                               (_super); }
    auto get_class                           ()                                                                                                      { return wl_proxy_get_class                             (_super); }
    auto set_queue                           (wl_event_queue* queue)                                                                                 { return wl_proxy_set_queue                             (_super,queue); }
    auto destroy                             ()                                                                                                      { return wl_proxy_destroy                               (_super); }
}
