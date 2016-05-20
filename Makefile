SHELL=/bin/bash

# rsync -av --delete spacemacs/.spacemacs "$$HOME"/
# -mkdir -p "$$HOME"/.emacs.d/
# rsync -av --delete spacemacs/private "$$HOME"/.emacs.d/
all:
	stow -R spacemacs -t ~

# pull:
# 	-mkdir -p spacemacs
# 	rsync -av --delete "$$HOME"/.spacemacs spacemacs/
# 	rsync -av --delete "$$HOME"/.emacs.d/private spacemacs/
