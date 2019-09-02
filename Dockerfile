# A lightweight Alpine-based graphical Python 3 workstation
# Updated on 2019-09-02
# R. Solano <ramon.solano@gmail.com>
#
# Provides:
#	Python3, ipython, jupyter, firefox, spyder, numpy, matplotlib, scipy, pandas, plotly

# For python2, add:
# sudo apk add python python-dev py2-pip py-numpy py-numpy-dev gcc gfortran \
#    freetype-dev libpng-dev build-base libffi-dev  py-gobject
# sudo python2 -m pip install --upgrade pip
# sudo python2 -m pip install matplotlib ipython cairocffi
# sudo apk add py2-scipy
# sudo python2 -m pip install  pandas

FROM rsolano/alpine-vnc

RUN \
	# update sys
	apk update \
	&& apk upgrade \
	#
	# python3 and support for compiling matplotlib
	&& apk add python3 python3-dev py3-numpy py-numpy-dev py-gobject3 \
	gcc gfortran freetype-dev libpng-dev build-base libffi-dev \
	#
	# upgrade pip
	&& sudo python3 -m pip install --upgrade pip \
	#
	# remaining packages (matplotlib, ipython, scipy, pandas, jupyter, plotly, spyder ..)
	&& python3 -m pip install matplotlib ipython cairocffi \
	&& apk add py3-scipy \
	&& python3 -m pip install pandas \
	&& python3 -m pip install jupyter \
	&& apk add firefox-esr \
	&& python3 -m pip install plotly \
	# ?
	&& apk add py3-qt5 py3-qtwebengine \
	&& apk add openssl openssl-dev \
	&& python3 -m pip install spyder
	

# ports (SSH, VNC, Jupyter) 
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
