# Changelogs and to-do lists
## Version 0.2
In this pre-release I plan to implement readings of the constant pool and expand documentation 
### Class loading:
- [ ] **Implemented class loading features**
  - [x] Constant pool readings
  - [ ] Current and super classes names
### Tools
- [ ] Class decompiler (javocp)
  - [ ] Constant pool and class name
### Documentation
- [ ] Class Loading algorithm:
  - [ ] Constant pool loading procedure
  - [ ] Descriptors
- [ ] Expand "Class File Format"
  - [ ] 'Magic Value'
  - [ ] Versions
  - [ ] Constant pool
- [ ] Expand "Class structure by example"
  - [ ] 'Magic value'
  - [ ] Versions
  - [ ] Constant pool

## Version 0.1 - Released 07.08.2020
This is a very first version of the project.

It implements some simple parts of class loading
### Generic features
- **Debug library**
  - Simple `print` function for debugging
### Class loading:
- **Class loading module structure**
  - Class loader file (classLoader.lua) - *responsible for all the class* *loading procedure logic in the bootstrap class loader*
- **Implemented class loading features**
  - Magic value
  - Versions *(Major and Minor)*
### Tools
- **Added new tool**
  - Class decompiler (javocp)
    - View versions
### Documentation
- Documentation framework *(.md files structure, etc.)*
- Project's motivation and abstract
- Class Loading algorithm:
  - Basics of the class file structure
  - Steps for class loading 