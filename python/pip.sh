#::::::::::::::::::::PYTHON PIP::::::::::::::::::::

pip install package

pip install cqlsh #Cassandra Query Language Shell
pip install 'cqlsh>=5.0.1' --force-reinstall

#On mac:
  sudo easy_install pip
  sudo python -m pip install packages
  sudo python -m pip install -r requirements.txt

#requirements file example:
  requests==2.21.0
  scp==0.13.2
  pexpect
  pyyaml

#list installed packages in requirements.txt format:
  pip list

#list installed packages in requirements.txt format:
  pip freeze

#dependencies:
  #pipdeptree for installed dependencies
    #install:
    pip install pipdeptree
    #add to path: ${HOME}/.local/bin
    #show installed and deps:
    pipdeptree -fl
  #without installing from requirements.txt (dependency resolver):
    #https://github.com/ddelange/pipgrip
    #install:
    pip install pipgrip
    pipgrip --tree -r requirements.txt

#alternative to pip:
  poetry #https://github.com/python-poetry/poetry