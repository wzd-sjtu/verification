#  下面这些是基本的python包

#  这个包是需要下载的
from captcha.image import ImageCaptcha

#  这些包是自带的
from PIL import Image
import random
import time
import os


#  ok  这个是生成验证码的python基本代码
#  以下是验证码的字母范围
number = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
            'v', 'w', 'x', 'y', 'z']
ALPHABET = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
            'V', 'W', 'X', 'Y', 'Z']
#  三个列表加在一起形成一个大列表，包含所有数据，一共有62个
CHAR_SET = number + alphabet + ALPHABET

print(len(CHAR_SET))

#  首先生成对应的字符串序列  大小为number 即验证码中有多少个字符  有number个  是可以调节的
def make_char(number):
    context_text = []
    #  一个循环
    for i in range(number):
        #  从之前的大列表里面随机取一个字符，存储在qq里面
        qq = random.choice(CHAR_SET)
        #  把qq加入到context_text列表的末尾，这些内容用于生成验证码
        context_text.append(qq)
    #  最后返回数据时，在每个字符之间加上一个空格，返回字符串
    #  实例  把[abcd]变成[a b c d]
    return ''.join(context_text)

#  生成验证码  number 表示有几位验证码的存在
def make_pic(number):
    #  验证按图片的一个对象
    image = ImageCaptcha()
    #  利用上文的make_char函数返回随机数序列[a b c d]
    context = make_char(number)
    #  调用库生成验证码图片
    final_image = Image.open(image.generate(context))
    #  返回验证码图片的内容和图片矩阵 final_image
    return context,final_image

#  主函数，表示程序从这里开始
if __name__ == "__main__":
    #  生成图片的数量，可以动态调节
    pic_number = 20
    #  验证码里面字符的数量，可以动态调节
    number_s = 5

    #  存储在当前目录文件夹image里面，如果没有，就创建一个
    path = './image'
    if not os.path.exists(path):
        os.makedirs(path)

    #  主循环，用于生成指定数量的验证码
    for i in range(pic_number):
        #  时间序列
        now = str(int(time.time()))
        #  利用上文的函数生成的序列以及对应的验证码图片矩阵
        text,image = make_pic(number_s)
        #  文件的名字
        file_name = text+'_'+now+'.png'
        #  按照名字保存在文件夹image里面
        image.save(path+os.path.sep+file_name)
