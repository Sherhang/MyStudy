import xlrd
import pymysql
import datetime
"连接数据库"
db = pymysql.connect('localhost', 'root', 'yehang0201', 'weibo')
cursor = db.cursor()
query = '''insert ignore into 黄浦江死猪事件  
(uid,昵称,所在地,市区,粉丝数,关注数,微博数,认证,认证原因,MID,发博时间,来源,转发数,评论数,配图,内容,原创) 
values (%s, %s, %s,%s, %s, %s,%s, %s, %s,%s, %s, %s,%s, %s, %s,%s, %s)   
'''   # ignore避免重复插入，很奇怪成绩用%s，用%d会报错
book = xlrd.open_workbook("黄浦江死猪事件.xlsx")
sheet = book.sheet_by_index(0)  # 得到第一个表，xls中可能有多张表
nrows = sheet.nrows   # 行

for i in range(1, nrows):
  try:
    uid = sheet.cell_value(i, 0)
    昵称 = sheet.cell_value(i, 1)
    所在地 = sheet.cell_value(i, 2)
    市区 = sheet.cell_value(i, 3)
    粉丝数 = int(sheet.cell_value(i, 4))
    关注数 = int(sheet.cell_value(i, 5))
    微博数 = int(sheet.cell_value(i, 6))
    认证 = sheet.cell_value(i, 7)
    认证原因 = sheet.cell_value(i, 8)
    MID = sheet.cell_value(i, 9)
    #print('type', sheet.cell(i,10).ctype)
    date = xlrd.xldate_as_tuple(sheet.cell(i,10).value, 0)
    发博时间 = datetime.datetime(*date)
   # print(发博时间)

    来源 = sheet.cell_value(i, 11)
    转发数 = int(sheet.cell_value(i, 12))
    评论数 = int(sheet.cell_value(i, 13))
    配图 = sheet.cell_value(i, 14)
    内容 = sheet.cell_value(i, 15)
    原创 = (sheet.cell_value(i, 16))
    values = (uid,昵称,所在地,市区, 粉丝数,关注数,微博数,认证,认证原因,MID,发博时间,来源,转发数,评论数, 配图, 内容,原创)
    print(values)
    cursor.execute(query, values)
  except:
    print('error')
    continue


cursor.close()
db.commit()
db.close()

