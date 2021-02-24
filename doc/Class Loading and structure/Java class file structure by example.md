# Java class file structure by example
As you already know from [Class File Format](Class%20File%20Format.md) document, Java classes have a relatively complex structure. And the best way to study it - compile something and see these beatiful files in the wild!

For such a purpose, you can use `javac` and `javad` command line tools - official compiler and disassembler, that are included into every Java Development Kit.

However, there is a much more convinient method - [javap.yawk.at](https://javap.yawk.at) website!

It lets you to both compile and disassemble your Java code in one click!

For the beginning, let's compile a simple class.

Something like **this**:
```java
class SimplestClass {}
```
<details>
  <summary>Disassembler output</summary>


	Classfile /tmp/1059625032030680147/classes/SimplestClass.class
		Last modified Aug 7, 2020; size 237 bytes
	  	SHA-256 checksum <>
		Compiled from "SimplestClass.java"
	class SimplestClass
		minor version: 0
		major version: 58
		flags: (0x0020) ACC_SUPER
		this_class: #7                          // SimplestClass
		super_class: #2                         // java/lang/Object
		interfaces: 0, fields: 0, methods: 1, attributes: 1

	Constant pool:
	   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
	   #2 = Class              #4             // java/lang/Object
	   #3 = NameAndType        #5:#6          // "<init>":()V
	   #4 = Utf8               java/lang/Object
	   #5 = Utf8               <init>
	   #6 = Utf8               ()V
	   #7 = Class              #8             // SimplestClass
	   #8 = Utf8               SimplestClass
	   #9 = Utf8               Code
	  #10 = Utf8               LineNumberTable
	  #11 = Utf8               LocalVariableTable
	  #12 = Utf8               this
	  #13 = Utf8               LSimplestClass;
	  #14 = Utf8               SourceFile
	  #15 = Utf8               SimplestClass.java

	{
	  SimplestClass();
	    descriptor: ()V
	    flags: (0x0000)

	    Code:

	      stack=1, locals=1, args_size=1
	        start local 0           s// SimplestClass this
	         0: aload_0
	         1: invokespecial #1    // Method java/lang/Object."<init>":()V
	         4: return
	        end local 0 // SimplestClass this

	      LineNumberTable:

	      LocalVariableTable:

	        Start  Length  Slot  Name   Signature
	            0       5     0  this   LSimplestClass;

	}
	SourceFile: "SimplestClass.java"
</details>

Okay, hold on. We have compiled the simplest class we could have, right? Where all of this code came from?

Well, if you are familiar with Java, you surely know, that Java compilers actually add something to your code. Things like default constructor, implicit inheritance from `java.lang.Object`...

Long story short, that's how our class *actually* looks after compilation:

```java
class SimplestClass extends java.lang.Object {
    public void <init> { // That's our default constructor
        java.lang.Object.<init>(); // Calling a constructor from Object
        return;
    }
}
```

Obviously, this code won't compile! But that's how our class really looks under the hood.

That explains everything. But let's dive into each line of decomiler's output and see what it really does!
## `javap` output teardown

`javap` output starts with some information about class file - creation date, size, etc. :
```java
Classfile /tmp/1059625032030680147/classes/SimplestClass.class
	Last modified Aug 7, 2020; size 237 bytes
  	SHA-256 checksum <>
	Compiled from "SimplestClass.java"
```

After that, the class file name goes:
```java
class SimplestClass
```

And the major and minor versions of the JDK that compiled the file. Looking up the version of the Java in the special [table](/doc/Reference/Java%20major%20versions.md), we gain a resulting version of Java - **15**!
```java
minor version: 0
major version: 59
```

Class flags:
```java
flags: (0x0020) ACC_SUPER
```