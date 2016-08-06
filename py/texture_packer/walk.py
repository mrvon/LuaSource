import os
import shutil
from PIL import Image

root_path = "E:/prj_x/code/client/project/res"
#  root_path = "./test"
unpacker_cmd = "python ./unpacker.py {} plist"
packer_cmd = ("TexturePacker.exe --data {}"
              " --format cocos2d"
              " --dpi 72"
              " --max-size 2048"
              " --force-squared"
              " --size-constraints {}"
              " --algorithm MaxRects"
              " --sheet {} {}")
pot_mode = "POT"
anysize_mode = "AnySize"


def walk(path):
    for i in os.listdir(path):
        ap = path+os.sep+i
        if os.path.isdir(ap):
            walk(ap)
        else:
            target_ext = os.path.splitext(ap)[1]
            if target_ext == ".plist":
                target_path = os.path.splitext(ap)[0]
                process(target_path)


def process(path):
    #  unpack
    os.system(unpacker_cmd.format(path))

    if not os.path.exists(path):
        return

    temp_plist = path+"_temp_pot.plist"
    temp_png = path+"_temp_pot.png"

    os.system(packer_cmd.format(
        temp_plist,
        pot_mode,
        temp_png,
        path))

    # check size
    ori_f = open(path+".png", "rb")
    pot_f = open(temp_png, "rb")
    ori_im = Image.open(ori_f)
    pot_im = Image.open(pot_f)
    ori_size = ori_im.size[0] * ori_im.size[1]
    pot_size = pot_im.size[0] * pot_im.size[1]

    ori_f.close()
    pot_f.close()

    os.remove(temp_png)
    os.remove(temp_plist)

    # too big
    if pot_size > ori_size * 2:
        shutil.rmtree(path)
        return

    # overwrite it
    temp_plist = path+".plist"
    temp_png = path+".png"

    os.system(packer_cmd.format(
        temp_plist,
        anysize_mode,
        temp_png,
        path))

    # del temp file
    shutil.rmtree(path)

if __name__ == '__main__':
    walk(root_path)
