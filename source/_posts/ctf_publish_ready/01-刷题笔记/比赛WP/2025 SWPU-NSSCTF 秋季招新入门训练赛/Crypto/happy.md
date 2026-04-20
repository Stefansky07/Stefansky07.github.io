---
title: "happy"
date: 2025-02-10 14:48:00
disableNunjucks: true
---
# happy

# 题目

```python
('c=', '0x7a7e031f14f6b6c3292d11a41161d2491ce8bcdc67ef1baa9eL')
('e=', '0x872a335')
#q + q*p^3 =1285367317452089980789441829580397855321901891350429414413655782431779727560841427444135440068248152908241981758331600586
#qp + q *p^2 = 1109691832903289208389283296592510864729403914873734836011311325874120780079555500202475594
```

# 分析

```python

# 根据数学推导，(q + q*p^3) / (qp + q*p^2) = (1 + p^3) / (p + p^2) = (p^2 - p + 1) / p
# 因此，p - 1 + 1/p = eq1_val / eq2_val
# 由于 p 是一个大整数，1/p 接近于 0。
# 所以 p 约等于 (eq1_val / eq2_val) + 1
# 使用方程2来求解 q： qp + q*p^2 = q * (p + p^2) = eq2_val
# 因此，q = eq2_val / (p + p^2)
```

```python

import gmpy2
import binascii
c = 0x7a7e031f14f6b6c3292d11a41161d2491ce8bcdc67ef1baa9e
e = 0x872a335

eq1_val = 1285367317452089980789441829580397855321901891350429414413655782431779727560841427444135440068248152908241981758331600586
eq2_val = 1109691832903289208389283296592510864729403914873734836011311325874120780079555500202475594

ratio = gmpy2.mpz(eq1_val) // gmpy2.mpz(eq2_val)
p = gmpy2.mpz(ratio) + 1
print(f"p = {p}\n")

q = gmpy2.mpz(eq2_val) // (p + p**2)
print(f"q = {q}\n")


n = p * q
print(f"n = {n}\n")

phi_n = (p - 1) * (q - 1)
print(f"phi_n = {phi_n}\n")
d = gmpy2.invert(e, phi_n)
print(f"d = {d}\n")
m_int = pow(c, d, n)
print(f"m_int (十进制) = {m_int}\n")

m_hex = hex(m_int)
print(f"m_hex = {m_hex}\n")
m_hex_clean = m_hex[2:]
if len(m_hex_clean) % 2 != 0:
    m_hex_clean = '0' + m_hex_clean
flag = binascii.unhexlify(m_hex_clean).decode('utf-8')
print(f"Flag = {flag}\n")
```

# Flag

NSSCTF{happy_rsa_1}

# 参考


