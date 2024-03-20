function myFunction() {
    /* Unless you actually read stuff in your spam folder, this should be the same as
    * the number of messages in spam folder.
    */
    Logger.log("# unread threads that are spam: " + GmailApp.getSpamUnreadCount());
  }
  
