
clip_copy = function(board) {
  try {
    copy()
  }
  catch(e) {
    abort()
  }
  insert(board, clipboard())
}

clip_paste = function(board) {
  select(board)
  paste()
}
