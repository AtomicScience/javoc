# Java class file structure by example
As you already know from "Class File Format" document, Java classes have a relatively complex structure. And the best way to study it - compile something and see these beatiful files in the wild!

For such a purpose, you can use `javac` and `javad` command line tools - official compiler and disassembler, that are included into every Java Development Kit.

However, there is a much more convinient method - [javap.yawk.at](https://javap.yawk.at) website!

It lets you to both compile and disassemble your Java code in one click!

For the beginning, let's compile a simple class.

Something like **this**:
```java
class Main {}
```
<details>
  <summary>Disassembler output</summary>


	Classfile /tmp/1059625032030680147/classes/Main.class
		Last modified Aug 7, 2020; size 237 bytes
	  	SHA-256 checksum <>
		Compiled from "Main.java"
	class Main
		minor version: 0
		major version: 58
		flags: (0x0020) ACC_SUPER
		this_class: #7                          // Main
		super_class: #2                         // java/lang/Object
		interfaces: 0, fields: 0, methods: 1, attributes: 1

	Constant pool:
	   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
	   #2 = Class              #4             // java/lang/Object
	   #3 = NameAndType        #5:#6          // "<init>":()V
	   #4 = Utf8               java/lang/Object
	   #5 = Utf8               <init>
	   #6 = Utf8               ()V
	   #7 = Class              #8             // Main
	   #8 = Utf8               Main
	   #9 = Utf8               Code
	  #10 = Utf8               LineNumberTable
	  #11 = Utf8               LocalVariableTable
	  #12 = Utf8               this
	  #13 = Utf8               LMain;
	  #14 = Utf8               SourceFile
	  #15 = Utf8               Main.java

	{
	  Main();
	    descriptor: ()V
	    flags: (0x0000)

	    Code:

	      stack=1, locals=1, args_size=1
	        start local 0           s// Main this
	         0: aload_0
	         1: invokespecial #1    // Method java/lang/Object."<init>":()V
	         4: return
	        end local 0 // Main this

	      LineNumberTable:

	      LocalVariableTable:

	        Start  Length  Slot  Name   Signature
	            0       5     0  this   LMain;

	}
	SourceFile: "Main.java"

</details>