---
title: "base__"
date: 2025-01-22 08:01:00
disableNunjucks: true
---
# base??

# 题目

```python
dict:{0: 'J', 1: 'K', 2: 'L', 3: 'M', 4: 'N', 5: 'O', 6: 'x', 7: 'y', 8: 'U', 9: 'V', 10: 'z', 11: 'A', 12: 'B', 13: 'C', 14: 'D', 15: 'E', 16: 'F', 17: 'G', 18: 'H', 19: '7', 20: '8', 21: '9', 22: 'P', 23: 'Q', 24: 'I', 25: 'a', 26: 'b', 27: 'c', 28: 'd', 29: 'e', 30: 'f', 31: 'g', 32: 'h', 33: 'i', 34: 'j', 35: 'k', 36: 'l', 37: 'm', 38: 'W', 39: 'X', 40: 'Y', 41: 'Z', 42: '0', 43: '1', 44: '2', 45: '3', 46: '4', 47: '5', 48: '6', 49: 'R', 50: 'S', 51: 'T', 52: 'n', 53: 'o', 54: 'p', 55: 'q', 56: 'r', 57: 's', 58: 't', 59: 'u', 60: 'v', 61: 'w', 62: '+', 63: '/', 64: '='}

chipertext:
FlZNfnF6Qol6e9w17WwQQoGYBQCgIkGTa9w3IQKw

```

# 分析

一眼自定义base表加密

```python
import base64

# Provided custom dictionary
custom_dict = {0: 'J', 1: 'K', 2: 'L', 3: 'M', 4: 'N', 5: 'O', 6: 'x', 7: 'y', 8: 'U', 9: 'V', 10: 'z', 11: 'A', 12: 'B', 13: 'C', 14: 'D', 15: 'E', 16: 'F', 17: 'G', 18: 'H', 19: '7', 20: '8', 21: '9', 22: 'P', 23: 'Q', 24: 'I', 25: 'a', 26: 'b', 27: 'c', 28: 'd', 29: 'e', 30: 'f', 31: 'g', 32: 'h', 33: 'i', 34: 'j', 35: 'k', 36: 'l', 37: 'm', 38: 'W', 39: 'X', 40: 'Y', 41: 'Z', 42: '0', 43: '1', 44: '2', 45: '3', 46: '4', 47: '5', 48: '6', 49: 'R', 50: 'S', 51: 'T', 52: 'n', 53: 'o', 54: 'p', 55: 'q', 56: 'r', 57: 's', 58: 't', 59: 'u', 60: 'v', 61: 'w', 62: '+', 63: '/', 64: '='}

# Provided ciphertext
ciphertext = 'FlZNfnF6Qol6e9w17WwQQoGYBQCgIkGTa9w3IQKw'

# Create the custom alphabet from the dictionary keys 0-63
custom_alphabet = ""
for i in range(64):
    custom_alphabet += custom_dict[i]

# Standard Base64 alphabet
standard_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

# Create a translation table to map custom characters to standard ones
translation_table = str.maketrans(custom_alphabet, standard_alphabet)

# Translate the ciphertext
translated_ciphertext = ciphertext.translate(translation_table)

# The padding character '=' is not in the 0-63 range, so we handle it separately
translated_ciphertext = translated_ciphertext.replace(custom_dict[64], '=')

# Perform standard Base64 decoding on the translated string
# Note: Base64 decoding requires a byte-like object as input
plaintext_bytes = base64.b64decode(translated_ciphertext)

# Convert the bytes to a string
plaintext = plaintext_bytes.decode('utf-8')

print(f"原始密文: {ciphertext}")
print(f"解码后的明文: {plaintext}")
```

# Flag

NSSCTF{D0_Y0u_kNoW_Th1s_b4se_map}

# 参考


