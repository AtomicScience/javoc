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

<details style="background-color:#F6F6F6">
<p style="background-color:#F6F6F6">
<summary>Diagram</summary>
<img style="background-color:#F6F6F6" src="../Diagrams/Class%20Loading%20and%20structure/Class%20File%20Structure.drawio.svg" width="100%"/>
</p>
</details>

Still complicated, of course. But at least it is much more convenient to work with, right?
## Detailed fields description
Let's start describing each field, one by one:

<p>
<img align="right" src="../Diagrams/Class%20Loading%20and%20structure/Magic%20Value.png" alt="drawing" width="100"/>

### Magic value
Each `.class` value starts with special 'magic value' - a sequence of 4 bytes, that all Java class start with. Its value is 0xCAFEBABE 
</p>

### Minor and major versions
<img align="right" src="../Diagrams/Class%20Loading%20and%20structure/Versions.png" alt="drawing" width="200"/>
Each class was compiled to be used with a specific version of Java. It was quite complex back in old versions of Java, but today everything is pretty straightforward - JVM can run classes of its version and classes with <em>older</em> versions. In other words, JVMs are <b>backwards compatible</b>

To store version of the Java that compiled the file, Major and Minor fields exist

Each major release of Java is assigned to its *major version*. For example, Java 6, that JavOC is intended to implement, has major version of `50`.

Minor version, however, is just a legacy field, that does not mean anything -  any JVM should be able to run any minor version, if it supports the major. For example, Java 6 should be able to run `50.0`, `50.1`, `50.255` or any other. 

Modern compilers set this field to 0

### Constant pool

<img align="right" src="../Diagrams/Class%20Loading%20and%20structure/Constant%20Pool.png" alt="drawing" width="400"/>
This data structure is very complex, so there is a dedicated article about it: 

[Constant Pool](Constant%20pool.md)
