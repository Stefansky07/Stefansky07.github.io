---
title: "Hello Crypto"
date: 2025-04-01 09:18:00
disableNunjucks: true
---
# Hello Crypto

# 一：题目类型

签到题

# 二：题目

```python
```Python
from Crypto.Util.number import bytes_to_long
from secret import flag

m = bytes_to_long(flag)
print("m =",m)

# In cryptography, m stands for message, also plaintext
# so, why this m is number?
# decrypt this Message to get flag!
# m = 215055650564999508008576750591675252316192925291695034999561028004456783589022642807177244207076805630587034871697651348093
```

# 三：解题思路与代码

### 方法一：

很简单的签到题，直接解即可。

```python

from Crypto.Util.number import*
from secret import flag
m = 215055650564999508008576750591675252316192925291695034999561028004456783589022642807177244207076805630587034871697651348093
print(long_to_bytes(m))
#SHCTF{hElI0_ctFeR_wE1c0M3_7O_CRYp7o_WoR1D_AeaETdE2}

```

# 四：感悟

签到题争取拿一血。


