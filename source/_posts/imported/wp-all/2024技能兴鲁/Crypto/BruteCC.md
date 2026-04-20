---
title: "BruteCC"
date: 2024-11-10 15:54:35
tags:
  - CTF
  - WP
  - Crypto
categories:
  - CTF学习笔记
  - 2.比赛WP
  - 2024技能兴鲁
  - Crypto
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/2024技能兴鲁/Crypto/BruteCC.md"
---
# 一：题目类型
AES
# 二：题目
![](/img/notes/Pasted-image-20241110155358.png)

# 三：解题思路
写一个脚本爆破
# 四：解题代码
```python
from itertools import product
from Crypto.Cipher import DES
from Crypto.Util import Counter
import binascii
from Crypto.Util.number import bytes_to_long

ciphertext = "37b10cfc8ac44327618646926264dfde6609d5e64df9a1128b7ec2f3c5f58fefbfb2b3aa30b1b55524cb"
key = b'gamelab@'
known_plaintext_start = b'flag'
ciphertext = binascii.unhexlify(ciphertext)

def brute_force_ctr(ciphertext, key, known_plaintext_start):
    for iv_suffix in product('0123456789', repeat=4):
        iv_str = f"01{''.join(iv_suffix)}04"
        iv = bytes_to_long(iv_str.encode('utf-8'))
        ctr = Counter.new(64, initial_value=iv)
        des = DES.new(key, DES.MODE_CTR, counter=ctr)
        plaintext = des.decrypt(ciphertext)

        if plaintext.startswith(known_plaintext_start):
            return iv_str, plaintext
    return None, None

iv_found, decrypted_text = brute_force_ctr(ciphertext, key, known_plaintext_start)
if iv_found:
    print(f"找到的 IV: {iv_found}")
    print(f"解密后的明文: {decrypted_text.decode('utf-8')}")
else:
    print("未找到匹配的 IV")


```


