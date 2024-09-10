#::::::::::::::::::::PYTHON ENV::::::::::::::::::::
#Methods:
  #venv
    #Create a virtual environment called "name":
      python3 -m name venv
    #enter virtual environment:
      source name/bin/activate
    #enter python shell in that environment:
      python
    #exit virtual environment:
      deactivate

  #virtualenv
    #Install
      pip3 install --upgrade virtualenv
    #Create a virtual environment called "name":
      virtualenv name --python=python3.11
    #enter virtual environment:
      source name/bin/activate
    #enter python shell in that environment:
      python
    #exit virtual environment:
      deactivate

#JupiterLab allows you to run python and shell environments in your browser
