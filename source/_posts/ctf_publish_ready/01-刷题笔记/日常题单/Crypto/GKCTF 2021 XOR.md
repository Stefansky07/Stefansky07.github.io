---
title: "GKCTF 2021 XOR"
date: 2025-06-17 13:40:00
disableNunjucks: true
---
# GKCTF 2021 XOR

# 一：题目类型

异或

# 二：题目

```python
from Crypto.Util.number import *
from hashlib import md5

a = getPrime(512)
b = getPrime(512)
c = getPrime(512)
d = getPrime(512)
d1 = int(bin(d)[2:][::-1] , 2)
n1 = a*b
x1 = a^b
n2 = c*d
x2 = c^d1
flag = md5(str(a+b+c+d).encode()).hexdigest()
print("n1 =",n1)
print("x1 =",x1)
print("n2 =",n2)
print("x2 =",x2)

#n1 = 83876349443792695800858107026041183982320923732817788196403038436907852045968678032744364820591254653790102051548732974272946672219653204468640915315703578520430635535892870037920414827506578157530920987388471203455357776260856432484054297100045972527097719870947170053306375598308878558204734888246779716599
#x1 = 4700741767515367755988979759237706359789790281090690245800324350837677624645184526110027943983952690246679445279368999008839183406301475579349891952257846
#n2 = 65288148454377101841888871848806704694477906587010755286451216632701868457722848139696036928561888850717442616782583309975714172626476485483361217174514747468099567870640277441004322344671717444306055398513733053054597586090074921540794347615153542286893272415931709396262118416062887003290070001173035587341
#x2 = 3604386688612320874143532262988384562213659798578583210892143261576908281112223356678900083870327527242238237513170367660043954376063004167228550592110478

```

# 三：解题思路

根据已知的n1、n2、x1、x2解出a、b、c、d就行了。
⾸先算a、b，
两个数异或，从低位开始爆破
当异或结果为1时，a b对应的位置上只有两种情况， 1 0或者0 1
当异或结果为0时，a b对应的位置上也只有两种情况， 1 1或者0 0

```python
import itertools

n1 = 83876349443792695800858107026041183982320923732817788196403038436907852045968678032744364820591254653790102051548732974272946672219653204468640915315703578520430635535892870037920414827506578157530920987388471203455357776260856432484054297100045972527097719870947170053306375598308878558204734888246779716599
x1 = 4700741767515367755988979759237706359789790281090690245800324350837677624645184526110027943983952690246679445279368999008839183406301475579349891952257846

a_list, b_list = [0], [0]

cur_mod = 1
for i in range(720):
    cur_mod *= 2
    nxt_as, nxt_bs = [], []
    for al, bl in zip(a_list, b_list):
        for ah, bh in itertools.product([0, 1], repeat=2):
            aa, bb = ah*(cur_mod // 2) + al, bh*(cur_mod // 2) + bl
            if ((aa * bb % cur_mod == n1 % cur_mod) and ((aa ^ bb) == x1 % cur_mod)):
                nxt_as.append(aa)
                nxt_bs.append(bb)
    
    a_list, b_list = nxt_as, nxt_bs

for a, b in zip(a_list, b_list):
    if a * b == n1 and a*b-n1==0 and (a^b)-x1==0:
        break

print(a)
print(b)
```

运行得到

```
7836147139610655223711469747200164069484878894626166870664740637786609468164555354874619497753277560280939259937394201154154977382033483373128424196987617
10703774182571073361112791376032380096360697926840362483242105878115552437021674861528714598089603406032844418758725744879476596359225265333530235803365847

```

然后求c、d，和a、b不同，这次是和d1异或，而d1是d的二进制的逆序

```python
import itertools

n1 = 65288148454377101841888871848806704694477906587010755286451216632701868457722848139696036928561888850717442616782583309975714172626476485483361217174514747468099567870640277441004322344671717444306055398513733053054597586090074921540794347615153542286893272415931709396262118416062887003290070001173035587341

x1 = 3604386688612320874143532262988384562213659798578583210892143261576908281112223356678900083870327527242238237513170367660043954376063004167228550592110478

a_list, b_list, aa_list, bb_list = [0], [0], [0], [0]

x1_bits = [int(x) for x in f'{x1:0512b}'[::-1]]

cur_mod = 1
for i in range(256):
    cur_mod *= 2
    nxt_as, nxt_bs, nxt_aas, nxt_bbs = [], [], [], []
    for al, bl, a2, b2 in zip(a_list, b_list, aa_list, bb_list):
        for ah, bh, ah2, bh2 in itertools.product([0, 1], repeat=4):
            aa, bb, aa2, bb2 = ah*(cur_mod // 2) + al, bh*(cur_mod // 2) + bl, ah2*(cur_mod // 2) + a2, bh2*(cur_mod // 2) + b2
            bb2_rev = f'{bb2:0512b}'[::-1]
            bb2_rev = int(bb2_rev, 2)
            aa2_rev = f'{aa2:0512b}'[::-1]
            aa2_rev = int(aa2_rev, 2)

            gujie = '0' * (i+1) + '1' * (510 - 2 * i) + '0' * (i+1)
            gujie = int(gujie, 2)
            if ((aa * bb % cur_mod == n1 % cur_mod) and ((ah ^ bh2) == x1_bits[i]) and (ah2 ^ bh == x1_bits[511-i]) and ((aa2_rev + aa) * (bb2_rev + bb) <= n1) and ((aa2_rev + aa + gujie) * (bb2_rev + bb + gujie) >= n1)):
                nxt_as.append(aa)
                nxt_bs.append(bb)
                nxt_aas.append(aa2)
                nxt_bbs.append(bb2)
    
    a_list, b_list, aa_list, bb_list = nxt_as, nxt_bs, nxt_aas, nxt_bbs

for a, b, aa2, bb2 in zip(a_list, b_list, aa_list, bb_list):
    aa2_rev = f'{aa2:0512b}'[::-1]
    aa2_rev = int(aa2_rev, 2)
    bb2_rev = f'{bb2:0512b}'[::-1]
    bb2_rev = int(bb2_rev, 2)
    a = aa2_rev + a
    b = bb2_rev + b
    if (a * b == n1):
        break

print(a)
print(b)
print(a * b - n1)
print((a ^ b) - x1)

```

但是我没看懂这位师傅是怎么求的c、d，所以找了[另一位](https://cloud.tencent.com/developer/article/1844889)的代码：

```python
from hashlib import md5

def get_ab(n,x):
    a = [0]
    b = [0]
    maskx = 1
    maskn = 2
    for i in range(1024):
        xbit = (x&maskx)>>i
        nbit = n%maskn
        taa = []
        tbb = []
        for j in range(len(a)):
            for aa in range(2):
                for bb in range(2):
                    if aa^bb == xbit:
                        temp2 = n%maskn
                        temp1 = (aa*maskn//2+a[j])*(bb*maskn//2+b[j])%maskn
                        if temp1==temp2:
                            taa.append(aa*maskn//2+a[j])
                            tbb.append(bb*maskn//2+b[j])
        maskx *= 2
        maskn *= 2
        a = taa
        b = tbb
    for a1 in a:
        if n % a1 == 0:
            a = a1
            b = n//a1
            return a,b
def get_cd(n,x):
    p_low = [0]
    p_high = [0]
    q_low = [0]
    q_high = [0]
    maskx = 1
    maskn = 2
    si = 2
    for i in range(256):
        x_lowbit = (x& maskx)>>i
        n_lowbits = (n % maskn)
        tmppp_low = []
        tmpqq_low =[]
        tmppp_high = []
        tmpqq_high = []
        x_highbit = (x>>(511-i)) & 1
        n_highbits = (n) >>(1022-2*i)
        for j in range(len(p_low)):
            for pp_low in range(2):
                for qq_low in range(2):
                    for pp_high in range(2):
                        for qq_high in range(2):
                            if pp_low^qq_high ==x_lowbit and qq_low^pp_high == x_highbit:
                                temp1 = ((pp_low * maskn//2 +p_low[j])*(qq_low*maskn//2 +q_low[j]))% maskn
                                temp2 = (((pp_high << (511-i))+p_high[j])* ((qq_high<<(511-i))+q_high[j]))>>(1022-2*i)
                                if temp1 == n_lowbits:
                                    if n_highbits-temp2 >=0 and n_highbits-temp2 <=((2<<i+1)-1):
                                        tmppp_low.append(pp_low*maskn//2 + p_low[j])
                                        tmpqq_low.append(qq_low*maskn//2+q_low[j])
                                        tmppp_high.append((pp_high<<(511-i))+p_high[j])
                                        tmpqq_high.append((qq_high<<(511-i))+q_high[j])
        maskn  *= 2
        maskx *= 2
        p_low = tmppp_low
        q_low = tmpqq_low
        p_high = tmppp_high
        q_high = tmpqq_high
    for a in p_low:
        for b in p_high:
            if n %(a+b) ==0:
                p = a+b
                q = n//p
                return p,q


n1 = 83876349443792695800858107026041183982320923732817788196403038436907852045968678032744364820591254653790102051548732974272946672219653204468640915315703578520430635535892870037920414827506578157530920987388471203455357776260856432484054297100045972527097719870947170053306375598308878558204734888246779716599
x1 = 4700741767515367755988979759237706359789790281090690245800324350837677624645184526110027943983952690246679445279368999008839183406301475579349891952257846
n2 = 65288148454377101841888871848806704694477906587010755286451216632701868457722848139696036928561888850717442616782583309975714172626476485483361217174514747468099567870640277441004322344671717444306055398513733053054597586090074921540794347615153542286893272415931709396262118416062887003290070001173035587341
x2 = 3604386688612320874143532262988384562213659798578583210892143261576908281112223356678900083870327527242238237513170367660043954376063004167228550592110478

a = get_ab(n1,x1)[0]
b = get_ab(n1,x1)[1]
c = get_cd(n2,x2)[0]
d = get_cd(n2,x2)[1]
flag = md5(str(a+b+c+d).encode()).hexdigest()
print(flag)

```

运行得到：f28ed218415356b4336e2f778f2981bb
GKCTF{f28ed218415356b4336e2f778f2981bb}


