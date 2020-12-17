/* -------------------------------------------
    Don't Starve Together Modkit
    Configure Master Bank

    Jan 1, 2019
   -------------------------------------------
 */

studio.menu.addMenuItem({ name: "Don't Starve Together Modkit\\Configure Master Bank",
    //keySequence: "F12",
    execute: function() {
      var projectPath = studio.project.filePath;
      projectPath = projectPath.substr(0, projectPath.lastIndexOf("/") + 1);
      var banks_prepared_marker = studio.system.getFile(projectPath + "Metadata/Bank/masterbankconfigured.txt");
      if(banks_prepared_marker.exists())
      {
        if(!studio.system.question("Master Bank has already been configured.\n\nReconfigure it only if the bank has issues loading.\n\nContinue?"))
        {
          return;
        }
      }

      if(studio.system.question("This will save your project and configure the Master Bank.\n\nYou only need to do this once.\n\nContinue?"))
      {
        studio.project.save();
        var masterBank = studio.project.lookup("bank:/Master Bank");
        if(masterBank)
        {
          var xmlPath = projectPath + "Metadata/Bank/" + masterBank.id + ".xml";
          var oldFile = studio.system.getFile(xmlPath);
          if(oldFile.exists())
          {
            if(oldFile.open(studio.system.openMode.ReadWrite))
            {
              //Get the old Master Bank metadata file
              var old_metadata = oldFile.readText(100000);
              var new_guid = guid();
              var new_metadata = old_metadata.replace(masterBank.id, new_guid);
              oldFile.close();

              //Create a new Master Bank metadata file
              var newFile = studio.system.getFile(projectPath + "Metadata/Bank/" + new_guid + ".xml");
              if (!newFile.open(studio.system.openMode.WriteOnly)) {    
                alert("Failed to open file {0}\n\nCheck the file is not read-only.".format(projectPath + "Metadata/Bank/" + new_guid + ".xml"));
                console.error("Failed to open file {0}.".format(projectPath + "Metadata/Bank/" + new_guid + ".xml"));
                return;
              }
              else
              {
                if(newFile.writeText(new_metadata) != -1)
                {
                  oldFile.remove();
                  newFile.close();

                  banks_prepared_marker.open(studio.system.openMode.WriteOnly)
                  banks_prepared_marker.writeText("Master Bank has been successfully configured.\n\n New GUID: " + new_guid);
                  banks_prepared_marker.close();

                  alert("Master Bank successfully configured!\n\nPlease re-open FMOD Studio.")
                  var options = { timeout: 100000, args: " ", workingDir: projectPath };
                  studio.system.start(projectPath + "Batch Files\\CloseFMODStudio.bat", options);
                }
                else
                {
                  alert("Configuration failed.\n\nPlease contact Klei support at livesupport@kleientertainment.com")
                  oldfile.close();
                  newfile.remove();
                  return;
                }
              }
            }
          }
          else
          {
            //TODO: How can I help the user if this happens?
            alert("Cannot find Master Bank metadata file:\n \n" + xmlPath + "\n\nPlease contact Klei support at livesupport@kleientertainment.com");
            return;
          }
        }
        else
        {
          alert("Master Bank not found.\n\nPlease check the Banks tab and ensure the project's master bank is named \"Master Bank\" and is not in a folder.");
          return;
        }
      }

    function guid() {
      function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
      }
      return "{" + s4() + s4() + '-' + s4() + '-' + s4() + '-' +
        s4() + '-' + s4() + s4() + s4() + "}";
    }
}});