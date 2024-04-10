/*
 * Make jira comments always sort by "Oldest first"
 * This keeps the setting even after restarting the browser.
 *
 * 1. Install Chrome extension "User JavaScript and CSS"
 *    https://chromewebstore.google.com/detail/nbhcbdghjpllgmfilhnhkllmkecfmpld
 * 2. Open a page on Jira
 * 3. Create a new rule from the extension button
 * 4. Enable Modules -> Jquery 3
 * 5. Paste the contents of this script in the new rule
 */

$(window).on("load", function() {
  setTimeout(function () {
    if($(".activity-tab-sort-label").html() == "Newest first") {
      $("#sort-button").click()
    }
  }, 1000);
});
