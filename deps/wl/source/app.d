import std.stdio;
import std.file;
import dxml.dom;
import std.range : empty;

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
		writefln ("// protocol %s", protocol.name);
		writefln ("");
		foreach (iface; protocol.interfaces) {
			writefln ("module %s.%s;", protocol.name, iface.name);
			writefln ("");
			writefln ("extern (C):");

			foreach (req; iface.requests) {
				writef   ("auto %s (", req.name);
				foreach (arg; req.args) {
					writef   ("%s %s,", arg.type, arg.name);
				}
				writefln (");");
			}
			writefln ("");

			foreach (eve; iface.events) {
				writef   ("auto %s (", eve.name);
				foreach (arg; eve.args) {
					writef   ("%s %s,", arg.type, arg.name);
				}
				writefln (");");
			}

			foreach (enu; iface.enums) {
				writefln ("enum %s (", enu.name);
				foreach (ent; enu.entries) {
					writefln ("  %s = %s,", ent.name, ent.value);
				}
				writefln ("}");
			}

			writefln ("");
		}
	}
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
	 		case "name"       : _this.name 	    = a.value; break;
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

