/* -------------------------------------------
    Don't Starve Together Modkit
    Build Banks

    Feb 1, 2019
   -------------------------------------------
 */

studio.menu.addMenuItem({ name: "Don't Starve Together Modkit\\Build Banks",
    //keySequence: "F11",
    execute: function() {
      var projectPath = studio.project.filePath;
      projectPath = projectPath.substr(0, projectPath.lastIndexOf("/") + 1);
      
      var banks_prepared_marker = studio.system.getFile(projectPath + "Metadata/Bank/masterbankconfigured.txt");
      if(!banks_prepared_marker.exists())
      {
        alert("Master Bank has not been configured.\n\nPlease run the Configure Master Banks script.")
        return;
      }
      else
      {
        studio.project.build({ platforms: 'Desktop'});
      }
    }
});