# Alpine VNC+SSH+Python3

A lightweight [Alpine](https://hub.docker.com/_/alpine)-based personal Python workstation. Provides VNC + SSH + Python w/main engineering module + Python IDE.

Based on [rsolano/alpine-slim-vnc](https://hub.docker.com/r/rsolano/alpine-slim-vnc) image.

*Ramon Solano <<ramon.solano@gmail.com>>*

**Last update:** Sep/2/2019   
**Alpine version:** 3.10

## Main packages

* VNC, SSH (Inherited from rsolano/alpine-slim-vnc)
* Python 3
	* Modules: Numpy, Matplotlib, Pandas, SciPy, Plotly
* IPython
* Jupyter Notebook
* Spyder IDE
* Firefox

## Users

User/pwd:

* root/alpine
* alpine/alpine (sudoer)

## To build from `Dockerfile`

If you want to customize the image or use it for creating a new one, you can download (clone) it from the [corresponding github repository](https://github.com/rwildcat/docker_alpine-vnc-python). 

```sh
# clone git repository
$ git clone https://github.com/rwildcat/docker_alpine-vnc-python.git

# build image
$ cd docker_alpine-slim-vnc
$ docker build -t rsolano/alpine-vnc-python .
```

Otherwise, you can *pull it* from its [docker hub repository](https://cloud.docker.com/u/rsolano/repository/docker/rsolano/alpine-vnc-python):

```
$ docker pull rsolano/alpine-vnc-python
```

**NOTE:** If you run the image without downloading it first (*e.g.* with `$docker run ..`), Docker will *pull it* from the docker repository for you if it does not exist in your local image repository.


## To run then container

To run a simple, ephemeral VNC-only session on display :0 (port 5900):

```sh
$ docker run --rm -p 5900:5900] rsolano/alpine-vnc-python
```

## Full Syntax

```sh
$ docker run [-it] [--rm] [--detach] [-h HOSTNAME] [-p LVNCPORT:5900] [-p LSSHPORT:22] [-p LNOTEBOOKPORT:8888] [-v LDIR:DIR] [-e XRES=1280x800x24] rsolano/alpine-vnc-python [command]
```

where:

* `LVNCPORT`: Localhost VNC port to connect to (e.g. 5900 for display :0).

* `LSSHPORT`: local SSH port to connect to (e.g. 2222, as *well known ports* (those below 1024) may be reserved by your system).

* `XRES`: Screen resolution and color depth.

* `LNOTEBOOKPORT`: Local HTTP Jupyter Notebook port to connecto to (e.g. 8888). Requires IP=0.0.0.0 when running Jupyter in your container for connecting from your locahost, otherwise IP=127.0.0.1 for internal access only.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/alpine/workspace`.

* `command`: shell command to run in container


### Examples

* Run the container, keep terminal open (default); remove container from memory once finished the container (`--rm`); map local VNC to 5900 (`-p 5900:5900`) and local SSH to 2222 (`-p 2222:22`):

	```sh
	$ docker run --rm -p 5900:5900 -p 2222:22 rsolano/alpine-vnc-python
	```

* Run image, keep terminal open (default)); remove container from memory once finished  (`--rm`); map VNC to 5900 (`-p 5900:5900`) and SSH to 2222 (`-p 2222:22`), map Jupyter Notebooks to 8888 (`-p 8888:8888`); mount local $HOME/workspace on container's /home/alpine/workspace (`-v $HOME/workspace:/home/alpine/workspace`):

	```sh
	$ docker run -it --rm -p 5900:5900 -p 2222:22 -p 8888:8888 -v $HOME/workspace:/home/alpine/workspace rsolano/alpine-vnc-python
	```

* Run image, keep *console* open (non-interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, map Jupyter Notebooks to 8888:

	```sh
	$ docker run --rm -p 5900:5900 -p 2222:22  -p 8888:8888 rsolano/alpine-vnc-python
	```

* Run image, detach to background and keep running in memory (control returns to user immediately); map VNC to 5900 and SSH to 2222; map Jupyter Notebooks to 8888; change screen resolution to 1200x700x24

	```sh
	$ docker run --detach -p 5900:5900 -p 2222:22 -p 8888:8888 -e XRES=1200x700x24 rsolano/alpine-vnc-python
	```



#### To run a ***secured*** VNC session

This container is intended to be used as a *personal* graphic workstation, running in your local Docker engine. For this reason, no encryption for VNC is provided. 

If you need to have an encrypted connection as for example for running this image in a remote host (*e.g.* AWS, Google Cloud, etc.), the VNC stream can be encrypted through a SSH connection:

```sh
$ ssh [-p SSHPORT] [-f] -L 5900:REMOTE:5900 alpine@REMOTE sleep 60
```
where:

* `SSHPORT`: SSH port specified when container was launched. If not specified, port 22 is used.

* `-f`: Request SSH to go to background afte the command is issued

* `REMOTE`: IP or qualified name for your remote container

This example assume the SSH connection will be terminated after 60 seconds if no VNC connection is detected, or just after the VNC connection was finished.

**EXAMPLES:**

* Establish a secured VNC session to the remote host 140.172.18.21, keep open a SSH terminal to the remote host. Map remote 5900 port to local 5900 port. Assume remote SSH port is 22:

	```sh
	$ ssh -L 5900:140.172.18.21:5900 alpine@140.172.18.21
	```

* As before, but do not keep a SSH session open, but send the connecction to the background. End SSH channel if no VNC connection is made in 60 s, or after the VNC session ends:

	```sh
	$ ssh -f -L 5900:140.172.18.21:5900 alpine@140.172.18.21 sleep 60
	```

Once VNC is tunneled through SSH, you can connect your VNC viewer to you specified localhot port (*e.g.* port 5900 as in this examples).



## To stop container

* If running an interactive session:

  * Just press `CTRL-C` in the interactive terminal.

* If running a non-interactive session:

  * Just press `CTRL-C` in the console (non-interactive) terminal.


* If running *detached* (background) session:

	1. Look for the container Id with `docker ps`:   
	
		```
		$ docker ps
		CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                          NAMES
		ac46f0cf41d1        rsolano/alpine-vnc-python   "/usr/bin/supervisor…"   58 seconds ago      Up 57 seconds       0.0.0.0:5900->5900/tcp, 0.0.0.0:2222->22/tcp   wizardly_bohr
		```

	2. Stop the desired container Id (ac46f0cf41d1 in this case):

		```sh
		$ docker stop ac46f0cf41d1
		```

 ## Container usage
 
1. First run the container as described above.

2. Connect to the running host (`localhost` if running in your computer):

	* Using VNC (workstation general access): 

		Connect to specified LVNCPORT (e.g. `localhost:0` or `localhost:5900`)
		 
	* Using SSH: 

		Connect to specified host (e.g. `localhost`) and SSHPORT (e.g. 2222) 
		
		```sh
		$ ssh -p 2222 alpine@localhost
		```
	* Using Web browser (Jupyter Notebook general access): 

		Connect to host computer (e.g. your localhost) and specified LVNCPORT (e.g. 8888):
		
		```http://localhost:8888```