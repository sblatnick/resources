
clip_copy = function(board) {
  var current = clipboard()
  try {
    copy()
  }
  catch(e) {
    abort()
  }
  insert(board, clipboard())
  copy(current)
}

clip_paste = function(board) {
  var current = clipboard()
  select(board)
  paste()
  copy(current)
}
