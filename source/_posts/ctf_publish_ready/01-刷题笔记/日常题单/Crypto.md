---
title: "Crypto"
date: 2025-05-16 01:57:00
disableNunjucks: true
---
# Crypto

# 什么是Cryptography?

与平常所说的“账号密码”不同，这里提到的Cryptography（密码学）研究的是“加密”，而常说的“账号密码”对应的说法应该是“口令”（password）。密码学的基本目的是使得两个在不安全信道中通信的人，通常称为Alice和Bob，以一种使他们的敌手Eve不能明白和理解通信内容的方式进行通信。而这样的不安全信道在实际中是普遍存在的，例如电话线或计算机网络。一段明文经过密钥加密后，就会变为一段“让人看不懂”的密文，而经过密钥解密后，就会变回有意义的明文。

在密码学中还有许多有意思的问题，例如，如何在没有事先商定好密钥的情况下，在一个公开的网络中 完成信息的秘密传输？如何确认这个信息是由朋友本人传输的而不是他人伪造？是否存在理论上不可攻破的密码体系......诸多问题，将在以后的学习中得到解答。

# Whatis Crypto in CTF?

CTF比赛中的Crypto方向，一般来说注重于现代密码学中的Cryptoanalysis（密码分析）。在比赛中，出题人往往会将加密算法公开出

来，然后再将密文等信息发送给参赛选手，参赛选手需要分析加密算法中的缺点、漏洞，进而找到相应的利用方法。

## Some basic knowledge for Crypto in CTF

Crypto方向所需的一些基础知识：

**基本的Python编程知识**

初学者只需要能够看懂基本的代码即可，可以在比赛期间边学边精进编程能力。

**数学知识**

Crypto方向相较于CTF中的其他方向，需要你有一定的数学基础。不过千万不要被繁难的数学知识劝退，更多的是边做题边进行学习，循序渐进。

入门：Elementary Number Theory（初等数论）

进阶：Linear Algebra （线性代数）、Abstract Algebra（抽象代数）

**算法知识**

更重要的是理解算法内在的思想

一些例子：

1. 搜索的时间复杂度，空间复杂度的估计与平衡
2. 二分思想
3. 二进制技巧优化 快速幂
4. bsgs思想：打哈希表&分块
5. etc.

**英语知识**

掌握一点必要的英语知识对于密码学的学习还是很有帮助的。

# 如何学习Cryptography/Crypto？

一些基本的学习方法：

1. 学会使用搜索引擎去寻找有价值的学习资源。
2. 多读书，多看文档，勤于思考。3. 读大佬的博客文章进行学习，例如：Van1sh's blog
3. Get your hands dirty! 在实践中学习，切忌纸上谈兵！

注：

推荐一些可供日常参考学习的书：

"An Introduction to Mathematical Cryptography" 作者：Jeffrey Hoffstein, Jill Pipher, Joseph H. Silverman

笔者强烈推荐。初学者如果英语过关的话，可以放心食用此书。

"Cryptography Theory and Practice Third Edition" （密码学原理与实践）作者：Douglas R.Stinson

相关tools

笔者推荐的一些Crypto中常用的工具。

**Linux**

笔者比较推荐在Linux下配置Crypto常用的各种环境和工具，比较方便省心。

**Python**

笔者常用的一些Python Package：

1. gmpy2

> GMP/MPIR, MPFR, and MPC interface to Python

gmpy2是Python的一个扩展库，是对GMP（GNU高精度算术运算库）的封装，其前身为gmpy。

install:

```shell
pip install gmpy2
```

2. pycryptodome

> PyCryptodome is a self-contained Python package of low-level cryptographic primitives.

3. pwntools

> pwntools  is a CTF framework and exploit development library. Written in Python, it is designed for rapid prototyping
>
> and development, and intended to make exploit writing as simple as possible

CTF Crypto交互题好帮手

install:

```shell
pip install pwntools
```

Sagemath

简介：

> SageMath is a free open-source mathematics software system licensed under the GPL. It builds on top of many
>
> existing open-source packages: NumPy, SciPy, matplotlib, Sympy, Maxima, GAP, FLINT, R and many more. Access
>
> their combined power through a common, Python-based language or directly via interfaces or wrappers.

Sagemath是一款快速成长且开源的数学软件，提供了非常丰富的代数与数论方面的功能。对于密码人来说，Sagemath的使用体验还是

相当不错的。在以后的学习中，你会慢慢感受到它的强大之处的。

sagemath安装指北：

Installation Guide (sagemath.org)

笔者推荐使用Conda来进行安装，较为方便。如果读者是初学者，且安装sagemath有困难的话，可以暂时跳过。

More tools

更多强力实用的工具就留给聪明的读者去自行探索发现了。

# 如何解决困难（diffculties）?

当遇到困难时，我们应该如何解决？笔者在这里给出三点建议：

尝试利用搜索引擎或LLM（大语言模型）解决，尝试各种问法。

在充分阅读《提问的智慧》并领会其主要精神后，再去尝试求助群里的Crypto管理员。

尝试改变你的求解策略，切忌钻牛角尖。“山重水复疑无路，柳暗花明又一村”

‍


