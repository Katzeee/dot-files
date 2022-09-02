#!/bin/bash
if [ -f "/bin/pip" ];
then
	echo "pip exist"
else
	sudo pacman -S python-pip
fi

if $(pip show psutil | grep psutil > /dev/null )
then
	echo "psutil exist"
else
	pip install psutil
fi

make && sudo make install
