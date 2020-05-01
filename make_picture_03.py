from PIL import Image,ImageDraw,ImageFont
import random
#定义使用Image类实例化一个长为400px,宽为400px,基于RGB的(255,255,255)颜色的图片
img1=Image.new(mode="RGB",size=(32,32),color=(255,255,255))


font1 = ImageFont.truetype(font="arial.ttf", size=22)
color1=(random.randint(0,255),random.randint(0,255),random.randint(0,255))
draw1=ImageDraw.Draw(img1,mode="RGB")
char1=random.choice([chr(random.randint(65,90)),str(random.randint(0,9))])
draw1.text( [10, 5],char1, color1, font=font1)

img1.show()
with open("pic.png","wb") as f:
	img1.save(f,format="png")