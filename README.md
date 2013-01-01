unity-gentoo
============

A Gentoo overlay to install the Unity desktop

####~ # emerge -uDNvta unity-meta

--------------------------------------------------------------

* To add the overlay using layman, do 'layman -a unity-gentoo'

* A list of packages provided by the overlay can be found in:

	*/var/lib/layman/unity-gentoo/PACKAGES*

* This can be used in the following way to have the overlay
	automatically handle unmasking:

	*~ # mkdir -p /etc/portage/package.keywords*

	*~ # ln -s /var/lib/layman/unity-gentoo/PACKAGES /etc/portage/package.keywords/unity-gentoo*

* If you already have an /etc/portage/package.keywords file,
	rename it first to something other than
	'package.keywords' and then copy that renamed file
	into the new /etc/portage/package.keywords/ directory

* A list of packages that are in testing can be found in

	*/var/lib/layman/unity-gentoo/unity-gentoo.raring*

* Packages in testing are masked by missing keyword, to use these packages:

	*~ # ln -s /var/lib/layman/unity-gentoo/unity-gentoo.raring /etc/portage/package.keywords/unity-gentoo.raring*

	- To revert back to 'stable' do the following:

	*~ # rm /etc/portage/package.keywords/unity-gentoo.raring*
