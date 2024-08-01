const template = `<div id="my-widget"><button class="tree-floating-button bx bxs-magic-wand tree-settings-button"></button></div>`;

class MyWidget extends api.BasicWidget {
    get position() {return 1;}
    get parentWidget() {return "left-pane"}

    doRender() {
        this.$widget = $(template);
        this.cssBlock(`#my-widget {
            position: absolute;
            bottom: 40px;
            left: 60px;
            z-index: 1;
        }`);
        this.$widget.find("button").on("click", scripturize);
        return this.$widget;
    }
}

module.exports = new MyWidget();

async function scripturize() {
  let note = await api.getActiveContextNote();
  let id = note.noteId;
  let content = await note.getContent();
  let verses = await api.runOnBackend((id, content) => {
    //let content = api.getNote(id).getContent()
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
  api.showMessage(`Created ${verses} verses`)
}

scripturize();
