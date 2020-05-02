from PIL import Image,ImageDraw,ImageFont
import random
import os
import xlwt
#定义使用Image类实例化一个长为400px,宽为400px,基于RGB的(255,255,255)颜色的图片

def make_pic():
	img1=Image.new(mode="RGB",size=(32,32),color=(255,255,255))
	font1 = ImageFont.truetype(font="arial.ttf", size=29)
	color1=(random.randint(0,255),random.randint(0,255),random.randint(0,255))
	draw1=ImageDraw.Draw(img1,mode="RGB")
	#char1=random.choice([chr(random.randint(65,90)),str(random.randint(0,9))])
	tmp_char=random.randint(0,9)
	char1 = random.choice(str(tmp_char))
	draw1.text( [8, 0],char1, color1, font=font1)

	return tmp_char,img1

pic_number=2000
path = './image03'
if not os.path.exists(path):
	os.makedirs(path)

workbook = xlwt.Workbook('label.xls')
worksheet = workbook.add_sheet('Sheet1')
for i in range(pic_number):

	#  利用上文的函数生成的序列以及对应的验证码图片矩阵
	text, image = make_pic()
	#  文件的名字
	file_name = str(i) + '.png'
	#  按照名字保存在文件夹image里面
	image.save(path + os.path.sep + file_name)
	worksheet.write(i,1,text)

workbook.save('label.xls')