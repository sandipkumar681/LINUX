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
alias 1='sudo pacman -Syu'
alias 2='sudo pacman -Sc | lc'
alias 3='sudo sh -c "echo 1 >  /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE" | lc'
alias 4='sudo sh -c "echo 3 >  /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE & UNUSED RAM SPACE" | lc'
#To clean pacman cache
alias 5='echo "IF ROOT PARTITION IS FULL THEN PROCEED. IF NOT THEN PLEASE ENTER "Ctrl + C"" |lc  && read something && cd /var/cache/pacman/ && sudo rm -r pkg/ && sudo mkdir pkg && echo "pacman is clean" | lc && cd ~/'
alias 9='sudo bleachbit -c system.cache system.localizations system.trash system.tmp'
alias d='df -Th | lc'
#To Create or Copy webDevlopment File
alias htmlCreate='pwd && echo "CHOOSE THE DESTINATION" | lc && read destination && cp ~/htmlBoilerPlate/index.html ~/htmlBoilerPlate/style.css ~/htmlBoilerPlate/01.js ~/Desktop/$destination && cd ~/Desktop/$destination && htmlOpen'
alias htmlOpen='code index.html style.css 01.js'
#To Create JAVA File
alias javaCreate='touch mainClass1.java mainClass2.java mainClass3.java mainClass4.java && javaOpen '
#To compile JAVA's class file in same folder 
alias javaPackage='javac -d . *.java'
alias javaOpen='code mainClass1.java mainClass2.java mainClass3.java mainClass4.java'
#For gnome-text-editor
alias editor='gnome-text-editor'
#For systemctl
alias SS='sudo systemctl'
#To enable or disable wifi
alias wifi='nmcli radio wifi'
#To enable or disable bluetooth
alias enableBluetooth='sudo systemctl enable bluetooth.service'
alias disableBluetooth='sudo systemctl disable bluetooth.service'
#For pacman
alias p='sudo pacman'
alias lc='lolcat'
alias 7='sudo chmod 777 PERSIONAL/ && sudo chown cupidust:users -R PERSIONAL/'
alias 7s='sudo chmod 600 PERSIONAL/ && sudo chown -R root: PERSIONAL/'
alias la='ls -al'
alias Info='a=100
reset
while [ $a -gt 0 ];
do
echo "Hey CUPIDUST! 🌞 Sending you a burst of positivity and good vibes! I hope this message finds you smiling and ready to conquer the day. No matter what lies ahead, remember you have got this! Here is to making today amazing!"|pv -qL 10 |lc && reset
((a--))
sleep 0.5
done'
PS1='[\u@\h \W]\$ '
export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]> '
