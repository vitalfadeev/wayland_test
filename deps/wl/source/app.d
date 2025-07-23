import std.stdio;
import std.file;
import dxml.dom;
import std.range : empty;

void 
main () {
	auto xml = "<!-- comment -->\n" ~
	           "<root>\n" ~
	           "    <foo>some text<whatever/></foo>\n" ~
	           "    <bar/>\n" ~
	           "    <baz></baz>\n" ~
	           "</root>";

//   xml = readText ("gtk-shell.xml");
   xml = readText ("wayland.xml");

	{
	    auto dom = parseDOM (xml);
	    auto root = dom.children[0];

	    writefln ("// %s;", root.name);

	    // 1
	    foreach (c; root.children) {
	    	if (c.type == EntityType.comment) {} else
	    	if (c.type == EntityType.elementStart)
	    	switch (c.name) {
	    		case "interface" : _interface (c) ; break;
	    		default:
	    	}
	    }
	}

version (NEVER) {
	{
	    auto foo = root.children[0];
	    assert(foo.type == EntityType.elementStart);
	    assert(foo.name == "foo");
	    assert(foo.children.length == 2);

	    assert(foo.children[0].type == EntityType.text);
	    assert(foo.children[0].text == "some text");

	    assert(foo.children[1].type == EntityType.elementEmpty);
	    assert(foo.children[1].name == "whatever");

	    assert(root.children[1].type == EntityType.elementEmpty);
	    assert(root.children[1].name == "bar");

	    assert(root.children[2].type == EntityType.elementStart);
	    assert(root.children[2].name == "baz");
	    assert(root.children[2].children.length == 0);
	}
	{
	    auto dom = parseDOM!simpleXML(xml);
	    assert(dom.type == EntityType.elementStart);
	    assert(dom.name.empty);
	    assert(dom.children.length == 1);

	    auto root = dom.children[0];
	    assert(root.type == EntityType.elementStart);
	    assert(root.name == "root");
	    assert(root.children.length == 3);

	    auto foo = root.children[0];
	    assert(foo.type == EntityType.elementStart);
	    assert(foo.name == "foo");
	    assert(foo.children.length == 2);

	    assert(foo.children[0].type == EntityType.text);
	    assert(foo.children[0].text == "some text");

	    assert(foo.children[1].type == EntityType.elementStart);
	    assert(foo.children[1].name == "whatever");
	    assert(foo.children[1].children.length == 0);

	    assert(root.children[1].type == EntityType.elementStart);
	    assert(root.children[1].name == "bar");
	    assert(root.children[1].children.length == 0);

	    assert(root.children[2].type == EntityType.elementStart);
	    assert(root.children[2].name == "baz");
	    assert(root.children[2].children.length == 0);
	}
}
}

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

