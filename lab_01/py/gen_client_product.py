from mimesis import Person
from mimesis import Address
from mimesis import Datetime
from mimesis import random
from mimesis.enums import Gender
import random

person = Person('ru')
address = Address('ru')
datetime = Datetime()
file = open("clients_products.txt", 'w')

list_client = []
list_product = []
list_quantity = []

for i in range(10000):
    list_client.append(random.randint(1, 10000))
    list_product.append(random.randint(1, 1000))
    list_quantity.append(random.randint(1, 3))

for i in range(1, 1001):
    file.write("%d|%d|%d\n" %(i, list_product[i-1], list_quantity[i-1]))


