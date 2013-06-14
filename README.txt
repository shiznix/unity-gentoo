unity-gentoo
============

A Gentoo overlay to install the Unity desktop

~ # emerge -uDNvta unity-meta

--------------------------------------------------------------

* To add the overlay using layman, do 'layman -a unity-gentoo'

* It is necessary to mask certain packages that would normally be emerged from the main portage tree:

	ln -s /var/lib/layman/unity-gentoo/unity-portage.pmask /etc/portage/package.mask/unity-portage.pmask

* All packages are keyword masked and can be unmasked by entering the following into your package.keywords file:

	*/*::unity-gentoo

* A package keywords file containing a base set of packages for Unity installation is maintained for convenience at /var/lib/layman/unity-gentoo/unity-portage.pkeywords:

	ln -s /var/lib/layman/unity-gentoo/unity-portage.pkeywords /etc/portage/package.keywords/unity-portage.pkeywords

* A package unmask file is maintained at /var/lib/layman/unity-gentoo/unity-portage.punmask:

	ln -s /var/lib/layman/unity-gentoo/unity-portage.punmask /etc/portage/package.unmask/unity-portage.punmask
