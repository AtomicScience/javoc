# Java class file structure by example
As you already know from "Class File Format" document, `.class` file has a relatively complex structure. And the best way to study it - compile something and see it at practice!

For such a purpose, you can use `javac` and `javad` command line tools - official compiler and disassembler, that are included into every Java Development Kit.

However, there is a much more convinient method - javap.yawk.at website!

It lets you to both compile and disassemble your Java code in one click!

For the beginning, let's compile something simple. I mean, *very* simple.

Something like this:
```java
public class Main {
   	public Main() {
		   
   	}
}
```
<details>
  <summary>Disassembler output</summary>
  
  Spoiler text. Note that it's important to have a space after the summary tag. You should be able to write any markdown you want inside the `<details>` tag... just make sure you close `<details>` afterward.
  
  ```javascript
  console.log("I'm a code block!");
  ```
  
</details>