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

<img src="../Diagrams/Class%20Loading%20and%20structure/Class%20File%20Structure.drawio.svg" alt="drawing" width="100%"/>

Still complicated, of course. But at least it is much more convenient to work with, right?
## Detailed fields description
Let's start describing each field, one by one:

<p>
<img align="right" src="../Diagrams/Class%20Loading%20and%20structure/Magic%20Value.png" alt="drawing" width="100"/>

### Magic value
Each `.class` value starts with special 'magic value' - a sequence of 4 bytes, that all Java class start with. It's value is 0xCAFEBABE 
</p>