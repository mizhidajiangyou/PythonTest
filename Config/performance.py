"""
	性能测试配置文件，请勿改动样式！
"""
diskList="sdc sdd sde sdy sdz"
entireDisk="sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo sdp sdq sdr sds sdt sdu sdv sdw sdx sdy sdz"
# 服务端服务IP
TEST_HOST = "192.168.0.123"
# 服务端ISCSI的IP
SWIA="13.10.10.36"
SWIB="13.10.10.37"
# 客户端ISCSI的IP
CWI="13.10.10.79"
CW_IQN = ["iqn.1997-09.org.debian:09:asdasdascsx4564123333","iqn.1997-09.org.debian:09:asdasdascsx4564123333" ]
# 服务端FC的IP
CFI = ["192.168.16.231", "192.168.16.232" ]
# WWPN
CWWPN = ["21000036ff963215", "21000036ff963216" ,"21000036ff963217" ,"21000036ff963218"]
# 测试项目
TEST_TRIM = ["NFS", "CIFS", "FC", "ISCSI"]


