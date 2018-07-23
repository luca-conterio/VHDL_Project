#!/usr/bin/python

import random

randArray = [];
num = input("Numero elementi da inserire: ")
# matrice 7x24 con valore di soglia pari a 128
cols = "2 => \"00011000\", "
rows = "3 => \"00000111\", "
soglia = "4 => \"10000000\", "
addrmin = 5     # restringo l'intervallo fra addrmin e addrmax 
addrmax = 172   # per avere rettangoli di dimensioni differenti

F = open("test.txt", "w")

for i in range(0, num): 
	R = random.randint(addrmin, addrmax) # estraggo numero casuale
	while R in randArray: # se il numero e' gia' stato estratto, riprovo (evita duplicati)
		R = random.randint(addrmin, addrmax)
	randArray.append(R)   # aggiungo il numero estratto ad un array
	
randArray.sort() # riordino l'array

F.write(cols)    # scrivo su file l'array generato
F.write(rows)
F.write(soglia)
for element in randArray:
	F.write(str(element))
	F.write(" => \"10000000\", ")
F.close()