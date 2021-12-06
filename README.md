# MTAImports
A single-file resource to provide functionallity same as require for multi theft auto

## Tips of usage
+ Avoid importing a resource multiple times in your project (import once and it will be available all the time)
+ you can use space names or namespaces for better code readabilty


### How to use?
Use this code in of your files
```lua
loadstring(exports["MTAImports"]:import("DemoResource"))()
```

This resource works on both server and client sides.
if you found a bug or issue, use issues section on repositoy

## `import` function syntax
We have a reosurce called `DemoResource` and it has 1 exported function named `DoSomething`

these are the cases we can use:
```lua
loadstring(exports["MTAImports"]:import("DemoResource"))
-- Usage:
DoSomething()
```

```lua
loadstring(exports["MTAImports"]:import("DemoResource", true))
-- Usage:
DemoResource.DoSomething()
```

```lua
loadstring(exports["MTAImports"]:import("DemoResource", true, "MySpace"))
-- Usage:
MySpace.DoSomething()
```
