# Class file format
In Java, programs are composed of classes. Each class *(after compilation)* is stored in single file with `.class` extension

According to the [official JVM Specifications](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-4.html), class file is encoded in a binary form and has the following structure:

	ClassFile {
	    u4             magic;
	    u2             minor_version;
	    u2             major_version;
	    u2             constant_pool_count;
	    cp_info        constant_pool[constant_pool_count-1];
	    u2             access_flags;
	    u2             this_class;
	    u2             super_class;
	    u2             interfaces_count;
	    u2             interfaces[interfaces_count];
	    u2             fields_count;
	    field_info     fields[fields_count];
	    u2             methods_count;
	    method_info    methods[methods_count];
	    u2             attributes_count;
    	attribute_info attributes[attributes_count];
	}

Looks complicated... But here is the pretty diagram, that explains everything!

![image](/doc/Diagrams/Class%20File%20Structure.drawio.svg)

Still complicated... But at least it is more clear now!

Let's start describing each field, one by one:

<details>
<summary>Magic Value</summary>

Each `.class` value starts with special 'magic value'
</details>