import std.stdio;
import std.file;
import std.string;
import std.conv;
import dxml.dom;
import std.range : empty;
import std.algorithm.searching : canFind;

void 
main () {
	// READ-WRITE
	foreach (protocol; Reader ("wayland.xml"))
		D_File_Writer (protocol).write ();
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

	void
	write () {
		// alias wl_id = wl_proxy;

		// Protocol
		auto protocol_name = protocol.name;
		writefln ("// protocol %s", protocol_name);
		writefln ("module wayland_struct.protocol;");
		writefln ("");
		writefln ("import wayland_struct.proxy : wl_proxy;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal_constructor;");
		writefln ("import wayland_struct.proxy : wl_proxy_marshal_constructor_versioned;");
		writefln ("import wayland_struct.proxy : wl_proxy_get_version;");
		writefln ("import wayland_struct.proxy : wl_proxy_add_listener;");
		writefln ("import wayland_struct.util  : wl_proxy_callback;;");
		writefln ("import wayland_struct.util  : wl_message;");
		writefln ("import wayland_struct.util  : wl_interface;");
		writefln ("import wayland_struct.util  : wl_fixed_t;");
		writefln ("import wayland_struct.util  : wl_array;");
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
			writefln ("  @disable this();");
			writefln ("  @disable this(%s);", struct_name);
			writefln ("  @disable this(ref %s);", struct_name);

			// Request
			if (iface.requests.length) {
				writefln ("");
				writefln ("  // Requests");
				writefln ("  pragma (inline,true):");
				foreach (req; iface.requests) {
					auto ret_type  = "";  // check arg.type == "new_id" && check|get arg.interface_ 
					auto ret_name  = "";
					auto ret_iface = false;
					// new_id

					// , offset, width, height, stride, format
					string _args;

					writef   ("  auto %s (", req.name);
					size_t i;
					foreach (arg; req.args) {
						if (arg.type == "new_id") {  // ret
							ret_type  = arg.type.to_d_type (arg);
							ret_name  = arg.name.to_d_name;
							ret_iface = (arg.interface_.length)? true : false;
						}
						else {                       // arg
							auto arg_type = arg.type.to_d_type (arg);  // wl_surface* surface -> Wl_surface surface
							writef   ("%s%s %s", ((i > 0)? ", " : ""), arg_type, arg.name.to_d_name);
							_args ~= ", " ~ arg.name;
							i ++;
						}
					}
					string _ret;
					string _fn = "wl_proxy_marshal";
					string _opcode = req.name;
					string _iface;
					string _ver;
					writef   (") { ");
					if (ret_type.length) {
						if (ret_iface) {  // cast (Wl_shell_surface) cast (wl_shell_surface*))
							_ret   = format!"return cast (%s*)" (ret_type);
							_fn   ~= "_constructor";
							_iface = format!", &%s_interface" (ret_type);
						}
						else {
							_ret   = format!"return cast (%s*)" ("wl_proxy");
							_fn   ~= "_constructor";
							_iface = ", &wl_proxy_interface";
						}

						_args = ", null"~_args;
					}

					//if (req.since && req.since != "0") {
					//	_fn ~= "_versioned";
					//	_ver = format!", %s" (req.since);
					//}

					writef   (
						"%s %s (cast(wl_proxy*)&this, opcode.%s %s %s %s);", 
						_ret, _fn, _opcode, _iface, _ver, _args);

					writefln ("  }");
				}
			}

			// Event
			if (iface.events.length) {
				writefln ("");
				writefln ("  // Events");
				writefln ("  struct");
				writefln ("  Listener {");
				// callbacks
				foreach (eve; iface.events) {
					auto eve_name = eve.name;
					writefln ("    %s_cb %s;", eve_name, eve_name);
				}
				writefln ("");
				// alias
				foreach (eve; iface.events) {
					auto eve_name = eve.name;
					writef   ("    alias %s_cb = void function (", eve_name);
					writef   (     "void* data, %s* _%s", iface_name, iface_name);
					foreach (i,arg; eve.args) {
						writef   (", ");
						writef   ("%s %s", arg.type.to_d_type (arg), arg.name.to_d_name);
					}
					writefln (");");
				}
				writefln ("  }"); // struct listener
			}

			// add_listener ()
			if (iface.events.length) {
				writefln ("");
				writefln ("  // Event listener");
				writefln ("  auto add_listener (Listener* impl, void* data) { return wl_proxy_add_listener (cast(wl_proxy*)&this, cast (wl_proxy_callback*) &impl, data); }");
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
			//static const wl_message[1] _requests  = [wl_message ("bind","u",null)];
			//static const wl_message[2] _events    = [wl_message ("global","",null), wl_message ("global_remove","",null)];
			writefln ("// Interface");
			string s1; //  = "wl_message (\"bind\",\"u\",null)";
			foreach (req; iface.requests) {
				string r_types;
				foreach (arg; req.args) {
					string arg_type;
					if (arg.type == "object")
						arg_type = format!"&%s_interface" (arg.interface_);
					else
						arg_type = "null";
					r_types ~= (arg_type ~ ",");
				}
				string _types_name = format!"_%s_request_%s_types" (iface_name,req.name);
				writefln ("static const wl_interface*[%d] %s = [%s];", req.args.length, _types_name, r_types);

				//
				s1 ~= format!
					"wl_message (\"%s\",\"%s\",%s.ptr)," 
					(/* name */ req.name, /* signature */ req.args.to_iface_args (iface.version_), _types_name);
			}

			string s2; //  = "wl_message (\"global\",\"\",null), wl_message (\"global_remove\",\"\",null)";
			foreach (i,eve; iface.events) {
				string e_types;
				foreach (arg; eve.args) {
					string arg_type;
					if (arg.type == "object")
						arg_type = format!"&%s_interface" (arg.interface_);
					else
						arg_type = "null";
					e_types ~= (arg_type ~ ",");
				}
				string _types_name = format!"_%s_event_%s_types" (iface_name,eve.name);
				writefln ("static const wl_interface*[%d] %s = [%s];", eve.args.length, _types_name, e_types);

				//
				s2 ~= format!
					"wl_message (\"%s\",\"%s\",%s.ptr)," 
					(/* name */ eve.name, /* signature */ eve.args.to_iface_args (iface.version_), _types_name);
			}
			// foreach (i,eve; iface.events)
			//   static wl_interface*[N] _wl_compositor_event_ENAME_types = [];
			writefln ("static const wl_message[%d] _%s_requests  = [%s];", iface.requests.length, iface_name, s1);
			writefln ("static const wl_message[%d] _%s_events    = [%s];", iface.events.length, iface_name, s2);
			writefln ("static const wl_interface %s_interface = {", iface_name);
			writefln ("  	\"%s\", %d,", iface_name, iface.version_.to!int);
			writefln ("  	%d, _%s_requests.ptr,", iface.requests.length, iface_name);
			writefln ("  	%d, _%s_events.ptr",    iface.events.length, iface_name);
			writefln ("};");
			writefln ("");

			//writefln ("extern (C) __gshared wl_interface %s_interface;", iface_name);
			//writefln ("");
		}

		// wl_proxy interface
		writefln ("// wl_proxy interface");
		writefln ("static const wl_message[6] _wl_proxy_interface_requests  = [];");
		writefln ("static const wl_message[0] _wl_proxy_interface_events    = [];");
		writefln ("static const wl_interface wl_proxy_interface = {");
	    writefln ("    \"wl_proxy\", 1,");
	    writefln ("    0, _wl_proxy_interface_requests.ptr,");
	    writefln ("    0, _wl_proxy_interface_events.ptr");
		writefln ("};");
	
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

	if (t == "object") {
		if (arg.interface_.length)
			t = arg.interface_;  // wl_surface
	}
	
	return t;
}

string
to_iface_args (Arg[] args, string version_) {
	string s;
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

	s ~= ((version_.length && version_ != "1") ? version_: "");

	// o
	//   o_interface
	// { "bar", "2u?o", [NULL, &wl_baz_interface] }

	foreach (arg; args)
		s ~= (arg.allow_null? "?": "") ~ types.get (arg.type,"");

	return s;
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
		%s_add_listener (%s* %s, const (%s_listener)* listener, void* data) {
			alias Callback = extern (C) void function ();

			return wl_proxy_add_listener (cast (wl_proxy*) %s, cast (Callback*) listener, data);
		}
		",
		(_wl_name, _wl_name, _wl_name, _wl_name, _wl_name)
	);
}
