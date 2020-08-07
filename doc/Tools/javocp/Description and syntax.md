# javocp - Java class File Disassembler

## Syntax:
javocp [ options ] *class*

## Description
**Since: 0.1**

**javocp** is a programm, which disassembles Java .class files and outputs the result based on the options provided

**javocp** is a stripped down version of [javap](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) command

Classes' paths are calculated relative to the root directory of the project

## Options and arguments
| Argument              | Commentary                |
| --------------------- | ------------------------- |
| *class*               | Path to the class to load |
| **--help**, **-?**    | Prints the help message   |
| **--verbose**, **-v** | Prints constant pool      |
| **--debug**, **-d**   | Enables debug mode        |

## Example usage
``` cmd
JavOC/bin> javocd -v -d test/HelloWord.class
```