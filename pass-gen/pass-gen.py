import hashlib

def index_at(index:list, list:list):
  for i in index:
    print(list[i], end=' ')
  print('')

string = "proxmox.com"

salt1 = "xijiangfeng"
salt2 = "19991126"


out1 = hashlib.sha256((string+salt1).encode()).hexdigest()
out2 = hashlib.sha256((string+salt2).encode()).hexdigest()

array = []
array_index = []

for i in range(32):
  array.append(int(out1[i*2:(i+1)*2], 16))
  array_index.append(int(out2[i*2:(i+1)*2], 16))

print(array, array_index)
# for i in range(26):
  # print(f"\'{chr(65+i)}\', ", end='')
letter_array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
letter_cap_array = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
symbol_array = ['_', '.', '#', '$', '%', '', '&', '!', '^']

number_array = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

letter = []

number = []

symbol = []

n = 10 

for i in range(n):
  tmp = array_index[i] % 32
  letter.append(array[tmp] % 26)

print(letter)

for i in range(n):
  tmp = array_index[31 - i] % 32
  number.append(array[tmp] % 10)

print(number)


for i in range(n):
  tmp = array_index[2*i] % 32
  symbol.append(array[tmp] % 8)

print(symbol)

index_at(letter, letter_array)
index_at(letter, letter_cap_array)
index_at(number, number_array)
index_at(symbol, symbol_array)

