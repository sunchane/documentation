# 這是 Archlinux 影片安裝小筆記

* Archlinux、 sshd、 ntpd、 samba48、 mate、 fcitx、 chromium、 思源黑體、 gvim、 emacs

## 1. 下載最新 archlinux-2019.03.01-x86_64.iso

## 2. 示範用 VMware 安裝, archfi 安裝 Base 因為單純所以不做說明。
* grub 開機等議題太長篇大論，目的是架設 Archlinux 在 Windows 上的開發環境，本文是使用 VMware。
* 一般使用者最好先加入 wheel group 這樣就可以 su 成 root，不過這種方式並不安全，建議安裝 sudo。
 
* 安裝光碟下載以後，創一個虛擬系統。
 
	wget archfi.sf.net/archfi
	sh archfi	
	最好要設定 安裝 mirror 不然會很慢

	安裝 yay （未來很多 AUR 套件）
	安裝 samba smbclient (選項內)
	安裝 xorg xorg-fonts-misc (選項內)
	安裝 xf86-video-vmware (選項內)
	安裝 mate mate-terminal (選項內)
	安裝 chromium 
	設定 Acounts sudoer

## 8. 重新開機 這時候應該可以看到登入畫面
 用一般使用者登入操作桌面，root 登入的話有時後會不能執行一些程式 像 chromium。
 稍微修改 滑鼠太快、解析度大小。
 
	ip addr (顯示目前 IP)

* 3. 設定 sshd 以便 Windows 下能夠用 cmdr 等終端機程式操作 （畫面太小）。
	
	(用 cmder 登入一般使用者 ssh)
	sudo nano /etc/ssh/sshd.conf
 
	PermitRootLogin yes

	sudo systemctl restart sshd.service
	(這時候就可以用 cmder 登入 root 的 ssh 了)

## 9. 安裝字型 其實不用安裝一大堆套件 所以選用兩種自己安裝的字型
 思源黑體 （會缺字但是比文泉驛正黑體美觀，可以設定為系統字體跟網頁字體。）
 文泉驛正黑體 （不缺字，加裝後不會有方塊字。）
 
	在一般使用者登入的情況下
	mkdir ~/.fonts
	cd ~/.fonts
	wget https://github.com/vuleetu/.fonts/raw/master/wqy-zenhei.ttc
	wget https://github.com/blockstack/blockstack.js/raw/master/docs/assets/fonts/OTF/SourceCodePro-Regular.otf
	wget https://github.com/tkiapril/source-fonts/raw/master/SourceHanSansTW-Regular.otf
	
	這時候應該可以看到字型了。
	

## 10. 安裝 Samba, 因為套件內沒有 smb4.conf 的 Example, 所以要用 cmdr 終端複製貼上。

	nano /etc/samba/smb.conf
	修改 smb4.conf
 
* 參考設定網址：https://github.com/samba-team/samba/blob/master/examples/smb.conf.default

	pdbedit -a -u 使用者名稱
 
	testparm
	systemctl restart smb.service
	systemctl restart nmb.service
	
	這時候應該就可以在 Windows 的網路上的芳鄰看到了
 
## 11. 安裝輸入法 fcitx
	pacman -S fcitx-im fcitx-configtool fcitx-chewing	
 
## 12. 修改語系、設定桌面環境登入管理
	nano /etc/profile
	加入
 
*	LANG="zh_TW.UTF-8"; export LANG
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
 
	nano ~/.xprofile
	加入（/home/使用者/.xprofile 也要,另外登入一般使用者加入。）
 
	export XMODIFIERS='@im=fcitx' 
	export GTK_IM_MODULE=fcitx
	export GTK3_IM_MODULE=fcitx
	
	這時候重新登入 mate 就可以使用輸入法了，可以改變一下輸入法的外觀。

## 13.　現在桌面已經很美化了，可以用　ｒｏｏｔ　安裝其他軟體了（用　ｃｍｄｒ　等　ｓｓｈ　終端機登入比較好，只是要安裝程式）。

*	pacman -S gvim emacs
 
## 14. 其他
	設定 Vim
	cd /usr/share/vim/vim81/colors/
	https://www.vim.org/scripts/download_script.php?src_id=9771
	
*	可以使用 Filezilla 把檔案先傳到 FreeBSD
	接著一般使用者目錄編輯 .vimrc
	
	ee ~/.gvimrc
	
	sh archdi 裡面也有 VS Code 也許不錯，但是 Linux 還是 emacs vim 較傳統。

	感謝您的收看
	
	
	
	
.gvimrc

:set encoding=utf-8
:set fileencodings=utf-8,cp950
:syntax enable
:colorscheme darkspectrum

:set helplang=tw

:set guifont=Source\ Code\ Pro\ 16
