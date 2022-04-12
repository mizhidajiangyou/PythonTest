import os
import sys
import time

parent_path = os.path.dirname(sys.path[0])
if parent_path not in sys.path:
	sys.path.append(parent_path)

from Config.performance import diskList
from Common.timeOperate import zSleep

if __name__=='__main__':

	os.system('')