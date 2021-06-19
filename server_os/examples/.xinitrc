#. /usr/local/etc/xdg/xfce4/xinitrc
export QT_QPA_PLATFORMTHEME=qt5ct

export INPUT_METHOD=gcin
export XMODIFIERS='@im=gcin'
export GTK_IM_MODULE=gcin
export GTK3_IM_MODULE=gcin
export QT4_IM_MODULE=gcin
export QT_IM_MODULE=gcin

LANG="en_US.UTF-8" export LANG 
LANGUAGE="zh_TW.UTF-8" export LANGUAGE
LC_CTYPE="zh_TW.UTF-8" export LC_CTYPE 
LC_NUMERIC="zh_TW.UTF-8" export LC_NUMERIC 
LC_TIME="zh_TW.UTF-8" export LC_TIME 
LC_COLLATE="C" export LC_COLLATE 
LC_MONETARY="zh_TW.UTF-8" export LC_MONETARY 
LC_MESSAGES="zh_TW.UTF-8" export LC_MESSAGES 
LC_PAPER="zh_TW.UTF-8" export LC_PAPER 
LC_NAME="zh_TW.UTF-8" export LC_NAME 
LC_ADDRESS="zh_TW.UTF-8" export LC_ADDRESS 
LC_TELEPHONE="zh_TW.UTF-8" export LC_TELEPHONE 
LC_MEASUREMENT="zh_TW.UTF-8" export LC_MEASUREMENT 
LC_IDENTIFICATION="zh_TW.UTF-8" export LC_IDENTIFICATION 
LC_ALL="zh_TW.UTF-8" export LC_ALL

# gcin & VBoxClient --vmsvga & exec xfce4-session
gcin & VBoxClient & exec xfce4-session
