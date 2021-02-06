# Constant pool entries serialization

## Structrue of serialized entry
For debug purposes, it is very convenient to have a way to represent a constant pool entry in a *human-readable form*.

However, since most of entries contain links to other entries, that link to other constants as well... It becomes tricker to handle and represent.

So, `javap` shows constants in the following form:
```java
    #1 = Methodref    #3.#13;  // java/lang/Object."<init>":()V
```
Serialized constant pool contains:
1. Number of the constant (`#1`)
2. Value of the constant  (`#3.#13`)
3. Commentary, if needed  (`// bla-bla-blah`)

Note, that only constants that contain references to another constants require a commentary:
```java
    // No reference - no commentary
    #4 = Utf8     java/lang/Object;

    // Reference - commentary!
    #2 = Class    #4                  // java/lang/Object
```

## Algorythm of structure serialization
Since algorythm of constant serialization is quite complicated, it requires explanation.

Let's have a look at the typical constant!
```java
(1)   (2)     (3)   (4)    (5)          (6)
#2 = Class          #4             // java/lang/Object
```
| I    | Element name          | Commentary                           |
| :--- | :-------------------- | :----------------------------------- |
| 1    | Index of the constant |                                      |
| 2    | Type of the constant  |                                      |
| 3    | Spacing after type    | Calculated as `20 - 'typeLength'`    |
| 4    | Content               |                                      |
| 5    | Spacing after content | Calculated as `16 - 'contentLength'` |
| 6    | Commentary            |                                      |