---
title: "md5的破解"
date: 2025-02-13 16:02:00
disableNunjucks: true
---
# md5的破解

# 题目

```python
from Crypto.Util.number import *
from hashlib import md5
from secret import flag

#flag全是由小写字母及数字组成
m=md5(flag).hexdigest()
print(flag[:13]+flag[15:18]+flag[19:34]+flag[35:38])
print(m)
# b'LitCTF{md5can3derypt213thoughcrsh}'
# 496603d6953a15846cd7cc476f146771

```

# 分析

暴力破解md5，根据他提示跑就行了

```python
import hashlib
import string

# 真正的 flag 对应的哈希值
target_hash = '496603d6953a15846cd7cc476f146771'

# 缺失字符的取值范围：小写字母和数字
charset = string.ascii_lowercase + string.digits

# 已知部分
part1 = 'LitCTF{md5can'
part2 = '3de'
part3 = 'rypt213thoughcr'
part4 = 'sh}'

print("正在寻找正确的 flag...")

# 遍历所有可能的字符组合
for c1 in charset:
    for c2 in charset:
        for c3 in charset:
            for c4 in charset:
                # 构造完整的 flag
                flag = part1 + c1 + c2 + part2 + c3 + part3 + c4 + part4

                # 计算该 flag 的 MD5 哈希值
                m = hashlib.md5(flag.encode()).hexdigest()

                # 检查哈希值是否匹配
                if m == target_hash:
                    print("找到了！真正的 Flag 是:", flag)
                    exit()
```

# Flag

NSSCTF{md5can123dexrypt213thoughcrpsh}

# 参考


