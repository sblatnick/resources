/*
 * INSTALL
 * 1. Right-click a scripts directory and "Import into note" (Note type: JS frontend)
 * 2. Trilium Menu -> Configure Launchbar -> right click "Visible launcher" tree and "Add a script launcher"
 * 3. set "script" and keyboard shortcut
 * USAGE
 * 1. Go into a Chapter of scripture copied into a note
 * 2. Push the script button or shortcut
 * The script will attempt to duplicate any paragraphs that start with a number into child notes as verses.
 * If you get the verses you want, delete the original text in the parent note.
 *
 * TODO:
 * - Improve regex compatibility for other html entities
 * - Set original note attributes to "#iconClass="bx bx-bible" #viewType=list #expanded"
 * - Allow multiple chapter recursion
 * - Add option to strip out formatting.
 */

let note = await api.getActiveContextNote();
let id = note.noteId;
let content = await note.getContent();
let verses = await api.runOnBackend((id, content) => {
  api.getNote(id).addLabel("cssClass", "verse");
  content = "<p>" + content;
  content = content.replaceAll(' style="margin-left:0px;"', "");
  let lines = content.split(/<p>(?:<[^>]+>)?(?=\d+)/);
  console.log(lines);
  let verses = 0;
  for(let i in lines) {
    //console.log(lines[i]);
    let chapter = lines[i].match(/^(\d+)(<\/sup>)?/);
    if(chapter != null) {
      let prefix = "<p>";
      if(chapter[2]) {
        prefix = "<p><sup>";
      }
      let title = chapter[1];
      let text = prefix + lines[i]
      //console.log("createTextNote(" + id + ", " + title + ", " + text + ")");
      api.createTextNote(id, title, text);
      verses++;
    }
  }
  return verses;
}, [id, content]);
api.showMessage(`Created ${verses} verses`);