from mimesis import Person
from mimesis import Address
from mimesis import random
from mimesis.enums import Gender
import random

person = Person('ru')
address = Address('ru')
file = open("shops.txt", 'w')

list_rating = []
list_cities = []

for i in range(50):
    list_cities.append(address.city())

print(list_cities)

for i in range(1000):
    list_rating.append(round(random.uniform(0, 5), 2))



'''
    for i in range(1000):
    if (list_age[i] < 30):
    list_seniority.append(random.randint(0, 5))
    elif (list_age[i] > 30 and list_age[i] < 35):
    list_seniority.append(random.randint(0, 10))
    elif (list_age[i] > 35 and list_age[i] < 45):
    list_seniority.append(random.randint(0, 15))
    else:
    list_seniority.append(random.randint(0, 20))
    '''

for i in range(1, 1001):
    file.write("%d|%.1f|г.%s, %s\n" %(i, list_rating[i-1], random.choice(list_cities), address.address()))

