import xlrd
import pymysql
"连接数据库"
db = pymysql.connect('localhost', 'root', 'yehang0201', 'testdb')
cursor = db.cursor()
cursor.execute('''create table if not exists homework2(
                  学号 varchar(20) primary key,
                  姓名 varchar(20),
                  第一题分数 int,
                  第一题评价 varchar(30),
                  第二题分数 int,
                  第二题评价 varchar(30),
                  成绩 int
                  )
''')


query = '''insert ignore into homework2
(学号,姓名,第一题分数,第一题评价,第二题分数,第二题评价,成绩) values (%s, %s, %s,%s,%s,%s,%s)   
'''   # ignore避免重复插入，很奇怪成绩用%s，用%d会报错
book = xlrd.open_workbook("homework2.xlsx")
sheet = book.sheet_by_index(0)  # 得到第一个表，xls中可能有多张表
nrows = sheet.nrows   # 行

for i in range(1, nrows):
    try:
        学号 = sheet.cell_value(i, 0)
        姓名 = sheet.cell_value(i, 1)
        第一题分数 = (sheet.cell_value(i, 2))
        第一题评价 = sheet.cell_value(i, 3)
        第二题分数 = (sheet.cell_value(i, 4))
        第二题评价 = sheet.cell_value(i, 5)
        成绩 = int(sheet.cell_value(i, 6))
        values = (学号, 姓名, 第一题分数, 第一题评价, 第二题分数, 第二题评价, 成绩)
        cursor.execute(query, values)
        #print(values)
    except:
        print("error at ", i)
        continue
cursor.close()
db.commit()
db.close()
