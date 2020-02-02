# Рубежный контроль №3. Ильясов Идрис ИУ7-53Б. Вариант 2. Задание 2.

import psycopg2
import psycopg2.extras

conn = psycopg2.connect(dbname='shops_db', user='ilyasov', 
                        password='Dcl7vF99', host='localhost')

# Собственная функция для соединения двух таблиц
def join(cursor1, cursor2, string):
    res = []
    
    for i in cursor1:
        for j in cursor2:
            if i[string] == j[string]:
                for k in j.keys():
                    if k != string:
                        if k in i.keys():
                            if type(i[k]) == list:
                                i[k].append(j[k])
                            else:
                                i[k] = [i[k], j[k]]
                        else:    
                            i[k] = j[k]
    return res   


# Для запросов через execute
cursor_first_sql = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
cursor_second_sql = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
cursor_third_sql = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)

# Для написания запросов с использованием средств Python
cursor_first_py = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
cursor_second_py = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
cursor_third_py = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)



# Первый запрос
# ==============
# Для каждой улицы вывести количество расположенных на ней филиалов (execute)
cursor_first_sql.execute("""select distinct branch.address, count(branch.id) 
                        over (partition by branch.id) as count_branches from branch;""")
first_records = cursor_first_sql.fetchall()
print("1ый запрос")
for row in first_records:
    print(row)
# ==============
# Для каждой улицы вывести количество расположенных на ней филиалов (средства Python)
print('==========')
cursor_first_py.execute("select * from branch")
first_records = None
first_records = cursor_first_py.fetchall()

for row in first_records:
    print(row['address'], row.count(row['address']))



# Второй запрос
# Найти филиалы, в которых работает от 6 до 15 сотрудников в возрасте 26 лет (execute)
cursor_second_sql.execute("""select test.id, test.name, test.tmp
                             from (select branch.name, branch.id, count(workers.id) as tmp
                                   from branch join workers on branch.id = workers.branch_id
                                   group by branch.id, branch.name
                                   order by branch.id) as test join workers on test.id = workers.id
                             where test.tmp >= 6 and test.tmp <= 15 and ((current_date::date - workers.birthday::date) / 365)::int = 26;""")
second_records = cursor_second_sql.fetchall()
print("\n2ой запрос")
for row in first_records:
    print(row)
# =============
# Найти филиалы, в которых работает от 6 до 15 сотрудников в возрасте 26 лет (средства Python)
print('==========')
cursor_second_py.execute("select * from branch")
second_records = None
second_records = cursor_first_py.fetchall()



# Третий запрос
# Вывести всех сотрудников (с указанием названия филиала), в номере телефона филиала которых не встречается цифра 7
cursor_third_sql.execute("""select workers.surname, branch.name, branch.phone
                            from branch join workers on branch.id = workers.branch_id
                            where phone not like '%7%';""")
third_records = cursor_third_sql.fetchall()
print("\n3ий запрос")
for row in third_records:
    print(row)
print('==========')
cursor_third_py.execute("select * from branch")
third_records = None
third_records = cursor_first_py.fetchall()