---
title: "给你d又怎样"
date: 2025-05-20 03:11:00
disableNunjucks: true
---
# 给你d又怎样

# 题目

```python
from Crypto.Util.number import *
from gmpy2 import *

flag="ctfshow{***}"
m=bytes_to_long(flag.encode())
e=65537
p=getPrime(128)
q=getPrime(128)
n=p*q
phin=(p-1)*(q-1)
d=invert(e,phin)
c=pow(m,e,n)
print("c=",c)
print("hint=",pow(n,e,c))
print("e=",e)
print("d=",d)
"""
c= 48794779998818255539069127767619606491113391594501378173579539128476862598083
hint= 7680157534215495795423318554486996424970862185001934572714615456147511225105
e= 65537
d= 45673813678816865674850575264609274229013439838298838024467777157494920800897
"""
```

# 分析

$$
n=c+a
\\
hint=n^e\bmod c\\
二项式定理：hint=a^e\bmod c\\
e*d_c=1\bmod (\varphi(c))\\
hint^{d_c}=a^{e*d_c}=a\bmod(c)
$$

之后给了d就正常解了

# Flag

```sage
#sage
from Crypto.Util.number import *
from gmpy2 import *
 
c= 48794779998818255539069127767619606491113391594501378173579539128476862598083
hint= 7680157534215495795423318554486996424970862185001934572714615456147511225105
e= 65537
d= 45673813678816865674850575264609274229013439838298838024467777157494920800897
 
 
phic=euler_phi(c)
 
print(gcd(e,phic))
 
dc=invert(e,phic)
 
a=pow(hint,dc,c)
 
n=int(a)+int(c)
 
print(long_to_bytes(int(pow(c,d,n))))
#ctfshow{Oh_u_knOw_4uler}
```

# 参考

‍


