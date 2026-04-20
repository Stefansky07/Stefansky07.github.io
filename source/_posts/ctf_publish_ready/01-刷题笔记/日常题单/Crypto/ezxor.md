---
title: "ezxor"
date: 2025-06-12 11:49:00
disableNunjucks: true
---
# ezxor

# 一：题目类型

异或

# 二：题目

```python
from functools import reduce
from operator import xor
from random import sample, randint, shuffle
from libnum import s2n, n2s
import base64,hashlib,string,random
from Crypto.Util.number import *
from vigenere import encrypt, decrypt, random_key
from gmssl import sm3, func
def generate_key():
    letters = string.ascii_lowercase
    random_string = ''.join(random.choice(letters) for i in range(4))
    hash_key = hash_value = sm3.sm3_hash(func.bytes_to_list(random_string.encode('utf-8')))
    return random_string,hash_key

def random_num(a, min_num, max_num):
    k_box = sample(range(min_num, max_num), (a + 1) * 2)
    return k_box


flag="flag{*********************************}"
flag = base64.b64encode(flag[5:-1].encode()).decode()
fg = [flag[i:i+4] for i in range(0, len(flag), 4)]

key=generate_key()
print(key[0],key[1])
# assert key=sm3_deocde(ed7c5e5a9e7db0af63ff1857c74f1612503714e7257e3135161ac693263c5bc3)
k_boxs=[]
a_boxs=[]
for i, j in enumerate(fg):
    k_box = random_num(i, 10000000, 100000000)
    k_boxs.append(k_box)
    encrypted_texts = []
    for z,t in enumerate(k_box):
        shifted_t = t << z
        k_box[z] = shifted_t
        a=(reduce(xor,k_box)) >> 3 ^ s2n(j) ^ s2n(key[0]) >> 5
    a_boxs.append(a)
print(k_boxs)
print(a_boxs)
python

```

# 三：解题思路

首先，对于key，是4字节的小写字母

```
letters = string.ascii_lowercase
```

然后用sm3取了个hash，这里我们直接生成个字典爆破就行。然后题目是把flag里面的内容base64编码了，然后4个一组

```
flag = base64.b64encode(flag[5:-1].encode()).decode()
```

题目给出了两个box的值
关键的代码是这么一段，其中enumerate(k_box)产生的值就是(index,k_box[index])

```
for z,t in enumerate(k_box):
```

这里的a是我们的密文，他是由(reduce(xor,k_box)) >> 3 ^ s2n(j) ^ s2n(key[0]) >> 5产生
这里有三个异或成分：
1.A=(reduce(xor,k_box)) >> 3，意思就是将kbox列表成员依次异或，然后再右移
2.B=s2n(j) 4字节的flag片段
3.C=s2n(key[0]) >> 5 就是将key右移了一下，是个常量。对于A，其实就是最后的k_boxs[i]，因为每次赋值和上一次循环的结果无关（并不会和本身的a发生关系），所以这里的A也是一个常量，题目给的hint中，逆位移是错误的！
题目提示：key需要自己通过给定的assert信息和生成信息来爆破，由于先左移和异或都是一个可逆的过程，对k_box盒中的所有值先异或在对加密后的值异或，处理左移，用左移的反操作右移即可还原回去。
逆回去就是，B=a_boxs[i]<sup>C</sup>A

# 四：解题代码

```python
from libnum import *
from operator import xor
from gmssl import sm3, func
import base64
import string
import itertools
import tqdm

# 使用 SM3 哈希函数生成密钥
def GKey(x):
    return sm3.sm3_hash(func.bytes_to_list(x.encode('utf-8')))

# 破解密钥，通过遍历所有可能的 4 位小写字母组合
def Crack():
    for x in tqdm.tqdm([''.join(x) for x in itertools.product(string.ascii_lowercase, repeat=4)]):
        if GKey(x) == "ed7c5e5a9e7db0af63ff1857c74f1612503714e7257e3135161ac693263c5bc3":
            return x

# 破解密钥
key = Crack()
assert key == "vyxj"

# 定义 k_boxs 和 a_boxs
k_boxs = [
    [85960428, 124048944],
    [76896516, 148233042, 148344300, 430828728],
    [18813226, 47434414, 384576428, 756186952, 1176559104, 3012655264],
    [32419498, 135200222, 144078312, 418343384, 264781840, 997176032, 1575860096, 2311119872],
    [78138466, 26105444, 246378096, 673137192, 780322864, 580638816, 1013888320, 8267513088, 18261797376, 38464371712],
    [74398718, 34836126, 114351808, 84194008, 864090304, 2058369664, 3768046400, 9054897920, 3609117696, 31962163200, 78609714176, 143030124544],
    [95136078, 121787282, 142893752, 595233264, 1428549856, 3051172768, 5077270848, 1495076864, 12870877440, 47778328576, 70943019008, 73837846528, 347317125120, 202464190464],
    [25940628, 178611312, 187525036, 724730696, 1262246272, 538422912, 5178823296, 11962676480, 3681039360, 43111816192, 53454863360, 46940395520, 324584484864, 738174935040, 1180945874944, 2680363352064],
    [91476910, 40438622, 284009216, 189141944, 494422624, 1909378272, 1859258688, 8325893632, 8679649792, 25956180480, 19010518016, 149400145920, 75571052544, 216012996608, 877107707904, 1918758420480, 4670701109248, 1511231979520],
    [74597483, 35476838, 332670940, 628899328, 1006051312, 1810494112, 1815836800, 6254008448, 9059957248, 37066194944, 84866486272, 143417882624, 374722654208, 421553152000, 289192411136, 2595834003456, 1876405256192, 3073277952000, 5138042585088, 16906505420800],
    [43202734, 123038960, 230151348, 227006016, 1316620848, 2661215424, 1102296384, 6063244416, 13653935872, 15262126080, 56829879296, 203848990720, 319030505472, 273716043776, 1328383262720, 3109532008448, 1974875389952, 10583088431104, 17563729002496, 41257490972672, 104812289982464, 173872034873344],
    [40707932, 62510266, 127238668, 433986608, 1493914656, 2017700128, 941191424, 4402769536, 6413621248, 34974545408, 76024111104, 149649319936, 63424671744, 591347908608, 1425053548544, 2109411262464, 3604948779008, 1747924942848, 12591446097920, 36837998985216, 14717609312256, 116828735012864, 67418525270016, 162300363276288]
]
a_boxs = [1320734445, 1299107274, 1462892431, 1369698413, 8147346610, 28131911745, 62500239353, 489185004903, 558579233563, 1461508494923, 30901854114296, 31037226326417]

# 通过 k_boxs 和 a_boxs 还原 flag
flag = []
for i in range(len(k_boxs)):
    # 每个部分的解密公式
    decoded = n2s(
        a_boxs[i] ^
        ((reduce(xor, k_boxs[i]) >> 3) ^
        (s2n(key) >> 5))
    ).decode()
    flag.append(decoded)

# 将 flag 转为字符串并解码为 Base64
flag = base64.b64decode(''.join(flag)).decode()
print(f"Key: {key}\nFlag: flag{{{flag}}}")


```


