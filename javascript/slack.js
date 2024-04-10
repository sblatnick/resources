/*
 * Steps:
 * 1. Install these Chrome Extensions:
 * - Always Show Slack Workspace Switcher Sidebar: https://chromewebstore.google.com/detail/always-show-slack-workspa/diebigeemhcipelnipggjihcmgjlacge
 * - User JavaScript and CSS: https://chromewebstore.google.com/detail/nbhcbdghjpllgmfilhnhkllmkecfmpld
 * 2. Open https://app.slack.com/client/
 * 3. Create a new rule from the extension button
 * 4. Enable Modules -> Jquery 3
 * 5. Paste the contents of this script in the new rule
 */

update = function(selector) {
  var obj = $(selector);
  if(obj.length > 1) {
    obj.first().remove()
  }
}


fix = function() {
  setTimeout(function() {
    $(".p-workspace_switcher_prototype button").on("click", fix);
    $(".p-workspace_switcher_prototype")
      .append($(".p-tab_rail").css("width", "100%"))
      .append($(".p-control_strip").css("left", "0px"));
    $(".p-client_workspace_wrapper").css("grid-template-columns", "0px auto");
    update(".p-tab_rail");
    update(".p-control_strip");
  }, 100);
}

$(window).on("load", function() {
  fix();
});

/*
 * 6. Open Vivaldi/Chrome in App mode:
 *   vivaldi --app=https://app.slack.com/client/
 */
