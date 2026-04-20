---
title: "一段base64（多层套娃）"
date: 2025-06-02 08:07:00
disableNunjucks: true
---
# 一段base64（多层套娃）

一段 Base64
=========

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120094524670-166795078.png)

 本来看到题目名字和分数以为是一道水题，后来解的时候才发现有这么多编码方式，当然如果熟悉这些编码方式找在线工具解得话很快就能拿到 flag，
这篇 writeup 主要是记录一下用 python 实现所有解码
第一种方法：python 跑一下

```
import base64
import re
import html
import urllib

with open('1.txt', 'r') as f:
    C = f.read()
    
C1 = base64.b64decode(C).decode('utf-8')
# print(C1)
# \134\170\65\143\134\170\67\65\134\170\63\60


C2 = re.findall(r'\d+',C1)
# print(C2)
# ['134', '170', '65', '143', '134', '170', '67', '65', '134', '170', '63', '60',

C3 = ""
for i in C2:
    C3 += chr(int(i,8))

# print(C3)
# \x5c\x75\x30


C4 = C3.split('\\x')
C4.pop(0)
# print(C4)
# ['5c', '75', '30',

C5 = ""
for i in C4:
    C5 += chr(int(i,16))

# print(C5)
# \u0053\u0074\u0072\u0069\u006e\u0067\u002e\u0066

C6 = C5.encode().decode('unicode-escape')
# print(C6)

C7 = C6[20:-1]
# print(C7)

C8 = C7.split(',')
# print(C8)

C9 = ""
for i in C8:
    C9 += chr(int(i,10))
# print(C9)

C10 = html.unescape(C9)
C11 = html.unescape(C10)
C12 = urllib.parse.unquote(C11)
print(C12)

```

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095003338-295810320.png)

 第二种方法：用工具

安利一款工具 Converter，很强大的一款原子弹，链接：https://pan.baidu.com/s/10kHmAsjCKf1_5Pc8IoL0AA 密码：3jy0

 将 base64 编码复制粘贴到 Converter 这个软件里面

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095533483-1657343781.png)

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095542819-249254223.png)

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095553073-667512673.png)

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095604743-581465828.png)

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095612842-569630403.png)

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095619528-115454115.png)

在线 Unicode 编码转换得到 flag 

http://www.ofmonkey.com/encode/unicode

![](https://img2020.cnblogs.com/blog/2217350/202011/2217350-20201120095751216-2067252798.png)

%7B 和 %7D 是 url 编码，解出来就是 {}

```
flag{ctf_tfc201717qwe}
参考链接：
https://zhuanlan.zhihu.com/p/140576516

Bingo！



```


