# iwannatouchzeta
3D printed Riemann Zeta Function "触れるゼータ関数" 

http://tsujimotter.hatenablog.com/entry/touchable-3d-zeta-function


### Requirements

```
$ ruby -v 
ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-darwin15]

$ gcc -v
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr --with-gxx-include-dir=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include/c++/4.2.1
Apple LLVM version 8.0.0 (clang-800.0.42.1)
Target: x86_64-apple-darwin15.6.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
```

### Clone this project
```
$ git clone https://github.com/junpeitsuji/iwannatouchzeta.git
$ cd iwannatouchzeta
```

### Build C++ zeta function library

```
$ cd ./cpp/
$ ruby extconf.rb
$ make
$ cd ..
```

Execute a test code.

```
$ cd testcodes
$ ruby test_cppzeta.rb
1.6448798205485344
```

zeta(2) = 1.6448798205485344...


### Execution

```
$ sh quickstart.sh
```

   or

```
$ ruby stl.rb config3d-zeta-miniedition-ruby.rb
```


After a calculation, result file will be ready (in the `result` directory (`result/zeta-miniedition.stl`)).


![Screenshot of zeta-miniedition.stl](https://raw.githubusercontent.com/junpeitsuji/iwannatouchzeta/master/screenshots/zeta-miniedition-stl.png)


Enjoy your zeta life!!



### Benchmark Tests

Zeta 観賞用 C++ (`ruby stl.rb config3d-zeta-cpp.rb`)
```
Processing time: 73.49609957399662s
```

Zeta 観賞用 C++ 2X (`ruby stl.rb config3d-zeta-cpp-2x.rb`)
```
Processing time: 292.0691345179803s
```

Zeta mini edition C++ (`ruby stl.rb config3d-zeta-miniedition-cpp.rb`)
```
Processing time: 46.85677544301143s
```

Zeta mini edition Ruby (`ruby stl.rb config3d-zeta-miniedition-ruby.rb`)
```
Processing time: 184.01656523201382s
```
