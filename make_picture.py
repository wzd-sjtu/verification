from captcha.image import ImageCaptcha

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
CHAR_SET = number + alphabet + ALPHABET

print(len(CHAR_SET))

#  首先生成对应的字符串序列  大小为number  是可以调节的
def make_char(number):
    context_text = []
    for i in range(number):
        qq = random.choice(CHAR_SET)
        context_text.append(qq)
    return ''.join(context_text)

#  生成验证码  number 表示有几位验证码的存在
def make_pic(number):
    image = ImageCaptcha()
    context = make_char(number)

    final_image = Image.open(image.generate(context))
    return context,final_image

if __name__ == "__main__":
    pic_number = 20
    number_s = 5
    path = './image'
    if not os.path.exists(path):
        os.makedirs(path)

    for i in range(pic_number):
        now = str(int(time.time()))
        text,image = make_pic(number_s)
        file_name = text+'_'+now+'.png'
        image.save(path+os.path.sep+file_name)
