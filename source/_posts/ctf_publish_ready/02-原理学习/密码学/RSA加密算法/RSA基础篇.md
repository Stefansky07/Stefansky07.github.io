---
title: "RSA基础篇"
date: 2025-10-01 04:31:00
disableNunjucks: true
---
# RSA基础篇

# 一：参考网页

http://www.py3study.com/Article/details/id/19417.html
https://bbs.pediy.com/thread-266504.htm
https://blog.csdn.net/vhkjhwbs/article/details/101160822
https://www.freebuf.com/articles/database/264603.html
https://www.dazhuanlan.com/2019/10/04/5d970ff4a37c5/
ctf密码学常用python库
https://www.cnblogs.com/coming1890/p/13506932.html
https://blog.csdn.net/chenzzhenguo/article/details/94339659
http://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html

# 二：运算规则

欧拉函数φ(n)的定义是小于n的自然数中与n互质的数的个数.
那么对于p<sup>e,它只有质因数p,那么不与它互质的数肯定含有p这个质因子,这样的数有p</sup>e p=p^{e-1}个,剩下的为与p<sup>e互质的,有p</sup>e-p<sup>{e-1}=p</sup>{e-1}*(p-1)个

```python
运算规则
模运算与基本四则运算有些相似，但是除法除外。其规则如下：
(a + b) % p = (a % p + b % p) % p
(a - b) % p = (a % p - b % p) % p
(a * b) % p = (a % p * b % p) % p
a ^ b % p = ((a % p) ^ b) % p
结合律
((a + b) % p + c) = (a + (b + c) % p) % p
((a * b) % p * c) = (a * (b * c) % p) % p
交换律
(a + b) % p = (b + a) % p
(a * b) % p = (b * a) % p
分配律
(a + b) % p = (a % p + b % p) % p
((a + b) % p * c) % p = ((a * c) % p + (b * c) % p
重要定理
若 a ≡ b (mod p)，则对于任意的 c，都有(a + c) ≡ (b + c) (mod p)
若 a ≡ b (mod p)，则对于任意的 c，都有(a * c) ≡ (b * c) (mod p)
若 a ≡ b (mod p)，c ≡ d (mod p)，则
(a + c) ≡ (b + d) (mod p)
(a - c) ≡ (b - d) (mod p)
(a * c) ≡ (b * d) (mod p)
(a / c) ≡ (b / d) (mod p)

逆元

逆元是指在数学领域群G中任意一个元 a，都在G中有唯一的逆元a'，具有性质 a · a' = a' · a = e ( · 为该群中定义的运算)。其中，e为该群的单位元。
逆元其实是加法中的相反数以及乘法中的倒数的拓展思想。
在模运算中，单位元便是1。
a mod p的逆元便是可以使 a * a' mod p = 1 的最小a'。

枚举法
枚举1到p - 1的整数bi，若b * bi % p = 1，则bi即为b mod p的乘法逆元。
为什么只枚举到p - 1呢？

1. 如果枚举到 p，那么显然 b * p % p = 0;；
2. 如果枚举到 p + k ( 0 < k < p)，那么有 b * (p + k) % p = b * p % p + b * k % p = b * k % p，这样就返回了枚举1到p - 1的情况；
3. 如果枚举到 p + k ( k > p)，同第二种情况

拓展欧几里得(Extend - Eculid)
求最小整数x、y，使 x * a + y * b = gcd(a , b)；

类似这样的问题便可以使用拓展欧几里得来求解。

由欧几里得定理可知gcd(a , b) = gcd(b , a % b) (假设 a > b)，

所以有x' * b + y' * (a % b) = gcd(a , b)，假设已经求得 x' 和 y'，那么有 ：

∵ x' * b + y' * ( a % b) = gcd(a , b) and a % b = a - [a / b] * b

∴ x' * b + y' * ( a - [a / b] * b) = gcd(a , b)

∴ y' * a + (x' - y' * [a / b]) * b = gcd(a , b)

如此这个问题便可以递归的求解了。

（显然如果b = 0的话，那么x = 1，y = 0）

那么求解 b' 使得 b * b‘ mod p = 1 这个问题便可以转化为：

求最小整数 b'、k，使得 b' * b + k * p = 1；

费马小定理(Fermat's little theorem)
假如 p 是质数，那么 a ^ (p-1) ≡ 1 (mod p) 。
推论： b ^ (p - 2) % p 即为 b mod p 的乘法逆元。
```

# 三：大纲

[P00.python安装及pycharm配置](RSA基础篇/P00.python安装及pycharm配置.md)
[P02.gmpy2及相关库安装](RSA基础篇/P02.gmpy2及相关库安装.md)
[P03.RSA算法简介及原理](RSA基础篇/P03.RSA算法简介及原理.md)
[P04.RSA基础题目及脚本](RSA基础篇/P04.RSA基础题目及脚本.md)
[P05.基于N分解的题目](RSA基础篇/P05.基于N分解的题目.md)
[P06.RSA密钥生成与读取](RSA基础篇/P06.RSA密钥生成与读取.md)
[P15.共模攻击](RSA基础篇/P15.共模攻击.md)
[P08.wiener(维纳)攻击](RSA基础篇/P08.wiener(维纳)攻击.md)
[P09.低加密指数攻击](RSA基础篇/P09.低加密指数攻击.md)
[P10.低加密指数广播攻击](RSA基础篇/P10.低加密指数广播攻击.md)
[P11.共享素数-N不互素](RSA基础篇/P05.基于N分解的题目/P11.共享素数-N不互素.md)
[P12.dp泄露](RSA基础篇/P12.dp泄露.md)
[P13. dp,dq](RSA基础篇/P13.%20dp,dq.md)
[P14.n是p的r次方](RSA基础篇/P14.n是p的r次方.md)
[P07.已知e _d n 求p q](RSA基础篇/P07.已知e%20_d%20n%20求p%20q.md)
[P16.N分解三个素数](RSA基础篇/P16.N分解三个素数.md)
[P17.e和phi_n不互素](RSA基础篇/P17.e和phi_n不互素.md)
[P01.RSA常用解密代码块（网上收集）](RSA基础篇/P01.RSA常用解密代码块（网上收集）.md)
[P19.Franklin-Reiter攻击脚本](RSA基础篇/P19.Franklin-Reiter攻击脚本.md)
[P20 P+1或p-1光滑](RSA基础篇/P20%20P+1或p-1光滑.md)
[P21.dp泄露变种之e较大](RSA基础篇/P21.dp泄露变种之e较大.md)


