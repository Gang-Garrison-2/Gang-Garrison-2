// checkForDevMessages(host, path)
// this script downloads a text file off the internet, and parses it for instructions
// from the developers
// If any are found, they will be shown/executed/whatever

// argument0 - host: web host to connect to (e.g. "www.mysite.com")
// argument1 - path: rest of the path in the address (e.g. "/myfolder/mytextfile.txt")

{
var devMessagesBuffer;
devMessagesBuffer = createbuffer();

var sockId;
sockId = tcpconnect(argument0, 80, 0);
if(sockId)
{

  var CRLF, LF, CR;
  CR = chr(13);
  LF = chr(10);
  CRLF = CR + LF;

  setformat(sockId, 1, CRLF);

  clearbuffer(devMessagesBuffer);
  writechars("GET " + argument1 + " HTTP/1.0" + CRLF, devMessagesBuffer);
  writechars("Host: " + argument0 + CRLF, devMessagesBuffer);
  sendmessage(sockId, 0, 0, devMessagesBuffer);

  setformat(sockId, 2, "");
  var retVal;
  retVal = "";
  while(1)
  {
    size = receivemessage(sockId, 6000, devMessagesBuffer);
    if(size > 0)
      retVal += readchars(size, devMessagesBuffer);
    else break;
  }

  closesocket(sockId);
  
  // find where the header ends, so we can chop it off
  // and just return the important stuff
  
  var headerlength;
  headerlength = string_pos(CRLF + CRLF, retVal) + 2 * string_length(CRLF);
  if(headerlength == 0) {
    retVal = ""
  } else {
    retVal = string_copy(retVal, headerlength, string_length(retVal) - headerlength + 1);
  }
  
  // split the retVal into multiple lines, so we can process them
  var messageArray, a, b;
  for(a = 0; string_pos(LF, retVal) != 0; a += 1) {
    b = string_pos(LF, retVal);
    messageArray[a] = string_copy(retVal, 1, b - 1);
    // remove a possible CR at the end, if the newline happened to be a CRLF instead of just a LF
    if(string_char_at(messageArray[a], string_length(messageArray[a])) == CR)
      messageArray[a] = string_copy(messageArray[a], 1, string_length(messageArray[a]) - 1);
    retVal = string_copy(retVal, b + string_length(LF), string_length(retVal) - b - string_length(LF) + 1);
  }
  messageArray[a] = retVal;
  a += 1;
  
  var c;
  for(c = 0; c < a; c += 1) {
    switch(messageArray[c]) {
      case "ShowMessage":
        c += 1;
        show_message(messageArray[c]);
      break;
      case "Version":
        c += 1;
        versioncheck = (messageArray[c]);
        versionend = string_pos("!",versioncheck);
        version = string_copy(versioncheck,1,versionend-1);
        changeslength = string_length(versioncheck)-versionend;
        changes=string_copy(versioncheck,versionend+1,changeslength);
        if real(version) > VERSION {
        update=show_message_ext("Updates have been made to Gang Garrison 2!##"+changes,"Update","Cancel","");
            if (update == 1){
            execute_shell("gg2updater.exe","");
            game_end();
            }
        }
      break;
      default:
      break;
    }
  }

}
}
