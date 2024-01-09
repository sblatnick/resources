
clip_copy = function(board) {
  var current = str(clipboard())
  copy()
  var content = str(clipboard())
  var cb = new File("/dev/shm/clipboard" + board)

  //popup('clip copy', content)
  if (!cb.openWriteOnly() || cb.write(content) == -1) {
    abort()
  }
  cb.close()
  copy(current)
}

clip_paste = function(board) {
  var current = str(clipboard())
  var cb = new File("/dev/shm/clipboard" + board)

  if (!cb.openReadOnly()) {
    abort()
  }
  var content = cb.readAll()
  //popup('clip paste', content)
  copy(content)
  paste()

  cb.close()
  copy(current)
}

enqueue = function(path) {
  if (!copySelection())
    abort()

  var content = str(clipboard())
  popup('enqueue', content)

  var cb = new File(Dir().homePath() + "/" + path)

  if (!cb.openAppend() || cb.write(content + "\n") == -1) {
    abort()
  }
  cb.close()
}
