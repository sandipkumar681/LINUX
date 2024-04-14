#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'


#customCommands



alias 0='shutdown now'
alias 0r='shutdown -r now'
alias 1='sudo pacman -Syu && echo "YOUR SYSTEM IS UPTO-DATE" '
alias 2='sudo pacman -Sc'
alias 3='sudo sh -c "echo 1 >  /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE" '
alias 4='sudo sh -c "echo 3 >  /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE & UNUSED RAM SPACE" '
#To clean pacman cache
alias 5='cd /var/cache/pacman/ && sudo rm -r pkg/ && sudo mkdir pkg && echo "pacman is clean" && cd ~/ '
alias 9='sudo bleachbit -c system.cache system.localizations system.trash system.tmp'
alias d='df -Th'
#To Create or Copy webDevlopment File
alias htmlCreate='touch index.html style.css 01.js && htmlOpen'
alias cpHtml='echo "CHOOSE THE DESTINATION" && read destination && cp ~/htmlBoilerPlate/index.html  ~/htmlBoilerPlate/01.js  ~/htmlBoilerPlate/style.css    ~/Desktop/$destination && cd ~/Desktop/$destination && htmlOpen'
alias htmlOpen='code index.html style.css 01.js'
#To Create JAVA File
alias javaCreate='touch test1.java test2.java test3.java test4.java'
#To compile JAVA's class file in same folder 
alias javaCompile='javac -d . *.java'
#For gnome-text-editor
alias editor='gnome-text-editor'
#For systemctl
alias SS='sudo systemctl'
#To enable or disable wifi
alias wifi=' sudo nmcli radio wifi'
#To enable or disable bluetooth
alias enableBluetooth='sudo systemctl enable bluetooth.service'
alias disableBluetooth='sudo systemctl disable bluetooth.service'
#For pacman
alias p='sudo pacman'
PS1='[\u@\h \W]\$ '
