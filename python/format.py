

#f strings: https://realpython.com/python-f-strings/
  # Forward environment variables to mock:
  with open('/etc/mock/' + str(self.config) + '.cfg', 'a') as s:
    s.write('\n')
    s.write('config_opts["files"]["etc/profile.d/environment.sh"] = """'
    for k, v in os.environ.items():
      s.write(f'export {k}={v}')
    s.write('"""')
