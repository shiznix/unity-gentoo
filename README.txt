unity-gentoo
============

A Gentoo overlay to install the Unity desktop (requires systemd)

--------------------------------------------------------------

* To add the overlay using layman, do 'layman -a unity-gentoo'

* Select one of the unity-gentoo profiles listed with 'eselect profile list'

* emerge -aqv unity-build-env (this package sets all keywords needed for specific Unity version)

* emerge -uDNvta @world (it is recommended at this point to migrate and get systemd working if not already done)

* emerge --backtrack=30 -uDNvta unity-meta

* For questions/support, join us on irc.freenode.net #unity-gentoo
