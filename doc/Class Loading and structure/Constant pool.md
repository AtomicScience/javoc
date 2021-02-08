# Constant pool
## Purpose of constant pool
Bytecode uses data very often, and something like string literals cannot be stored into code, but instead it should be kept *somewhere* to be later referenced by bytecode:

```java
    new #2 		    // Class java/lang/Object
```

This data will never change during runtime, thus making these values **constants**! And these values are stored in a special structure called **constant pool**

## Structrue of constant pool
That's how it looks:

<img src="../Diagrams/Class%20Loading%20and%20structure/Constant%20Pool.png" alt="drawing" width="90%"/>

The very first field of it is a `Constant pool size` - a field that, suddenly, defines the size of the constant pool, but, for some mysterious reason, it's actually *greater* than amount of constants by 1 *(So that if `constant pool size` has a value of 5, there are actually only 4 constants in the pool)*

As you can see, the actual length of the constant pool is unknown *(marked as X)*. That's because each constant entry has its own length - for example, `Utf8` constant may be 20 bytes long, or 200 bytes - we won't know it until we start reading constant pool values, one by one.

## Constant in constant pool
There are actually many different constants that define different things - from float and double variables to method and class signatures.

In Java 6, that JavOC implements, there are 11 different constants, that I'm too lazy to describe, so you better look them up in official documentation:
[Here it goes](https://docs.oracle.com/javase/specs/jvms/se6/html/ClassFile.doc.html#20080)