import os
import shutil
import codecs
from pathlib import Path

mainFolder = "mainFolder"
outputRepo = "../outputRepo"

pathlist = Path(mainFolder).glob('**/*.pls')
BLOCKSIZE = 1048576

for path in pathlist:
    strInputPath = str(path)
    strOutputPath = outputRepo + "/" + strInputPath;
    print(strInputPath)
        
    try:
        fh = codecs.open(strInputPath, 'r', encoding='utf-8')
        fh.readlines()
        fh.seek(0)
    except UnicodeDecodeError:
        print('File is Windows-1251 encoded')
        strOutputDirs, _ = os.path.split(strOutputPath)
        if (not os.path.exists(strOutputPath)):
            if not os.path.exists(strOutputDirs):
                print("Creating: " + strOutputDirs)
                os.makedirs(strOutputDirs)
            with codecs.open(strInputPath, "r", "CP1251") as sourceFile:
                with codecs.open(strOutputPath, "w", "utf-8") as targetFile:
                    while True:
                        print("Saving: " + strOutputPath)
                        contents = sourceFile.read(BLOCKSIZE)
                        if not contents:
                            break
                        targetFile.write(contents)
        else:
            print("File already reencoded")
    else:
        print('File is UFT-8 encoded')
        if (not os.path.exists(strOutputPath)):
            print("Copying: " + strInputPath)
            strOutputDirs, _ = os.path.split(strOutputPath)
            if (not os.path.exists(strOutputPath)):
                if not os.path.exists(strOutputDirs):
                    print("Creating: " + strOutputDirs)
                    os.makedirs(strOutputDirs)
            shutil.copyfile(strInputPath, strOutputPath)
        else:
            print("File already reencoded")
            
