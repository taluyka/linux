# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo

HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk

typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

autoload -Uz compinit
compinit

zstyle ':completion::complete:*' gain-privileges 1

zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

export VDPAU_DRIVER=radeonsi

alias ls='ls --color=auto'
alias kur='sudo pacman -S'
alias gün='sudo pacman -Syyu'
alias ara='sudo pacman -Ss'
alias kern='sudo mkinitcpio -p linux-zen'
alias codec='sudo pacman -S flac wavpack celt lame a52dec libdca libmad libmpcdec opencore-amr opus speex libvorbis faac faad2 libfdk-aac fdkaac jasper libwebp libavif libheif aom dav1d rav1e svt-av1 libde265 libdv libmpeg2 schroedinger libtheora libvpx x264 x265 xvidcore gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer-vaapi libva-intel-driver libva-mesa-driver mesa-vdpau intel-media-driver amdvlk'
alias refl='sudo reflector --verbose --sort rate --latest 10 --protocol https --save /etc/pacman.d/mirrorlist'
alias tmz='sudo pacman -Scc'
alias sil='sudo pacman -R'
alias sik='sudo pacman -Rscn'
alias defrag='sudo btrfs filesystem defragment -r /'
alias düzr='sudo nano'
alias hata='journalctl -p 3 -xb'
alias kurulum='refl && codec plasma kinit dolphin dolphin-plugins xdg-user-dirs konsole kwrite vvave vlc ktorrent chromium opera opera-ffmpeg-codecs ufw kvantum-qt5 packagekit-qt5 iptables qemu virt-manager dnsmasq bridge-utils ovmf libvirt dmidecode xf86-video-amdgpu xf86-video-intel kamoso gwenview ark && sudo systemctl enable fstrim.timer && sudo systemctl enable sddm && usrmod && ayar && kllnc && sudo systemctl enable libvirtd'
alias usrmod=' sudo usermod -aG kvm,libvirt safa'
alias ayar='sudo cp 60-ioschedulers.rules /etc/udev/rules.d/ && sudo cp 99-swappiness.conf /etc/sysctl.d/'
alias kllnc='sudo chfn -f "Safa İlbars Öztürk" safa'

# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PROMPT="%F{220}%m%f%~> "
