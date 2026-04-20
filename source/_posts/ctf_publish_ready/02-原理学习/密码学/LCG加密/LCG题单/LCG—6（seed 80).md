---
title: "LCG—6（seed 80)"
date: 2025-09-24 02:03:00
disableNunjucks: true
tags:
  - CTF
  - Crypto
categories:
  - CTF学习笔记
  - LCG题单
source_note: "D:/1400note/1410CS学习笔记/CTF学习笔记.md/原理学习笔记/密码学/LCG加密/LCG题单/LCG—6（seed 80).md"
---
# LCG—6（seed 80)

# 一：题目类型

二元copper

# 二：题目

```python
from Crypto.Util.number import *
flag = b'Spirit{*****************}'

plaintext = bytes_to_long(flag)
length = plaintext.bit_length()

a = getPrime(length)
b = getPrime(length)
n = getPrime(length)

seed = plaintext

output = []
for i in range(10):
    seed = (seed*a+b)%n
    output.append(seed>>64)
print("a = ",a)
print("b = ",b)
print("n = ",n)
print("output = ",output)
a =  731111971045863129770849213414583830513204814328949766909151
b =  456671883153709362919394459405008275757410555181682705944711
n =  666147691257100304060287710111266554526660232037647662561651
output =  [16985619148410545083429542035273917746612, 32633736473029292963326093326932585135645, 20531875000321097472853248514822638673918, 37524613187648387324374487657224279011, 21531154020699900519763323600774720747179, 1785016578450326289280053428455439687732, 15859114177482712954359285501450873939895, 10077571899928395052806024133320973530689, 30199391683019296398254401666338410561714, 21303634014034358798100587236618579995634]
```

# 三：解题思路

其中small_roots()单独定义，其中small_roots()中的m和d类似于一元coppersmith里的beta和epsilon，控制格的参数

# 四：解题代码

```python
# sage
output =  [16985619148410545083429542035273917746612, 32633736473029292963326093326932585135645, 20531875000321097472853248514822638673918, 37524613187648387324374487657224279011, 21531154020699900519763323600774720747179, 1785016578450326289280053428455439687732, 15859114177482712954359285501450873939895, 10077571899928395052806024133320973530689, 30199391683019296398254401666338410561714, 21303634014034358798100587236618579995634]
a =  731111971045863129770849213414583830513204814328949766909151
b =  456671883153709362919394459405008275757410555181682705944711
n =  666147691257100304060287710111266554526660232037647662561651

PR.<x,y> = PolynomialRing(Zmod(n))
f = ((output[0]<<64)+ x) * a + b - ((output[1]<<64) + y)
roots = small_roots(f,(2^64, 2^64), m=4, d=4)
s1 = (output[0]<<64) + roots[0][0]
m = (s1 - b) * inverse_mod(a, n) % n
print(bytes.fromhex(hex(m)[2:]))
# b'Spirit{King__of__LCG_qWq}'
import itertools
def small_roots(f, bounds, m=1, d=None):
    if not d:
        d = f.degree()
    R = f.base_ring()
    N = R.cardinality()
    f /= f.coefficients().pop(0)
    f = f.change_ring(ZZ)
    G = Sequence([], f.parent())
    for i in range(m+1):
        base = N^(m-i) * f^i
        for shifts in itertools.product(range(d), repeat=f.nvariables()):
            g = base * prod(map(power, f.variables(), shifts))
            G.append(g)
    B, monomials = G.coefficient_matrix()
    monomials = vector(monomials)
    factors = [monomial(*bounds) for monomial in monomials]
    for i, factor in enumerate(factors):
        B.rescale_col(i, factor)
    B = B.dense_matrix().LLL()
    B = B.change_ring(QQ)
    for i, factor in enumerate(factors):
        B.rescale_col(i, 1/factor)
    H = Sequence([], f.parent().change_ring(QQ))
    for h in filter(None, B*monomials):
        H.append(h)
        I = H.ideal()
        if I.dimension() == -1:
            H.pop()
        elif I.dimension() == 0:
            roots = []
            for root in I.variety(ring=ZZ):
                root = tuple(R(root[var]) for var in f.variables())
                roots.append(root)
            return roots
    return []


```

# 五：感悟

这是一个格密码，有点过于复杂了目前对我来说，先挖个坑在这里。
[[浅尝 Lattice 之 HNP-安全客 - 安全资讯平台 (anquanke.com)](https://www.anquanke.com/post/id/204846#h2-0)]()



