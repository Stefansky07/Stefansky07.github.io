---
title: "Reverse Java 逆向解密"
date: 2025-08-23 14:20:00
disableNunjucks: true
---
# Reverse Java 逆向解密

**一天一道 CTF 题目，能多不能少**

下载文件，发现是个 class 文件，这好办直接使用 jd-gui 打开，[反编译](https://so.csdn.net/so/search?q=%E5%8F%8D%E7%BC%96%E8%AF%91&spm=1001.2101.3001.7020)：
![](https://i-blog.csdnimg.cn/blog_migrate/0227d0ff3c870083a734e013a5adee87.png)
逻辑是如此清晰简单，就是我们输入一个字符串
然后经过一个 for 循环进行异或
然后将得到的新字符串与 KEY 进行比较，看看是否相等~
这里我想看看在 JAVA 中的异或与 python 中的异或是否一样，我就进行了 java 代码的编译：
![](https://i-blog.csdnimg.cn/blog_migrate/a096286fa65325fd4d1b69e957ff5181.png)
再贴上 python 的代码：

```
strs = [180, 136, 137, 147, 191, 137, 147, 191,
 148, 136, 133, 191, 134, 140, 129, 135, 191, 65]

flag = ""
for i in range(0,len(strs)):
	flag += chr(strs[i] - ord('@') ^ 0x20)
print(flag)

```

也能得到：
![](https://i-blog.csdnimg.cn/blog_migrate/96e50c5a348dc45af65184ff31fd9875.png)
事实证明我想的太多了~
结果就得到了 flag：`flag{This_is_the_flag_!}`​


