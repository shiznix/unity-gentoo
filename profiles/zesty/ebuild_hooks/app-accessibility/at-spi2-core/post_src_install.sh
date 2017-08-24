# Enable QT4 and QT5 accessibility by default #
dest="${D}"/etc/X11/xinit/xinitrc.d
install -d "${dest}"
install -m0755 "${HOOK_SOURCE}"/90qt-a11y "${dest}"
