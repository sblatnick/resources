/*
 * Like cutIntoNote, but take the selected text and make it a Trilium link to a child note of the same title.
 *
 * INSTALL
 * 1. Right-click a scripts directory and "Import into note" (Note type: JS frontend)
 * 2. Trilium Menu -> Configure Launchbar -> right click "Visible launcher" tree and "Add a script launcher"
 * 3. set "script" and keyboard shortcut
 *
 * USAGE
 * 1. Highlight text you want to be made into a link
 * 2. Push the script button or shortcut
 *
 * This is similar to manually:
 * 1. Add link (Ctrl+L)
 * 2. select "Create and link child note"
 * 3. press enter
 *
 */
const note = await api.getActiveContextNote();
if(note.type != "text" ) {
  throw new Error('Can only create subnotes in text notes');
}

const editor = await api.getActiveContextTextEditor();
const selected = editor.getSelectedHtml();
if(selected == '') {
  throw new Error('Must select text to title subnote');
}

const id = note.noteId;
const path = await api.runOnBackend((id, selected) => {
  const created = api.createTextNote(id, selected, "");
  const child = api.getNote(created.note.noteId);
  return child.getBestNotePathString();
}, [id, selected]);
editor.execute('link', `#${path}`)
api.showMessage(`Created note: ${selected}`);
