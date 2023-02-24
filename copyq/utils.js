
clip = function(board) {
  var content = ""
  try {
    copy()
    content = str(clipboard())
  } catch (e) { }

  var cb = new File("/dev/shm/clipboard" + board)

  if (content.length == 0) {
    if (!cb.openReadOnly()) {
      abort()
    }
    content = cb.readAll()
    //popup('clip copy', content)
    copy(content)
    paste()
  } else {
    //popup('clip write', content)
    if (!cb.openWriteOnly() || cb.write(content) == -1) {
      abort()
    }
  }
  cb.close()
}