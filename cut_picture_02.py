import gvcode
import os
s,v=gvcode.generate()

#s.show()
print((s.size))
print(v)

path = './image02'
if not os.path.exists(path):
    os.makedirs(path)

for i in range(2):
    pic,text=gvcode.generate()
    file_name= text+'.png'
    pic.save(path + file_name)