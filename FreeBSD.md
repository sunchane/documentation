# 這是 FreeBSD 影片安裝小筆記

* ##### 裡面有些 URL 連結失效了。

FreeBSD、 sshd、 ntpd、 samba48、 xfce4、 slim、 fcitx、 chromium、 思源黑體、 gvim、 emacs

## 1. 下載最新 FreeBSD-12.0-RELEASE-amd64-dvd1.iso

## 2. 示範用 VMware 安裝, 光碟安裝 Base 因為單純所以不做說明。
* grub 開機等議題太長篇大論，目的是架設 FreeBSD 在 Windows 上的開發環境。
* 一般使用者最好先加入 wheel group 這樣就可以 su 成 root

## 3. 設定 sshd 以便 Windows 下能夠用 cmdr 等終端機程式操作 （畫面太小）。
* ee /etc/ssh/sshd.conf
 
* PermitRootLogin yes
 
* service sshd restart
 ifconfig

## 4. 安裝 Samba48, 因為套件內沒有 smb4.conf 的 Example, 所以要用 cmdr 終端複製貼上。
* pkg update
 pkg install samba46
 
 ee /etc/rc.conf 
 
 ftpd_enable="YES" # 可選,有時候用 ftp 登入伺服器觀看設定檔很方便,但安全性就會不好，VMware 在 Windows 下常常會找不到網路上的芳鄰。
  
 samba_server_enable="YES"
 
 ee /usr/local/etc/smb4.conf
 修改 smb4.conf
 
* 參考設定網址： https://www.freebsd.org/doc/zh_TW/books/handbook/network-samba.html
   https://github.com/samba-team/samba/blob/master/examples/smb.conf.default
   
* [global]
 workgroup = WORKGROUP
 server string = Samba Server Version %v
 netbios name = ExampleMachine
 wins support = Yes
 security = user
 passdb backend = tdbsam

 pdbedit -a -u 使用者名稱
 
 testparm
 service samba_server start
 service ftpd onestart
 
* 測試 Windows 登入，打開資料夾並顯示隱藏檔 （方便修改 user HOME 的設定檔）。
 VMware 預設的網路設定有可能會讓 Samba 無法連線，如果用 smbclient 出現 protocol negotiation failed: NT_STATUS_IO_TIMEOUT
 請用 bsdconfig 進入 Networking Management > DHCP 反覆關閉開啟 Enabled 試試，或者把 VMware 的 Virtual Network Editor 點選 Restore Defaults，Samba 的版本目前是使用 samba46。
 等會處理
 
## 5. 安裝桌面環境 xfce (輕巧畫面精美)
* pkg install xorg xorg xfce xf86-video-vmware slim font-manager
 				這一個實機上應該不適用
* ee /etc/rc.conf
 dbus_enable="YES"
 hald_enable="YES"
 slim_enable="YES"
 
 Xorg -configure
 mv ~/xorg.conf.new /usr/local/etc/X11/xorg.conf
 
## 6. 安裝輸入法 fcitx
 pkg install zh-fcitx zh-fcitx-configtool zh-fcitx-chewing git wget

## 7. 修改語系、設定桌面環境登入管理
* ee /etc/profile
 加入
 
 LANG="zh_TW.UTF-8"; export LANG
 LC_CTYPE="zh_TW.UTF-8"; export LC_CTYPE
 LC_NUMERIC="zh_TW.UTF-8"; export LC_NUMERIC
 LC_TIME="zh_TW.UTF-8"; export LC_TIME
 LC_COLLATE="C"; export LC_COLLATE
 LC_MONETARY="zh_TW.UTF-8"; export LC_MONETARY
 LC_MESSAGES="zh_TW.UTF-8"; export LC_MESSAGES
 LC_PAPER="zh_TW.UTF-8"; export LC_PAPER
 LC_NAME="zh_TW.UTF-8"; export LC_NAME
 LC_ADDRESS="zh_TW.UTF-8"; export LC_ADDRESS
 LC_TELEPHONE="zh_TW.UTF-8"; export LC_TELEPHONE
 LC_MEASUREMENT="zh_TW.UTF-8"; export LC_MEASUREMENT
 LC_IDENTIFICATION="zh_TW.UTF-8"; export LC_IDENTIFICATION
 LC_ALL="zh_TW.UTF-8"; export LC_ALL
 
* ee ~/.xinitrc
 加入（/home/使用者/.xinitrc 也要,另外登入一般使用者加入。）
 
 export LANGUAGE="zh_TW.UTF-8"
 export XMODIFIERS='@im=fcitx' 
 export GTK_IM_MODULE=fcitx
 export GTK3_IM_MODULE=fcitx
 export LANG="zh_TW.UTF-8"
 export LC_CTYPE="zh_TW.UTF-8"
 export LC_NUMERIC="zh_TW.UTF-8"
 export LC_TIME="zh_TW.UTF-8"
 export LC_COLLATE=C
 export LC_MONETARY="zh_TW.UTF-8"
 export LC_MESSAGES="zh_TW.UTF-8"
 export LC_PAPER="zh_TW.UTF-8"
 export LC_NAME="zh_TW.UTF-8"
 export LC_ADDRESS="zh_TW.UTF-8"
 export LC_TELEPHONE="zh_TW.UTF-8"
 export LC_MEASUREMENT="zh_TW.UTF-8"
 export LC_IDENTIFICATION="zh_TW.UTF-8"
 export LC_ALL="zh_TW.UTF-8"
 fcitx &
 exec xfce4-session

## 8. 重新開機 這時候應該可以看到登入畫面
* 用一般使用者登入操作桌面，root 登入的話有時後會不能執行一些程式 像 chromium。
 稍微修改 滑鼠太快、解析度大小。
 
* 這時候就少用 root 登入了，所以可以在需要 su 的使用者加入 wheel 使用者群組。
 bsdconfig

* 但是還是使用外部的 ssh 登入 root 較方便。

## 9. 安裝字型 其實不用安裝一大堆套件 所以選用兩種自己安裝的字型
* 思源黑體 （會缺字但是比文泉驛正黑體美觀，可以設定為系統字體跟網頁字體。）
 文泉驛正黑體 （不缺字，加裝後不會有方塊字。）
 
 在一般使用者登入的情況下
 mkdir ~/.fonts
 cd ~/.fonts
 wget https://github.com/vuleetu/.fonts/raw/master/wqy-zenhei.ttc
 wget https://github.com/blockstack/blockstack.js/raw/master/docs/assets/fonts/OTF/SourceCodePro-Regular.otf
 wget https://github.com/tkiapril/source-fonts/raw/master/SourceHanSansTW-Regular.otf

* 如果用這種方式安裝的話，像是開機管理畫面，或者是一些 i3 環境執行的程式，會找不到字型，比較保險的方式就直接用 pkg 安裝就好。

* 開啟 font-manager 或是直接指令 font-manager 應該就可以在 User 項看到
 
* 接著就在 設定值>外觀　　以及　視窗管理程式等等設定字型

## 10.　設定　ｆｃｉｔｘ　輸入法
* 很可惜　ＦｒｅｅＢＳＤ　版本的　設定視窗沒有調輸入選字的顏色字體要用設定檔改。
 
* ｃｄ　～／.config/fcitx
 mkdir skin
 cd skin
 mkdir dark
 cd dark
 ee fcitx_skin.conf
 如最下
 
 
## 11.　現在桌面已經很美化了，可以用　ｒｏｏｔ　安裝其他軟體了（用　ｃｍｄｒ　等　ｓｓｈ　終端機登入比較好，只是要安裝程式）。

* pkg install chromium vim emacs
 
## 12. 其他
* 設定 Vim
 cd /usr/local/share/vim/vim81/colors/
 https://www.vim.org/scripts/download_script.php?src_id=9771
 可以使用 Filezilla 把檔案先傳到 FreeBSD
 接著一般使用者目錄編輯 .vimrc
 ee ~/.vimrc

*	感謝您的收看


* fcitx_skin.conf

[SkinInfo]
# 佈景名稱
Name=Dark
# 佈景版本
Version=0.8
# 佈景作者
Author=jarryson
# 佈景說明
Desc=Dark

[SkinFont]
# 輸入字型大小
FontSize=16
# 選單字型大小
MenuFontSize=16
# 字型大小按照 dpi 設定
# Available Value:
# True False
RespectDPI=True
# 提示訊息顏色
TipColor=162 181 255
# 輸入訊息顏色
InputColor=220 220 220
# 候選字編號顏色
IndexColor=180 180 180
# 第一候選字顏色
FirstCandColor=118 147 255
# 使用者詞彙顏色
UserPhraseColor=255 255 143
# 碼表顏色
CodeColor=255 255 255
# 其他顏色
OtherColor=220 220 220
# 使用中功能表項目的字體顏色
ActiveMenuColor=255 255 255
# 非使用中功能表項目的字體顏色
InactiveMenuColor=178 178 178

[SkinMainBar]
# 背景圖片
BackImg=bar.png
# Logo 圖示
Logo=logo.png
# 英文模式圖示
Eng=en.png
# 使用中模式圖示
Active=cn.png
# 左邊界寬度
MarginLeft=8
# 右邊界寬度
MarginRight=8
# 上邊界寬度
MarginTop=8
# 下邊界寬度
MarginBottom=8
# 可點擊區域的左邊界寬度
#ClickMarginLeft=0
# 可點擊區域的右邊界寬度
#ClickMarginRight=0
# 可點擊區域的上邊界寬度
#ClickMarginTop=0
# 可點擊區域的下邊界寬度
#ClickMarginBottom=0
# Overlay image
#Overlay=
# Overlay dock position
# Available Value:
# TopLeft
# TopCenter
# TopRight
# CenterLeft
# Center
# CenterRight
# BottomLeft
# BottomCenter
# BottomRight
#OverlayDock=TopLeft
# Overlay X offset
#OverlayOffsetX=0
# Overlay Y offset
#OverlayOffsetY=0
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillVertical=Resize
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillHorizontal=Resize
# Use Custom text icon color
# Available Value:
# True False
#UseCustomTextIconColor=False
# Active Text Icon Color
#ActiveTextIconColor=0 0 0
# Inactive Text Icon Color
#InactiveTextIconColor=0 0 0
# 特殊圖示位置
#Placement=

[SkinInputBar]
# 背景圖片
BackImg=input.png
# 左邊界寬度
MarginLeft=10
# 右邊界寬度
MarginRight=10
# 上邊界寬度
MarginTop=10
# 下邊界寬度
MarginBottom=10
# 可點擊區域的左邊界寬度
#ClickMarginLeft=0
# 可點擊區域的右邊界寬度
#ClickMarginRight=0
# 可點擊區域的上邊界寬度
#ClickMarginTop=0
# 可點擊區域的下邊界寬度
#ClickMarginBottom=0
# Overlay image
#Overlay=
# Overlay dock position
# Available Value:
# TopLeft
# TopCenter
# TopRight
# CenterLeft
# Center
# CenterRight
# BottomLeft
# BottomCenter
# BottomRight
#OverlayDock=TopLeft
# Overlay X offset
#OverlayOffsetX=0
# Overlay Y offset
#OverlayOffsetY=0
# 游標顏色
CursorColor=255 255 255
# Position or offset of Preedit
InputPos=0
# Position or offset of LookupTable
OutputPos=0
# 上一頁圖示
BackArrow=prev.png
# 下一頁圖示
ForwardArrow=next.png
# 上一頁圖示
BackArrowX=25
# 下一頁圖示
BackArrowY=10
# 上一頁圖示
ForwardArrowX=15
# 下一頁圖示
ForwardArrowY=10
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillVertical=Resize
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillHorizontal=Resize

[SkinTrayIcon]
# 活動中操作列圖示
Active=active.png
# 非活動中操作列圖示
Inactive=inactive.png

[SkinMenu]
# 背景圖片
BackImg=menu.png
# 上邊界寬度
MarginTop=8
# 下邊界寬度
MarginBottom=8
# 左邊界寬度
MarginLeft=8
# 右邊界寬度
MarginRight=8
# 可點擊區域的左邊界寬度
#ClickMarginLeft=0
# 可點擊區域的右邊界寬度
#ClickMarginRight=0
# 可點擊區域的上邊界寬度
#ClickMarginTop=0
# 可點擊區域的下邊界寬度
#ClickMarginBottom=0
# Overlay image
#Overlay=
# Overlay dock position
# Available Value:
# TopLeft
# TopCenter
# TopRight
# CenterLeft
# Center
# CenterRight
# BottomLeft
# BottomCenter
# BottomRight
#OverlayDock=TopLeft
# Overlay X offset
#OverlayOffsetX=0
# Overlay Y offset
#OverlayOffsetY=0
# Active Menu Color
ActiveColor=50 87 244
# Space Line Color
LineColor=204 204 204
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillVertical=Resize
# 背景填滿規則（垂直）
# Available Value:
# Copy
# Resize
#FillHorizontal=Resize

[SkinKeyboard]
# Virtual Keyboard Image
#BackImg=keyboard.png
# Key Color On Virtual Keyboard
KeyColor=255 255 255
