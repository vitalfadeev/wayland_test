import std.stdio;
import std.file;
import std.string;
import std.conv;
import dxml.dom;
import std.range : empty;
import std.algorithm.searching : canFind;
import std.algorithm.searching : countUntil;
import std : replicate;

void 
main (string[] args) {
	string file_name            = "wayland.xml";
	bool   generate_iface       = true;
	bool   import_base_protocol = false;
	if (args.length > 1) {
		file_name 			 = args[1];
		generate_iface 		 = true;
		import_base_protocol = true;
	}

	// READ-WRITE
	foreach (protocol; Reader (file_name))
		D_File_Writer (protocol,generate_iface,import_base_protocol).write ();
}

struct
Reader {
	Protocol[] protocols;
    alias protocols this;

    this (string file_name) {
		auto xml = readText (file_name);
	    auto dom = parseDOM (xml);

		foreach (c; dom.children)
			protocols ~= _Protocol (c);
   }
}


struct
D_File_Writer {
	Protocol protocol;
	bool     generate_iface;
	bool     import_base_protocol;

	void
	write () {
		// Protocol
		auto protocol_name = protocol.name;
		writefln ("// protocol %s", protocol_name);
		writefln ("module wayland_struct.protocol.%s;", protocol_name);
		writefln ("");
		writefln ("import wayland_struct.proxy : wl_proxy;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal_constructor;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal_constructor_versioned;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal_flags;");
		writefln ("import wayland_struct.proxy : wl_proxy_get_version;");
		writefln ("import wayland_struct.proxy : wl_proxy_add_listener;");
		writefln ("import wayland_struct.proxy : WL_MARSHAL_FLAG_DESTROY;");
		writefln ("import wayland_struct.util  : wl_proxy_callback;;");
		writefln ("import wayland_struct.util  : wl_message;");
		writefln ("import wayland_struct.util  : wl_interface;");
		writefln ("import wayland_struct.util  : wl_fixed_t;");
		writefln ("import wayland_struct.util  : wl_array;");
		if (import_base_protocol)
		writefln ("import wayland_struct.protocol.wayland;");
		writefln ("");

		foreach (iface; protocol.interfaces) {
			// wl_display,wl_registry skip
			if (iface.name == "wl_display")
				continue;
			//if (iface.name == "wl_registry")
			//	continue;

			// wl_registry request interface = "interface_"

			// Interface
			auto iface_name  = iface.name;
			writefln ("// module %s.%s;", protocol_name, iface_name);
			writefln ("");

			// Interface struct
			//auto struct_name = iface_name.capitalize;
			auto struct_name = iface_name;
			writefln ("struct");
			writefln ("%s {", struct_name);
			writefln ("  version (D_BetterC) {} else {");
			writefln ("  @disable this();");
			writefln ("  @disable this(%s);", struct_name);
			writefln ("  @disable this(ref %s);", struct_name);
			writefln ("  }");

			// Request
			if (iface.requests.length) {
				writefln ("");
				writefln ("  // Requests");
				writefln ("  pragma (inline,true):");
				foreach (req; iface.requests) {
					if (iface.name == "wl_registry" && req.name == "bind") {
						writeln ("  void*");
						writeln ("  bind (uint name, const wl_interface* interface_, uint version_ ) {");
						writeln ("  	return cast (void*) ");
						writeln ("  		wl_proxy_marshal_flags (");
						writeln ("  			cast (wl_proxy*) &this,");
						writeln ("  	        opcode.bind, ");
						writeln ("  	        interface_, ");
						writeln ("  	        version_, ");
						writeln ("  	        0, ");
						writeln ("  	        name, ");
						writeln ("  	        interface_.name, ");
						writeln ("  	        version_, ");
						writeln ("  	    	null");
						writeln ("  		);");
						writeln ("  }");
						continue;
					}

					string   ret_type  = "";  // check arg.type == "new_id" && check|get arg.interface_ 
					string   ret_name  = "";
					string[] req_args;

					// request (...)
					// , offset, width, height, stride, format
					string[] proxy_args;
					foreach (arg; req.args) {
						auto arg_name = arg.name.to_d_name;
						if (arg.type == "new_id") {  // return new _proxy | _object
							ret_type  = (arg.interface_.length)? arg.interface_: "wl_proxy";
							ret_name  = arg_name;
							proxy_args ~= "null";
						}
						else {                       // arg
							auto arg_type = arg.type.to_d_type (arg);  // wl_surface* surface -> Wl_surface surface
							req_args   ~= format!"%s %s" (arg_type, arg_name);
							proxy_args ~= arg_name;
						}
					}

					// request () { ... }
					string _ret;
					//string _fn = "wl_proxy_marshal";
					string _fn = "wl_proxy_marshal_flags";
					string _opcode = req.name;
					string _iface = "null";
					string _ver = format!"wl_proxy_get_version (cast (wl_proxy *) &this)" ();
					string _flags = "0";
					if (ret_type.length) {
						_ret   = format!"return cast (%s*)" (ret_type);
						//_fn    = "wl_proxy_marshal_constructor";
						_fn    = "wl_proxy_marshal_flags";
						_iface = format!"&%s_interface" (ret_type);
					}
					if (req.type == "destructor")
						_flags = "WL_MARSHAL_FLAG_DESTROY";
					
					writefln (
						"  auto %s (%s) { %s %s (cast (wl_proxy*) &this, opcode.%s, /* ret interface: */ %s, /* version: */ %s, /* flags: */ %s /* request args: */ %s%s); }", 
						req.name, req_args.join (", "), _ret, _fn, _opcode, _iface, _ver, _flags, (proxy_args.length? ", ": ""), proxy_args.join (","));
				}
			}

			// Event
			if (iface.events.length) {
				writefln ("");
				writefln ("  // Events");
				writefln ("  struct");
				writefln ("  Listener {");
				// max eve name length
				size_t max_eve_length;
				foreach (eve; iface.events) {
					auto eve_name = eve.name.to_d_name;
					max_eve_length = 
						(eve_name.length > max_eve_length)?
							eve_name.length:
							max_eve_length;
				}
				// callbacks
				foreach (eve; iface.events) {
					auto eve_name = eve.name.to_d_name;
					string _filler = " ".replicate (max_eve_length - eve_name.length);
					writefln (
						"    %s_cb%s %s%s = &_%s_impl_default;", 
						eve_name, _filler,eve_name, _filler, eve_name);
				}
				writefln ("");
				// alias
				foreach (eve; iface.events) {
					auto     eve_name = eve.name.to_d_name;
					string  _filler = " ".replicate (max_eve_length - eve_name.length);
					string[] eve_args;
					foreach (arg; eve.args) {
						eve_args ~= format!
							"%s %s" 
							(arg.type.to_d_type (arg), arg.name.to_d_name);
					}
					writefln (
						"    alias %s_cb%s = extern (C) void function (void* ctx, %s* _this /* args: */ %s%s);", 
						eve_name, _filler, iface_name, (eve_args.length? ", ": ""), eve_args.join (", "));
				}
				// impl default
				foreach (eve; iface.events) {
					auto     eve_name = eve.name.to_d_name;
					string[] eve_args;
					foreach (arg; eve.args) {
						eve_args ~= format!
							"%s %s" 
							(arg.type.to_d_type (arg), arg.name.to_d_name);
					}
					writefln ("");
					writefln ("    extern (C)");
					writefln ("    static");
					writefln ("    void");
					writefln ("    _%s_impl_default (void* ctx, %s* _this /* args: */ %s%s) {", 
							eve_name, iface_name, (eve_args.length? ", ": ""), eve_args.join (", "));
					writefln ("        // ");
					writefln ("    }");
				}

				writefln ("  }"); // struct listener
			}

			// add_listener ()
			if (iface.events.length) {
				writefln ("");
				writefln ("  // Event listener");
				writefln ("  auto add_listener (Listener* impl, void* ctx) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) impl, ctx); }");
			}

			// Enum
			if (iface.enums.length) {
				writefln ("");
				writefln ("  // Enums");
				foreach (enu; iface.enums) {
					writefln ("  enum");
					writefln ("  %s_ {", enu.name.to_d_name);
					foreach (ent; enu.entries) {
						writefln ("    %s = %s,", ent.name.to_d_name, ent.value);
					}
					writefln ("  }");
				}
			}

			// Opcode
			if (iface.requests.length) {
				writefln ("");
				writefln ("  // Opcodes");
				writefln ("  enum");
				writefln ("  opcode : uint {");
				foreach (i,req; iface.requests) {
					writefln ("    %s = %d,", req.name, i);
				}
				writefln ("  }");
			}

			writefln ("}");  // struct_name
			writefln ("");

			// Interface
			if (generate_iface) {
				foreach (req; iface.requests)
				writefln ("static const wl_interface*[%d] %s_%s_requiest_interfaces = %s;", req.args.length, iface_name, req.name, req.interface_types_array);
				writefln ("static const wl_message[%d] %s_requests = [", iface.requests.length, iface_name);
				foreach (req; iface.requests)
				if (iface.name == "wl_registry" && req.name == "bind")
				writefln ("  wl_message (\"%s\", \"%s\", %s_%s_requiest_interfaces.ptr),", req.name, "usun",               iface_name, req.name);
				else
				writefln ("  wl_message (\"%s\", \"%s\", %s_%s_requiest_interfaces.ptr),", req.name, req.serialized_types, iface_name, req.name);
				writefln ("];");

				foreach (eve; iface.events)
				writefln ("static const wl_interface*[%d] %s_%s_event_interfaces = %s;", eve.args.length, iface_name, eve.name, eve.interface_types_array);
				writefln ("static const wl_message[%d] %s_events = [", iface.events.length, iface_name);
				foreach (eve; iface.events)
				writefln ("  wl_message (\"%s\", \"%s\", %s_%s_event_interfaces.ptr),", eve.name, eve.serialized_types, iface_name, eve.name);
				writefln ("];");

				writefln ("extern (C) static const wl_interface %s_interface = {", iface_name);
				writefln ("  \"%s\", %s,", iface_name, (iface.version_.length? iface.version_: "0" ));
				writefln ("  %s_requests.length, %s_requests.ptr,", iface_name, iface_name);
				writefln ("  %s_events.length,   %s_events.ptr,",   iface_name, iface_name);
				writefln ("};");
			}
			else {
				// objdump -T  libwayland-client.so  | grep _interface			
				writefln ("// interface");
				writefln ("extern (C) extern __gshared wl_interface %s_interface;", iface_name);
				writefln ("");
			}
		}
	}
}

string
to_d_name (string a) {
	static string[string] reserved = [
		"interface" : "interface_",
		"version"   : "version_",
		"default"   : "default_",
	];

	if (a.startsWith ("0") || 
	    a.startsWith ("1") || 
	    a.startsWith ("2") || 
	    a.startsWith ("3") || 
	    a.startsWith ("4") || 
	    a.startsWith ("5") || 
	    a.startsWith ("6") || 
	    a.startsWith ("7") || 
	    a.startsWith ("8") || 
	    a.startsWith ("9")  
	)
		a = "_" ~ a;

	return reserved.get (a, a);
}

string
to_d_type (string a, Arg arg) {
	static string[string] reserved = [
		// xml     D
		"new_id" : "new_id",
		"object" : "void*",
		"fd"     : "int",
		"fixed"  : "wl_fixed_t",  // int
		"array"  : "wl_array*",
		"string" : "const(char)*",
	];

	auto t = reserved.get (a, a);

	if (t == "new_id") {
		if (arg.interface_.length)
			t = arg.interface_;  // wl_surface
		else
			t = "wl_proxy";
	}

	if (a == "object") {
		if (arg.interface_.length)
			t = arg.interface_~"*";  // wl_surface
	}
	
	return t;
}

auto
serialized_types (T) (T request) {
	string[string] types = [
		"int"    : "i",
		"uint"   : "u",
		"fixed"  : "f",
		"string" : "s",
		"object" : "o",
		"new_id" : "n",
		"array"  : "a",
		"fd"     : "h",
		//"following argument (o or s) is nullable" : "?",
		//1234567890 - version
	];

	// 1?i
	//   1 - version
	//   ? - nullable
	//   i - type
	auto version_ = request.since;
	string s = ((version_.length && version_ != "1") ? version_: "");

	// o
	//   o_interface
	// { "bar", "2u?o", [NULL, &wl_baz_interface] }

	foreach (a; request.args)
		s ~= (a.allow_null? "?": "") ~ types.get (a.type,"");

	return s;
}

auto
interface_types_array (T) (T request) {
	// new_id, interface
	string[] ifaces;
	foreach (a; request.args)
		if (a.interface_.length)
			ifaces ~= format!"&%s_interface" (a.interface_);
		else
			ifaces ~= "null";

	return format!"[%s]" (ifaces.join (","));
}

struct
Writer {
	Protocol protocol;

	void
	write () {
		writefln ("%s", protocol.name);
		foreach (iface; protocol.interfaces) {
			writefln ("  %s", iface.name);
			foreach (req; iface.requests) {
				writefln ("    %s", req.name);
			}
			foreach (eve; iface.events) {
				writefln ("    %s", eve.name);
			}
			foreach (enu; iface.enums) {
				writefln ("    %s", enu.name);
			}
		}
	}
}

auto
_Protocol (XML) (XML root) {
	alias T = Protocol;
	T _this;

	foreach (c; root.children) {  // Description,Request,Event,Enum
	 	if (c.type == EntityType.comment) {} else
 		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
	 	switch (c.name) {
	 		case "interface" : _this.interfaces ~= _Interface (c); break;
	 		case "copyright" : _this.copyright   = c.children[0].text; break;
	 		default			  : writefln ("UNSUPPORTED: %s", c.name);
	 	}

		// name,version
		foreach (a; root.attributes) {
			//static foreach (m;__traits (allMembers,T)) {
			//	static if ( is (typeof(__traits (getMember,T,m) ) == string) ) {
			//		// string -> attr
			//		if (__traits (getMember,_this,m) == a.name) {
			//			__traits (getMember,_this,m) = a.value;
			//		}
			//	}
			//}
			switch (a.name) {
		 		case "name"    : _this.name = a.value; break;
		 		default			: writefln ("UNSUPPORTED attr: %s", a.name);
		 	}
		}
	}

	return _this;
}

auto
_Interface (XML) (XML root) {
	alias T = Interface;
	T _this;

	foreach (c; root.children) {  // Description,Request,Event,Enum
	 	if (c.type == EntityType.comment) {} else
 		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
	 	switch (c.name) {
	 		case "description" : _this.description  = _Description (c) ; break;
	 		case "request" 	 : _this.requests 	~= _Request (c) ; break;
	 		case "event" 	 	 : _this.events    	~= _Event (c) ; break;
	 		case "enum" 	 	 : _this.enums    	~= _Enum (c) ; break;
	 		default			    : writefln ("UNSUPPORTED: %s", c.name);
	 	}

		// name,version
		foreach (a; root.attributes) {
			//static foreach (m;__traits (allMembers,T)) {
			//	static if ( is (typeof(__traits (getMember,T,m) ) == string) ) {
			//		// string -> attr
			//		if (__traits (getMember,_this,m) == a.name) {
			//			__traits (getMember,_this,m) = a.value;
			//		}
			//	}
			//}
			switch (a.name) {
		 		case "name"    : _this.name 		= a.value; break;
		 		case "version" : _this.version_ 	= a.value; break;
		 		default			: writefln ("UNSUPPORTED attr: %s", a.name);
		 	}
		}
	}

	return _this;
}

auto
_Request (XML) (XML root) {
	alias T = Request;
	T _this;

	foreach (c; root.children) {  // Arg
	 	if (c.type == EntityType.comment) {} else
 		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
	 	switch (c.name) {
	 		case "description" : _this.description  = _Description (c) ; break;
	 		case "arg" 			 : _this.args 		   ~= _Arg (c); break;
	 		default	  			 : writefln ("UNSUPPORTED: %s", c.name);
	 	}

		// name,version
		foreach (a; root.attributes) {
			switch (a.name) {
		 		case "name"    : _this.name 		= a.value; break;
		 		case "since"   : _this.since   	= a.value; break;
		 		case "type"    : _this.type   	= a.value; break;
		 		default			: writefln ("UNSUPPORTED attr: %s", a.name);
		 	}
		}
	}

	return _this;
}

auto
_Event (XML) (XML root) {
	alias T = Event;
	T _this;

	foreach (c; root.children) {  // Arg
	 	if (c.type == EntityType.comment) {} else
 		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
	 	switch (c.name) {
	 		case "description" : _this.description  = _Description (c) ; break;
	 		case "arg" 			 : _this.args 		   ~= _Arg (c); break;
	 		default	  			 : writefln ("UNSUPPORTED: %s", c.name);
	 	}

		// name,version
		foreach (a; root.attributes) {
			switch (a.name) {
		 		case "name"             : _this.name 				 = a.value; break;
		 		case "since"            : _this.since   			 = a.value; break;
		 		case "deprecated-since" : _this.deprecated_since = a.value; break;
		 		case "type"             : _this.type   			 = a.value; break;
		 		default			         : writefln ("UNSUPPORTED attr: %s", a.name);
		 	}
		}
	}

	return _this;
}

auto
_Arg (XML) (XML root) {
	alias T = Arg;
	T _this;

	// name,version
	foreach (a; root.attributes) {
		switch (a.name) {
	 		case "summary"    : _this.summary  	 = a.value; break;
	 		case "name"       : _this.name 	     = a.value; break;
	 		case "type"       : _this.type   	 = a.value; break;
	 		case "interface"  : _this.interface_ = a.value; break;
	 		case "enum"       : _this.enum_   	 = a.value; break;
	 		case "allow-null" : _this.allow_null = a.value; break;
	 		case "since"      : _this.since      = a.value; break;
	 		default			   : writefln ("UNSUPPORTED attr: %s", a.name);
	 	}
	}

	return _this;
}

auto
_Description (XML) (XML root) {
	alias T = Description;
	T _this;

	// name,version
	foreach (a; root.attributes) {
		switch (a.name) {
	 		case "summary"   : _this.summary 	= a.value; break;
	 		default			  : writefln ("UNSUPPORTED attr: %s", a.name);
	 	}
	}

	return _this;
}

auto
_Enum (XML) (XML root) {
	alias T = Enum;
	T _this;

	foreach (c; root.children) {  // Arg
	 	if (c.type == EntityType.comment) {} else
 		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
	 	switch (c.name) {
	 		case "description" : _this.description  = _Description (c) ; break;
	 		case "entry" 		 : _this.entries     ~= _Entry (c); break;
	 		default	  			 : writefln ("UNSUPPORTED: %s", c.name);
	 	}

		// name,version
		foreach (a; root.attributes) {
			switch (a.name) {
		 		case "name"     : _this.name 		= a.value; break;
		 		case "bitfield" : _this.bitfield = a.value; break;
		 		case "since"    : _this.since 	= a.value; break;
		 		default			 : writefln ("UNSUPPORTED attr: %s", a.name);
		 	}
		}
	}

	return _this;
}

auto
_Entry (XML) (XML root) {
	alias T = Entry;
	T _this;

	// name,version
	foreach (a; root.attributes) {
		switch (a.name) {
	 		case "summary"   : _this.summary 	= a.value; break;
	 		case "name"      : _this.name 	   = a.value; break;
	 		case "value"     : _this.value 	   = a.value; break;
	 		case "since"     : _this.since 	   = a.value; break;
	 		default			  : writefln ("UNSUPPORTED attr: %s", a.name);
	 	}
	}

	return _this;
}


struct
Protocol {
    string 		name;
    string      copyright;
    Interface[] interfaces;
}

struct
Interface {
    string 		name;
    string 		version_;
    Description description;
    Request[]   requests;
    Event[]     events;
    Enum[]      enums;
}

struct
Description {
    string summary;
    string text;
}

struct
Request {
    Description description;
    string 		since;
    string 		name;
    string 		type;
    Arg[] 		args;
}

struct
Event {
    Description description;
    string 		since;
    string 		name;
    string 		type;
    string 		deprecated_since;
    Arg[] 		args;
}

struct
Arg {
    string name;
    string type;
    string interface_;
    string enum_;
    string summary;
    string allow_null;
    string since;
}

struct
Enum {
	Description description;
	string  	name;
	string  	bitfield;
	string  	since;
	Entry[] 	entries;
}

struct
Entry {
	string summary;
	string name;
	string value;
	string since;
}

// wl_display

// <request name="get_registry">
//   <arg name="registry" type="new_id" interface="wl_registry"
// wl_registry* get_registry (_super);

// <event name="error">
//   <arg name="object_id" type="object" summary="object where the error occurred"/>
//   <arg name="code" type="uint" summary="error code"/>
//   <arg name="message" type="string" summary="error description"/>
// auto error (object object_id, uint code, string message);

// wl_registry

// <request name="bind">
//   <arg name="name" type="uint" summary="unique numeric name of the object"/>
//   <arg name="id" type="new_id" summary="bounded object"/>
// auto bind (uint name, new_id id);


version (NEVER):
void
_interface (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	string _version;
	foreach (a; attrs) {
		switch (a.name) {
			case "name"    : _name    = a.value; break;
			case "version" : _version = a.value ; break;
			default :
		}
	}
	writefln ("// interface %s, v%s", _name, _version);
	writefln ("struct %s;", _name);
	writefln ("");

	// 2
	foreach (c; dom.children) {
		if (c.type == EntityType.comment) {} else
		if (c.type == EntityType.elementStart)
		switch (c.name) {
			case "description" : _interface_description (c) ; break;
			case "enum"        : _interface_enum (c) ; break;
			case "event"       : _interface_event (c) ; break;
			case "request"     : _interface_request (c) ; break;
			default:
		}
	}
}

void
_interface_description (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _summary;
	foreach (a; attrs) {
		switch (a.name) {
			case "summary" : _summary = a.value; break;
			default :
		}
	}
	writefln ("// %s", _summary);
	//writefln ("%s", dom.text);
	writefln ("");    
}

void
_interface_enum (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	foreach (a; attrs) {
		switch (a.name) {
			case "name" : _name = a.value; break;
			default :
		}
	}
	writefln ("enum\n%s {", _name);
	foreach (c; dom.children) {
		if (c.type == EntityType.comment) {} else
		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
		switch (c.name) {
			case "entry" : _interface_enum_entry (c) ; break;
			default:
		}
	}
	writefln ("}");
	writefln ("");
}

void
_interface_enum_entry (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	string _value;
	foreach (a; attrs) {
		switch (a.name) {
			case "name"  : _name  = a.value; break;
			case "value" : _value = a.value; break;
			default :
		}
	}
	writefln ("  %s = %s,", _name, _value);
}

void
_interface_event (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	foreach (a; attrs) {
		switch (a.name) {
			case "name" : _name = a.value; break;
			default :
		}
	}
	writef ("void %s (", _name);
	foreach (c; dom.children) {
		if (c.type == EntityType.comment) {} else
		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
		switch (c.name) {
			case "arg" : _interface_event_arg (c) ; break;
			default:
		}
	}
	writefln (");");
	writefln ("");
}
void
_interface_event_arg (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	string _type;
	foreach (a; attrs) {
		switch (a.name) {
			case "name" : _name = a.value; break;
			case "type" : _type = a.value; break;
			default :
		}
	}

	writef ("%s %s, ", _type, _name);
}


void
_interface_request (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	foreach (a; attrs) {
		switch (a.name) {
			case "name" : _name = a.value; break;
			default :
		}
	}
	writef ("void %s (", _name);
	foreach (c; dom.children) {
		if (c.type == EntityType.comment) {} else
		if (c.type == EntityType.elementStart || c.type == EntityType.elementEmpty)
		switch (c.name) {
			case "arg" : _interface_request_arg (c) ; break;
			default:
		}
	}
	writefln (");");
	writefln ("");
}
void
_interface_request_arg (DOM) (DOM dom) {
	auto attrs = dom.attributes;
	string _name;
	string _type;
	foreach (a; attrs) {
		switch (a.name) {
			case "name" : _name = a.value; break;
			case "type" : _type = a.value; break;
			default :
		}
	}

	writef ("%s %s, ", _type, _name);
}

void
_struct_cb () {
	// struct
	// Regustry {
	//   ...* _super;
	//   alias _super this;
	//
	//   pragma (inline,true):
	printf (
		"
		extern (D) int
		%s_add_listener (%s* %s, const (%s_listener)* listener, void* ctx) {
			alias Callback = extern (C) void function ();

			return wl_proxy_add_listener (cast (wl_proxy*) %s, cast (Callback*) listener, ctx);
		}
		",
		(_wl_name, _wl_name, _wl_name, _wl_name, _wl_name)
	);
}
