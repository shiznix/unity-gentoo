unity-gentoo
============

A Gentoo overlay to install the Unity desktop

~ # emerge -uDNvta unity-meta

--------------------------------------------------------------

* To add the overlay using layman, do 'layman -a unity-gentoo'


* A list of packages provided by the overlay can be found in
	/var/lib/layman/unity-gentoo/PACKAGES
  - This can be used in the following way to have the overlay
	automatically handle unmasking:
	~ # mkdir -p /etc/portage/package.keywords
	~ # ln -s /var/lib/layman/unity-gentoo/PACKAGES \
		/etc/portage/package.keywords/unity-gentoo

  - If you already have an /etc/portage/package.keywords file,
	rename it first to something other than
	'package.keywords' and then copy that renamed file
	into the new /etc/portage/package.keywords/ directory

A list of packages that are in testing can be found in
	/var/lib/layman/unity-gentoo/unity-gentoo.quantal
* Packages in testing are masked by missing keyword
  - To use these packages:
	- Add the gnome overlay 'layman -a gnome'
	- Symlink portage configs from the gnome overlay in
		/var/lib/layman/gnome/status/portage-configs/
	- And do the following:
		~ # ln -s /var/lib/layman/unity-gentoo/unity-gentoo.quantal \
			/etc/portage/package.keywords/unity-gentoo.quantal
		~ # ln -s /var/lib/layman/unity-gentoo/unity-gentoo.quantal.pmask \
			/etc/portage/package.mask/unity-gentoo.quantal.pmask
  - To revert back to 'stable' do the following:
	~ # layman -d gnome
	~ # rm /etc/portage/package.keywords/unity-gentoo.quantal
	~ # rm /etc/portage/package.mask/unity-gentoo.quantal.pmask
