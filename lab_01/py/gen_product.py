from mimesis import Person
from mimesis import Address
from mimesis import Datetime
from mimesis import random
from mimesis.enums import Gender
import random

person = Person('ru')
address = Address('ru')
datetime = Datetime()
file = open("products.txt", 'w')

list_type = ['Смартфон', 'Планшет', 'Часы', 'Ноутбук', 'Компьютер', 'Моноблок', 'Дисплей', 'Телевизор', 'Процессор', 'Видеокарта', 'Системный блок', 'Корпус', 'Кулер', 'Блок питания',
             'Пауэрбанк', 'Игровая приставка', 'Кофеварка', 'Кофемашина', 'Мультиварка', 'Саундбар', 'Колонка']
country = ['Россия', 'США', 'Китай', 'Индия', 'Вьетнам', 'Великобритания', 'Япония']
list_country = []
list_prices = [None for i in range(1000)]
list_types = []
list_shops = [None for i in range(1000)]

for i in range(1000):
    list_types.append(random.choice(list_type))
    list_country.append(random.choice(country))
    list_prices[i] = random.randint(10000, 250000)
    list_shops[i] = (random.randint(1, 1000))

for i in range(1, 1001):
    file.write("%d|%s|%s|%d|%d\n" %(i, list_types[i-1], list_country[i-1], list_prices[i-1], list_shops[i-1]))
