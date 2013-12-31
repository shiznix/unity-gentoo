- Rhythmbox 3.0 depends on python3 with 'PYTHON_SINGLE_TARGET'
  * 'unity-base/rhythmbox-ubuntuone' depends on python2
    there exists a patch to get 'unity-base/rhythmbox-ubuntuone' itself python3 compatible, but not all of its dependencies. e.g. 'dev-python/twisted-core' -> 'dev-python/pygtk'
