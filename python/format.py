

#f strings: https://realpython.com/python-f-strings/
  # Forward environment variables to mock:
  with open('/etc/mock/' + str(self.config) + '.cfg', 'a') as s:
    s.write('\n')
    s.write('config_opts["files"]["etc/profile.d/environment.sh"] = """'
    for k, v in os.environ.items():
      s.write(f'export {k}={v}')
    s.write('"""')

#Passing in variables to a string:
  "Number %d string %s object reference %r" % (index, string, self)


print("println in C (trailing newline implicit)")

x = "variable"
#Variable interpolation in string:
print(f"Variable:\n  {x}")

#Multi-line String with variable interpolation:
a = f"""
This is a multi line string
with more than one line and variable = {x}
"""
#Single line string on multiple lines and format in variable:
b = ("Here is a second "
     "multi line string like"
     "this here"
     "because I "
     "can {}".format(x))

