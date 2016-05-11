SHELL=/bin/bash

all:
	rsync -av --delete spacemacs/.spacemacs "$$HOME"/
	-mkdir -p "$$HOME"/.emacs.d/
	rsync -av --delete spacemacs/private "$$HOME"/.emacs.d/
