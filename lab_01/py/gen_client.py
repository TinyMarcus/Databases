from mimesis import Person
from mimesis import Address
from mimesis import Datetime
from mimesis import random
from mimesis.enums import Gender
import random

person = Person('ru')
address = Address('ru')
datetime = Datetime()
file = open("clients.txt", 'w')

list_rating = []
list_cities = ['Истра', 'Правдинск', 'Соликамск', 'Железнодорожный', 'Углич', 'Белёв', 'Тайга', 'Красноармейск', 'Володарск', 'Гаджиево', 'Яровое', 'Багратионовск', 'Среднеуральск', 'Невельск', 'Питкяранта', 'Темников', 'Калач-на-Дону', 'Сергиев Посад', 'Бугуруслан', 'Калининград', 'Лесной', 'Ишимбай', 'Жирновск', 'Нефтекамск', 'Серпухов', 'Балахна', 'Железногорск', 'Тюкалинск', 'Воронеж', 'Черемхово', 'Каменск-Уральский', 'Эртиль', 'Алагир', 'Новокубанск', 'Избербаш', 'Гуково', 'Сокол', 'Ельня', 'Баймак', 'Ступино', 'Высоцк', 'Коломна', 'Сосновоборск', 'Суздаль', 'Сковородино', 'Оханск', 'Малгобек', 'Спасск-Дальний', 'Каменск-Шахтинский', 'Юхнов']
list_date = []
list_phones = []
list_email = []
list_seniority = []
list_shops = []

for i in range(10000):
    list_date.append(datetime.date(start = 1960, end = 2005))
    list_phones.append(person.telephone())
    list_email.append(person.email())
    list_shops.append(random.randint(1, 1000))

for i in range(10000):
    list_seniority.append(random.randint(0, 10))

for i in range(1, 10001):
    file.write("%d|%s|%s|г.%s, %s|%s|%s\n" %(i, person.full_name(), list_date[i-1], random.choice(list_cities), address.address(),
                                                   list_phones[i-1], list_email[i-1]))

