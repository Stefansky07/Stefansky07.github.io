---
title: "pyc反编译"
date: 2025-12-22 10:44:00
disableNunjucks: true
---
# pyc反编译

> 摘要：python 逆向的个人小总结，边打边写，遇到新题就更新更新。 本文使用的主要工具为 pycdc 。

python 逆向 也是 CTF reverse 的一个重要组成部分（<sub>废话</sub>）。
题目一般会给一个 exe 文件或者 pyc 文件。

工欲善其事，必先利其器，好的工具是必不可少的。

1. exe 转 pyc 工具：

[GitHub - WithSecureLabs/python-exe-unpacker: A helper script for unpacking and decompiling EXEs compiled from python code.](https://github.com/WithSecureLabs/python-exe-unpacker)
[GitHub - pyinstxtractor/pyinstxtractor-ng: PyInstaller Extractor Next Generation](https://github.com/pyinstxtractor/pyinstxtractor-ng)

2. 在线网站 (`exe->pyc`​)：[PyInstaller Extractor WEB](https://pyinstxtractor-web.netlify.app/)
3. 在线网站 (`pyc->python`​)：[在线 Python pyc 文件编译与反编译](https://www.lddgo.net/string/pyc-compile-decompile) 或 [python 反编译](https://tool.lu/pyc/)
4. 有的时候，在线工具不好用，可以用 pycdc（强推），下载后记得 `cmake`​ 构建。

```git
git clone https://github.com/zrax/pycdc.git
```

1. 如果为如果你明确是一个 python 得到的 exe 文件，用上面的网址，将其转为 .pyc 文件。
2. 对于. pyc 我个人喜欢有用 `pycdc`​ 。

```shell
pycdas.exe xxxx.pyc  	#转字节码
pycdc.exe xxxx.pyc		#转python代码
```

3. 如果可以得到完整的 python 代码，那么就简单了，pycdc 转换失败，那么就只好用 pycdas 配合可能解出的代码（可能没有），分析获取源码。
4. 注意：有的时候要对 `Magic Number`​ 进行操作，等我有遇到再补充。

多说无益，上题！

我的 pycadc 初体验

---

如题目，这个题目是我曾经的 python 逆向入门题。

> 题目：[[NSSRound#22 Basic]ezcrypt](https://www.nssctf.cn/problem/5377)

```
import crypto
from Crypto.Cipher import Blowfish

def encrypt_file(input_path, output_path, key):
Unsupported opcode: BEFORE_WITH
    cipher = Blowfish.new(key, Blowfish.MODE_CBC)
    bs = Blowfish.block_size



key = b'crypto.SomeEncode'
input_path = '.\\input'
output_path = '.\\output'
encrypt_file(input_path, output_path, key)


```

​`pycdc`​ 得到的结果是有问题的，上 `pycdas`​ ！

```
NSSCTF.pyc (Python 3.12)
[Code]
    File Name: NSSCTF.py
    Object Name: <module>
    Qualified Name: <module>
    Arg Count: 0
    Pos Only Arg Count: 0
    KW Only Arg Count: 0
    Stack Size: 5
    Flags: 0x00000000
    [Names]
        'crypto'
        'Crypto.Cipher'
        'Blowfish'
        'encrypt_file'
        'key'
        'input_path'
        'output_path'
    [Locals+Names]
    [Constants]
        0
        None
        (
            'Blowfish'
        )
        [Code]
            File Name: NSSCTF.py
            Object Name: encrypt_file
            Qualified Name: encrypt_file
            Arg Count: 3
            Pos Only Arg Count: 0
            KW Only Arg Count: 0
            Stack Size: 6
            Flags: 0x00000003 (CO_OPTIMIZED | CO_NEWLOCALS)
            [Names]
                'Blowfish'
                'new'
                'MODE_CBC'
                'block_size'
                'open'
                'read'
                'len'
                'iv'
                'encrypt'
                'write'
            [Locals+Names]
                'input_path'
                'output_path'
                'key'
                'cipher'
                'bs'
                'file'
                'plaintext'
                'padding_length'
                'encrypted_data'
            [Constants]
                None
                'input'
                'rb'
                b'\x00'
                'wb'
            [Disassembly]
                0       RESUME                          0
                2       LOAD_GLOBAL                     1: NULL + Blowfish
                12      LOAD_ATTR                       2: new
                32      LOAD_FAST                       2: key
                34      LOAD_GLOBAL                     0: Blowfish
                44      LOAD_ATTR                       4: MODE_CBC
                64      CALL                            2
                72      STORE_FAST                      3: cipher
                74      LOAD_GLOBAL                     0: Blowfish
                84      LOAD_ATTR                       6: block_size
                104     STORE_FAST                      4: bs
                106     LOAD_GLOBAL                     9: NULL + open
                116     LOAD_CONST                      1: 'input'
                118     LOAD_CONST                      2: 'rb'
                120     CALL                            2
                128     BEFORE_WITH
                130     STORE_FAST                      5: file
                132     LOAD_FAST                       5: file
                134     LOAD_ATTR                       11: read
                154     CALL                            0
                162     STORE_FAST                      6: plaintext
                164     LOAD_CONST                      0: None
                166     LOAD_CONST                      0: None
                168     LOAD_CONST                      0: None
                170     CALL                            2
                178     POP_TOP
                180     LOAD_FAST                       4: bs
                182     LOAD_GLOBAL                     13: NULL + len
                192     LOAD_FAST_CHECK                 6: plaintext
                194     CALL                            1
                202     LOAD_FAST                       4: bs
                204     BINARY_OP                       6 (%)
                208     BINARY_OP                       10 (-)
                212     STORE_FAST                      7: padding_length
                214     LOAD_FAST                       6: plaintext
                216     LOAD_CONST                      3: b'\x00'
                218     LOAD_FAST                       7: padding_length
                220     BINARY_OP                       5 (*)
                224     BINARY_OP                       13 (+=)
                228     STORE_FAST                      6: plaintext
                230     LOAD_FAST                       3: cipher
                232     LOAD_ATTR                       14: iv
                252     LOAD_FAST                       3: cipher
                254     LOAD_ATTR                       17: encrypt
                274     LOAD_FAST                       6: plaintext
                276     CALL                            1
                284     BINARY_OP                       0 (+)
                288     STORE_FAST                      8: encrypted_data
                290     LOAD_GLOBAL                     9: NULL + open
                300     LOAD_FAST                       1: output_path
                302     LOAD_CONST                      4: 'wb'
                304     CALL                            2
                312     BEFORE_WITH
                314     STORE_FAST                      5: file
                316     LOAD_FAST                       5: file
                318     LOAD_ATTR                       19: write
                338     LOAD_FAST                       8: encrypted_data
                340     CALL                            1
                348     POP_TOP
                350     LOAD_CONST                      0: None
                352     LOAD_CONST                      0: None
                354     LOAD_CONST                      0: None
                356     CALL                            2
                364     POP_TOP
                366     RETURN_CONST                    0: None
                368     PUSH_EXC_INFO
                370     WITH_EXCEPT_START
                372     POP_JUMP_IF_TRUE                1 (to 376)
                374     RERAISE                         2
                376     POP_TOP
                378     POP_EXCEPT
                380     POP_TOP
                382     POP_TOP
                384     JUMP_BACKWARD                   103 (to 180)
                386     COPY                            3
                388     POP_EXCEPT
                390     RERAISE                         1
                392     PUSH_EXC_INFO
                394     WITH_EXCEPT_START
                396     POP_JUMP_IF_TRUE                1 (to 400)
                398     RERAISE                         2
                400     POP_TOP
                402     POP_EXCEPT
                404     POP_TOP
                406     POP_TOP
                408     RETURN_CONST                    0: None
                410     COPY                            3
                412     POP_EXCEPT
                414     RERAISE                         1
        b'crypto.SomeEncode'
        '.\\input'
        '.\\output'
    [Disassembly]
        0       RESUME                          0
        2       LOAD_CONST                      0: 0
        4       LOAD_CONST                      1: None
        6       IMPORT_NAME                     0: crypto
        8       STORE_NAME                      0: crypto
        10      LOAD_CONST                      0: 0
        12      LOAD_CONST                      2: ('Blowfish',)
        14      IMPORT_NAME                     1: Crypto.Cipher
        16      IMPORT_FROM                     2: Blowfish
        18      STORE_NAME                      2: Blowfish
        20      POP_TOP
        22      LOAD_CONST                      3: <CODE> encrypt_file
        24      MAKE_FUNCTION                   0
        26      STORE_NAME                      3: encrypt_file
        28      LOAD_CONST                      4: b'crypto.SomeEncode'
        30      STORE_NAME                      4: key
        32      LOAD_CONST                      5: '.\\input'
        34      STORE_NAME                      5: input_path
        36      LOAD_CONST                      6: '.\\output'
        38      STORE_NAME                      6: output_path
        40      PUSH_NULL
        42      LOAD_NAME                       3: encrypt_file
        44      LOAD_NAME                       5: input_path
        46      LOAD_NAME                       6: output_path
        48      LOAD_NAME                       4: key
        50      CALL                            3
        58      POP_TOP
        60      RETURN_CONST                    1: None


```

根据上面的逻辑可以复原函数【**注意：此代码段中存在一些反汇编特有的标记（如** **​`NULL +`​** ​ **），在实际代码中并不存在】** ：

```
def encrypt_file(input_path, output_path, key):
    
    cipher = Blowfish.new(key, Blowfish.MODE_CBC)
    bs = Blowfish.block_size 
    with open(input_path, 'rb') as file:
        plaintext = file.read()

    
    padding_length = bs - len(plaintext) % bs 
    
    plaintext += b'\x00' * padding_length

    
    iv = cipher.iv
    
    encrypted_data = iv + cipher.encrypt(plaintext)
    
    
    with open(output_path, 'wb') as file:
        file.write(encrypted_data)


```

注意 key 的获取，不是简单的 `b'crypto.SomeEncode'`​ 这个应该是出题人给的提示，打开刚刚得到的反编译的文件夹，发现有一个神奇的加密文件 `pycdc.exe crypto.cpython.pyc`​

```
def encrypt(v, k):
    v0 = v[0]
    v1 = v[1]
    (key0, key1, key2, key3) = (k[0], k[1], k[2], k[3])
    sum = 0
    delta = 0x9E3779B9L
    for _ in range(32):
        sum = sum + delta & 0xFFFFFFFFL
        v0 = v0 + ((v1 << 3) + key0 ^ v1 + sum ^ (v1 >> 4) + key1 ^ 596) & 0xFFFFFFFFL
        v1 = v1 + ((v0 << 3) + key2 ^ v0 + sum ^ (v0 >> 4) + key3 ^ 2310) & 0xFFFFFFFFL
    return (v0, v1)


def encrypt_all(v, k):
    encrypted = []
    for i in range(0, len(v), 2):
        encrypted.extend(encrypt(v[i:i + 2], k))
    return encrypted

v = [
    1396533857,
    0xCC8AE275L,
    0x89FB8A63L,
    940694833]
k = [
    17,
    34,
    51,
    68]
encrypted = encrypt_all(v, k)
SomeEncode = ''.join((lambda .0: for num in .0:
for i in range(4)[::-1]:
chr(num >> 8 * i & 255))(encrypted))


```

是一个就是简单的魔改 tea，解密【具体逆向常用的 `TEA XTEA XXTEA RC4`​ 等先挖一个坑】：

```
def encrypt(v, k):
    v0 = v[0]
    v1 = v[1]
    (key0, key1, key2, key3) = (k[0], k[1], k[2], k[3])
    sum = 0
    delta = 0x9E3779B9
    for _ in range(32):
        sum = sum + delta & 0xFFFFFFFF
        v0 = v0 + ((v1 << 3) + key0 ^ v1 + sum ^ (v1 >> 4) + key1 ^ 596) & 0xFFFFFFFF
        v1 = v1 + ((v0 << 3) + key2 ^ v0 + sum ^ (v0 >> 4) + key3 ^ 2310) & 0xFFFFFFFF
    return (v0, v1)

def decrypt(v, k):
    v0 = v[0]
    v1 = v[1]
    (key0, key1, key2, key3) = (k[0], k[1], k[2], k[3])
    sum = 0xC6EF3720
    delta = 0x9E3779B9
    for _ in range(32):
        v1 =v1 - ((v0 << 3) + key2 ^ v0 + sum ^ (v0 >> 4) + key3 ^ 2310) & 0xFFFFFFFF
        v0 = v0 - ((v1 << 3) + key0 ^ v1 + sum ^ (v1 >> 4) + key1 ^ 596) & 0xFFFFFFFF
        sum = sum - delta & 0xFFFFFFFF
    return (v0, v1)
    
def encrypt_all(v, k):
    encrypted = []
    for i in range(0, len(v), 2):
        encrypted.extend(encrypt(v[i:i + 2], k))
    return encrypted

def decrypt_all(v, k):
    decrypted = []
    for i in range(0, len(v), 2):
        decrypted.extend(decrypt(v[i:i + 2], k))
    return decrypted

v = [1396533857,
    0xCC8AE275,
    0x89FB8A63,
    940694833]
k = [
    17,
    34,
    51,
    68]
encrypted = decrypt_all(v, k)
SomeEncode = ''
for i in range(4):
    for j in range(4):
        SomeEncode += chr(encrypted[i] >> (8 * (3 - j)) & 0xFF)
print(SomeEncode) 


```

ok，获得 key ，用 key 解密：

```
from Crypto.Cipher import Blowfish

def decrypt_file(input_path, output_path, key):
    cipher = Blowfish.new(key, Blowfish.MODE_CBC)
    bs = Blowfish.block_size
    with open(input_path, 'rb') as file:
        encrypted_data = file.read()

    
    iv = encrypted_data[:bs]
    
    cipher = Blowfish.new(key, Blowfish.MODE_CBC, iv)
    
    decrypted_data = cipher.decrypt(encrypted_data[bs:])
    
    
    decrypted_data = decrypted_data.rstrip(b'\x00')

    with open(output_path, 'wb') as file:
        file.write(decrypted_data)

key = b'EzNssRevProjects' 
input_path = '.\\output'
output_path = '.\\decrypted_output'
decrypt_file(input_path, output_path, key)


```

到这里关于 `python`​ 就差不多了，剩下的 `IDA`​ 打开，就是简单的分析，解密流程：

```
using namespace std;

void de(unsigned char* a1, int* a2, int a3) {
    int v5; // [rsp+20h] [rbp-4h]

    for ( int i = 0; i < a3; ++i) {
        v5 = i % 4;
        // 整理一下
        switch (v5) {
        case 0: a1[i] ^= a2[4] + a2[1]; break;
        case 1: a1[i] ^= a2[0] - a2[2]; break;
        case 2: a1[i] += a2[1] ^ a2[3]; break;
        case 3: a1[i] -= a2[2] + a2[0]; break;
        }
    }
}

int main()
{
	int v4[8]; // [rsp+10h] [rbp-50h] BYREF

	v4[0] = 35;
	v4[1] = 18;
	v4[2] = 69;
	v4[3] = 86;
	v4[4] = 103;
    // 大小端的问题，整体顺序是从前往后看，每一部分的数据是从（后往前看）
    unsigned char flag[] = { 0x37,0x8d,0xf,0xab,0x2d,0x98,0x37,0xb5,0x48,0xa6,0x30,0xda,0xc,0xed,0x1b,0xb8,0x0,0xe9,0x24,0x98,0x17,0x81,0xed,0xb6,0x26,0x8c,0x21,0xde,0x4,0xde};
    int flag_len = sizeof(flag) / sizeof(flag[0]);
    printf("%d\n", flag_len); //30
	de(flag, v4, flag_len);
    for (int i = 0; i < flag_len; i++) {
        printf("%c", flag[i]);
    } 
	return 0LL;
} 


```

我的 pycadc 破碎了

---

> **题目：第二届黄河流域网络安全技能挑战赛 ezpyc**

下载的文件这里找不到了，可以看看网络上有没有。
直接解析是有问题的， 其他方法以后在探索吧。
这里硬读 python 字节码：
![](https://img2024.cnblogs.com/blog/3439823/202405/3439823-20240516221805306-1191458099.jpg)

逻辑不难，可以分析得到：

```
import base64
import sys

def check(ininput):
    str1 = 'RitdR+kuGPFoYpX4NVP{PVOx[VSzXhLnO{L2Xkj3[l[8]'
    str2 = list(str1)
    list1 = list(ininput)
    for q in range(len(str2)):
        if list1[q] != str2[q]:
            print('Wrong!!!')
    print('All input is correct!')
def encode(eenv):
    
    env = base64.b64encode(eenv.encode('utf-8')).decode('utf-8')
    
    str2 = list(env)
    for i in range(len(str2)):
        str2[i] = chr(ord(str2[i]) ^ 2)
    for j in range(11):
        str2[j] = chr(ord(str2[j]) - 6)
    for k in range(11, 22):
        str2[k] = chr(ord(str2[k]) + 1)
    for h in range(22, 33):
        str2[h] = str2[h] 
    for l in range(33, 44):
        str2[l] = chr(ord(str2[l]) ^ 3)
    
    str3 = ''
    for w in range(len(str2)):
        str3 += str2[w]
    return str3
enc = input('Please input your flag:')
ininput = list(enc)
if len(ininput) != 33:
    print('Wrong length!')
    sys.exit()
env = encode(enc)
check(env)


```

题解：

```
import base64
str1 = 'RitdR+kuGPFoYpX4NVP{PVOx[VSzXhLnO{L2Xkj3[l[8]'
str2 = list(str1)

print(str2)
for l in range(33, 44):
    str2[l] = chr(ord(str2[l]) ^ 3)
for h in range(22, 33):
    str2[h] = str2[h]
for k in range(11, 22):
    str2[k] = chr(ord(str2[k]) - 1)
for j in range(11):
    str2[j] = chr(ord(str2[j]) + 6)
for i in range(len(str2)):
    str2[i] = chr(ord(str2[i]) ^ 2)
print(str2)
flag = ''.join(str2)
print(len(flag))
print(base64.b64decode(flag))



```

神奇的数字

---

这里的本意是要写 `Magic Number`​，但是本菜鸡还没有遇到，遇到了再补充（<sub>大概吧</sub>）。


