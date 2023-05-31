# KlipperScreen更换中文
```
sudo apt-get install ttf-wqy-zenhei
```
## 安装中文字体文泉驿-正黑，此字体支持点阵显示，启用后更锐利
```
sudo apt install fonts-wqy-zenhei
```
## 设置系统时区
```
sudo timedatectl set-timezone Asia/Shanghai
```
## 生成并设置系统 locale，这段我不记得了，自己测试。Armbian 等可以直接设置。
## edit /etc/locale.gen，取消注释 zh_CN.UTF-8
```
locale-gen
```
```
sudo localectl set-locale LANG=zh_CN.UTF-8
```
## 修改 KScreen 配置文件或者从界面内选择中文显示即可。重启 KScreen 生效
```
sudo systemctl restart KlipperScreen
```