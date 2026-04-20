---
title: "Python Uncompyle6 反编译工具使用 与 Magic Number 详解"
date: 2025-09-04 18:39:00
disableNunjucks: true
---
# Python Uncompyle6 反编译工具使用 与 Magic Number 详解

---

>   最近在 i 春秋刷 MISC 题的时候，做到了好几道有`pyc`​文件需要反编译的题，也了解到了一个非常神的 Python 反编译工具——`Python Uncompyle6`​。虽然只用到了其中的一个功能，但它留给我的印象却十分友善。通过命令行调用，较为方便；支持 Python 编译器版本丰富，几乎涵盖了所有版本；最主要的优点是：不会卡 Bug。（与`Pycdc`​相比友善很多 ~~（可能只是我技术比较菜）~~ ）。
>   另外，在部分题目中，使用`pyinstaller`​导出的`pyc`​文件会将文件的`Magic Number`​和时间戳信息抹去，反编译时工具会报错，我们需要手动添加`Magic Number`​与时间戳，时间戳可以随便添加（全 0 也可以），但是每个版本 Python 编译的`pyc`​文件`Magic Number`​ 都不同，需要我们手动查找与填充，下面将介绍一个方便获取`Magic Number`​的方法（网上有关`Magic Number`​对照的信息太少了）

### Uncompyle6 介绍

  `Uncompyle6`​，是一个 Python **原生**的跨版本反编译器，是`decompyle`​, `uncompyle`​, `uncompyle2`​的后继版本。
  `Uncompyle6`​能够将 Python 二进制文件`pyc`​, `pyo`​反编译为对应的源代码。支持 Python 1.0-3.8 版本的反编译，拥有较好的逻辑处理和解析能力。

### Uncompyle6 安装与使用

安装不用多说，上`pip`​完事

```
pip install uncompyle6

```

使用也非常简单，在命令行中，`uncompyle6`​加上需要反编译的文件参数即可，注意使用`-o`​ 选项输出到文件中

```
uncompyle6 -o test.txt test.pyc

```

这会将`test.pyc`​文件反编译，并输出到`test.txt`​文件中

**注：如果遇到错误，可能因为**​**​`pyc`​**​**文件生成时，头部的**​**​`magic number`​**​**被清理，需要另外补上，请看下一节内容**

### Magic Number in Python

> 一开始，因为不知道版本号对应的`Magic Number`​，我以前将一些版本的 Python 环境下载，再编译，逐个对照，现在想来，笨办法实锤。

#### Magic Number

通过一个开源的 Python 虚拟机解包工具`Pyinstxtractor`​的源码中关于`Magic Number`​的内容，似乎找到了一点头绪。

![](https://i-blog.csdnimg.cn/blog_migrate/ccd1625c644e52756d41f28d9c3e08aa.png#pic_center)

​`Magic Number`​的生成和其他操作，似乎在`importlib`​库中的`util`​文件中，查看一下`util`​文件

![](https://i-blog.csdnimg.cn/blog_migrate/59b858f5973c40dbec040ae1f1946be1.png#pic_center)

发现又是从`.bootstrap_external`​中引用的，再跳一次

![](https://i-blog.csdnimg.cn/blog_migrate/48be52ef337f959402b1a57d25d05b3e.png#pic_center)

*一些 Magic Number 的介绍注释*

![](https://i-blog.csdnimg.cn/blog_migrate/cf8bd3daa22a10c49787d288c9597c96.png#pic_center)

*Magic Number 已知列表，在文末附上*

接下来就算找到了`Magic Number`​的版本对照表。但是，我们知道的`Magic Number`​是四字节二进制数据，应该如何转换？再往下找，在注释后面的代码里，我们找到了样例

```
MAGIC_NUMBER = (3413).to_bytes(2, 'little') + b'\r\n'
_RAW_MAGIC_NUMBER = int.from_bytes(MAGIC_NUMBER, 'little')  # For import.c

```

这里的`3413`​就是`Python 3.8b4`​版本的`Magic Number`​，执行一下，就得到了四字节的二进制码`0x0A0D0D55`​。其他版本的对应二进制码，可以按照上面步骤计算得到。
**注意：四字节的 Magic Number 为小端序，注意区分**

#### Pyc 文件修复

我们已经得到了 Magic Number 的二进制码，下面就可以修复`pyc`​文件了

再次用到`pyinstxtractor`​源码，找到输出`pyc`​文件部分

![](https://i-blog.csdnimg.cn/blog_migrate/24516214e790136b8c0ad7453b35251c.png#pic_center)

* 在 Python3.7 及以上版本的编译后二进制文件中，头部除了四字节`Magic Number`​，**还有四个字节的空位和八个字节的时间戳 + 大小信息**，后者对文件反编译没有影响，全部填充 0 即可；
* Python3.3 - Python3.7（包含 3.3）版本中，只需要`Magic Number`​和八位时间戳 + 大小信息
* Python3.3 以下的版本中，只有`Magic Number`​和四位时间戳

用`Winhex`​修复文件，在头部写入（非覆盖）上述格式的内容，就可以进行反编译了

### 附录 Magic Number 对照表

```
Known values:
#  Python 1.5:   20121
#  Python 1.5.1: 20121
#     Python 1.5.2: 20121
#     Python 1.6:   50428
#     Python 2.0:   50823
#     Python 2.0.1: 50823
#     Python 2.1:   60202
#     Python 2.1.1: 60202
#     Python 2.1.2: 60202
#     Python 2.2:   60717
#     Python 2.3a0: 62011
#     Python 2.3a0: 62021
#     Python 2.3a0: 62011 (!)
#     Python 2.4a0: 62041
#     Python 2.4a3: 62051
#     Python 2.4b1: 62061
#     Python 2.5a0: 62071
#     Python 2.5a0: 62081 (ast-branch)
#     Python 2.5a0: 62091 (with)
#     Python 2.5a0: 62092 (changed WITH_CLEANUP opcode)
#     Python 2.5b3: 62101 (fix wrong code: for x, in ...)
#     Python 2.5b3: 62111 (fix wrong code: x += yield)
#     Python 2.5c1: 62121 (fix wrong lnotab with for loops and
#                          storing constants that should have been removed)
#     Python 2.5c2: 62131 (fix wrong code: for x, in ... in listcomp/genexp)
#     Python 2.6a0: 62151 (peephole optimizations and STORE_MAP opcode)
#     Python 2.6a1: 62161 (WITH_CLEANUP optimization)
#     Python 2.7a0: 62171 (optimize list comprehensions/change LIST_APPEND)
#     Python 2.7a0: 62181 (optimize conditional branches:
#                          introduce POP_JUMP_IF_FALSE and POP_JUMP_IF_TRUE)
#     Python 2.7a0  62191 (introduce SETUP_WITH)
#     Python 2.7a0  62201 (introduce BUILD_SET)
#     Python 2.7a0  62211 (introduce MAP_ADD and SET_ADD)
#     Python 3000:   3000
#                    3010 (removed UNARY_CONVERT)
#                    3020 (added BUILD_SET)
#                    3030 (added keyword-only parameters)
#                    3040 (added signature annotations)
#                    3050 (print becomes a function)
#                    3060 (PEP 3115 metaclass syntax)
#                    3061 (string literals become unicode)
#                    3071 (PEP 3109 raise changes)
#                    3081 (PEP 3137 make __file__ and __name__ unicode)
#                    3091 (kill str8 interning)
#                    3101 (merge from 2.6a0, see 62151)
#                    3103 (__file__ points to source file)
#     Python 3.0a4: 3111 (WITH_CLEANUP optimization).
#     Python 3.0b1: 3131 (lexical exception stacking, including POP_EXCEPT
                          #3021)
#     Python 3.1a1: 3141 (optimize list, set and dict comprehensions:
#                         change LIST_APPEND and SET_ADD, add MAP_ADD #2183)
#     Python 3.1a1: 3151 (optimize conditional branches:
#                         introduce POP_JUMP_IF_FALSE and POP_JUMP_IF_TRUE
                          #4715)
#     Python 3.2a1: 3160 (add SETUP_WITH #6101)
#                   tag: cpython-32
#     Python 3.2a2: 3170 (add DUP_TOP_TWO, remove DUP_TOPX and ROT_FOUR #9225)
#                   tag: cpython-32
#     Python 3.2a3  3180 (add DELETE_DEREF #4617)
#     Python 3.3a1  3190 (__class__ super closure changed)
#     Python 3.3a1  3200 (PEP 3155 __qualname__ added #13448)
#     Python 3.3a1  3210 (added size modulo 2**32 to the pyc header #13645)
#     Python 3.3a2  3220 (changed PEP 380 implementation #14230)
#     Python 3.3a4  3230 (revert changes to implicit __class__ closure #14857)
#     Python 3.4a1  3250 (evaluate positional default arguments before
#                        keyword-only defaults #16967)
#     Python 3.4a1  3260 (add LOAD_CLASSDEREF; allow locals of class to override
#                        free vars #17853)
#     Python 3.4a1  3270 (various tweaks to the __class__ closure #12370)
#     Python 3.4a1  3280 (remove implicit class argument)
#     Python 3.4a4  3290 (changes to __qualname__ computation #19301)
#     Python 3.4a4  3300 (more changes to __qualname__ computation #19301)
#     Python 3.4rc2 3310 (alter __qualname__ computation #20625)
#     Python 3.5a1  3320 (PEP 465: Matrix multiplication operator #21176)
#     Python 3.5b1  3330 (PEP 448: Additional Unpacking Generalizations #2292)
#     Python 3.5b2  3340 (fix dictionary display evaluation order #11205)
#     Python 3.5b3  3350 (add GET_YIELD_FROM_ITER opcode #24400)
#     Python 3.5.2  3351 (fix BUILD_MAP_UNPACK_WITH_CALL opcode #27286)
#     Python 3.6a0  3360 (add FORMAT_VALUE opcode #25483)
#     Python 3.6a1  3361 (lineno delta of code.co_lnotab becomes signed #26107)
#     Python 3.6a2  3370 (16 bit wordcode #26647)
#     Python 3.6a2  3371 (add BUILD_CONST_KEY_MAP opcode #27140)
#     Python 3.6a2  3372 (MAKE_FUNCTION simplification, remove MAKE_CLOSURE
#                         #27095)
#     Python 3.6b1  3373 (add BUILD_STRING opcode #27078)
#     Python 3.6b1  3375 (add SETUP_ANNOTATIONS and STORE_ANNOTATION opcodes
#                         #27985)
#     Python 3.6b1  3376 (simplify CALL_FUNCTIONs & BUILD_MAP_UNPACK_WITH_CALL
                          #27213)
#     Python 3.6b1  3377 (set __class__ cell from type.__new__ #23722)
#     Python 3.6b2  3378 (add BUILD_TUPLE_UNPACK_WITH_CALL #28257)
#     Python 3.6rc1 3379 (more thorough __class__ validation #23722)
#     Python 3.7a1  3390 (add LOAD_METHOD and CALL_METHOD opcodes #26110)
#     Python 3.7a2  3391 (update GET_AITER #31709)
#     Python 3.7a4  3392 (PEP 552: Deterministic pycs #31650)
#     Python 3.7b1  3393 (remove STORE_ANNOTATION opcode #32550)
#     Python 3.7b5  3394 (restored docstring as the first stmt in the body;
#                         this might affected the first line number #32911)
#     Python 3.8a1  3400 (move frame block handling to compiler #17611)
#     Python 3.8a1  3401 (add END_ASYNC_FOR #33041)
#     Python 3.8a1  3410 (PEP570 Python Positional-Only Parameters #36540)
#     Python 3.8b2  3411 (Reverse evaluation order of key: value in dict
#                         comprehensions #35224)
#     Python 3.8b2  3412 (Swap the position of positional args and positional
#                         only args in ast.arguments #37593)
#     Python 3.8b4  3413 (Fix "break" and "continue" in "finally" #37830)

```


