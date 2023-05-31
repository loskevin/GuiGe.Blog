# voron

# 使用can 快速更新 设备固件

## 一、更新 BIGTREETECH-OCTOPUS 固件
官方链接地址：<https://github.com/bigtreetech/BIGTREETECH-OCTOPUS-V1.0/blob/master/Firmware/Klipper/README_zh_cn.md>
# 1.进入到目录 ～/
clone klipper 源码 
代码如下：
```
cd ～/
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```
进入到目录 根据主办型号配置信息
```
cd ~/klipper/
make menuconfig
```
Can更新模式
![Can更新模式](https://blog.guige.info/assets/img/3DPrint/Klipper_update_Mcu/btt-octopus-pro-446/STM32F446主控CAN-Bridge模式klipper固件配置.jpg)  
Usb更新模式
![Usb更新模式](https://blog.guige.info/assets/img/3DPrint/Klipper_update_Mcu/btt-octopus-pro-446/STM32F446主控USB模式klipper固件配置.jpg) 

配置好信息后 
```
make
```
以上部分为编译固件动作

通过can更新固件 需要用到CanBoot 脚本，可以先看下面的 CanBoot clone说明

在更新操作之前停用 klipper服务（如果失败尝试重启设备IGTREETECH-OCTOPUS）

```
sudo service klipper stop
python3 ~/CanBoot/scripts/flash_can.py -i can0 -u 填写你的OCTOPUS_UUID -r
```
```
 #进入DFU模式后的设备FLASH_DEVICE通常是0483:df11
 make flash FLASH_DEVICE=0483:df11
```

## 二、为 EBB36 刷写 CanBoot 引导
官方链接地址：<https://github.com/Arksine/CanBoot>
clone CanBoot 源码 
代码如下：
```
git clone https://github.com/Arksine/CanBoot.git
cd CanBoot
make menuconfig
make
```
建议使用can方式来配置 方便后续更新。

配置信息如图：
![配置信息图片](https://blog.guige.info/assets/img/3DPrint/Klipper_update_Mcu/btt-ebb-g0/EBB-G0主控刷CANBOOT配置.jpg)

编译后通过 usb更新 具体看官方说明
更新方式地址： <https://github.com/bigtreetech/EBB/blob/master/EBB%20CAN%20V1.1%20(STM32G0B1)/EBB36%20CAN%20V1.1/BIGTREETECH%20EBB36%20CAN%20V1.1%20%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C.pdf>
## 三、更新 EBB36 固件
EBB36 klipper配置信息同上 BIGTREETECH-OCTOPUS 一致

不同如图配置信息
![配置信息图片](https://blog.guige.info/assets/img/3DPrint/Klipper_update_Mcu/btt-ebb-g0/EBB-GO主控CAN模式klipper固件配置.jpg)

代码如下：
```
python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u $EBB_UUID
```