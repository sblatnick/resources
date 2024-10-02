/*
 * INSTALL
 * 1. Right-click a scripts directory and "Import into note" (Note type: JS frontend)
 * 2. Add to Owned Attributes #run=frontendStartup

 * USAGE
 * Use keyboard shortcuts to highlight/format text
 *
 * Special Thanks to https://github.com/zadam/trilium/issues/2954#issuecomment-1672431589
 */

//Define:
  let mapping = {
    "Formatting removed": {
      action: "removeFormat",
      value: null,
      shortcut: "ctrl+0"
    },
    "Code": {
      action: "code",
      value: null,
      shortcut: "ctrl+`"
    },
    "Highlight yellow": {
      action: ["fontColor", "fontBackgroundColor"],
      value: ["black", "#F7F700"],
      shortcut: "ctrl+."
    },
    "Highlight green": {
      action: ["fontColor", "fontBackgroundColor"],
      value: ["black", "#9f3"],
      shortcut: "ctrl+1"
    },
    "Highlight red": {
      action: ["fontColor", "fontBackgroundColor"],
      value: ["black", "#ff5050"],
      shortcut: "ctrl+2"
    },
    "Highlight blue": {
      action: ["fontColor", "fontBackgroundColor"],
      value: ["black", "#6365ff"],
      shortcut: "ctrl+3"
    },
  };

//Utils:
  async function apply(note, action, value) {
    let editor = await api.getActiveContextTextEditor();
    if (Array.isArray(action)) {
      for (let i = 0; i < action.length; i++) {
        editor.execute(action[i], {value: value[i]});
      }
    }
    else {
      editor.execute(action, {value: value});
    }
    api.showMessage(note);
  }

//Initialize
  const entries = Object.entries(mapping);
  for (let [key,value] of entries) {
    api.bindGlobalShortcut(value.shortcut, function() { apply(key, value.action, value.value) });
  }

/*
//Headings
  async function text_set_paragraph() {
    let editor = await api.getActiveContextTextEditor();
    editor.execute('heading', {value:'paragraph'}) //heading2, heading3, heading4, heading5
  }
  api.bindGlobalShortcut('ctrl+1', text_set_paragraph);

//Font size
  async function text_size_tiny() {
    let editor = await api.getActiveContextTextEditor();
    editor.execute('fontSize', { value: 'tiny'}); //small, default, big, huge
  }
  api.bindGlobalShortcut('ctrl+alt+shift+a', text_size_tiny);
*/
