#!/usr/bin/env bash
pPath=`python ../Performance/pltPath.py`
tPath=${pPath:0:-12}"fonts/ttf/"
cp ../Tools/Fonts/SimHei.ttf ${tPath}
rm ~/.cache/matplotlib -rf
cp ../Performance/pltPath.py ls.py
echo "import matplotlib.pyplot as plt" >> ls.py
echo "plt.rcParams['font.sans-serif']=['SimHei']" >> ls.py
python ls.py
rm ls.py