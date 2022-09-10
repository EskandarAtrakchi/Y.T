function updateTitle() {
  
  var videoID = 'xxxxxxxxx'; //https://youtu.xxxxxxxx
  var part = 'snippet,statistics';
  var params = {'id': videoID};
  
  var response = YouTube.Videos.list(part, params);
  var video = response.items[0];
  
  var channelID = 'xxxxxxxxxxxxxxxxxxx' ; //https://www.youtube.com/xxxxxxxxxxxxxx
  var part2 = 'snippet,contentDetails,statistics';
  var params2 = {'id': channelID};
  var response2 = YouTube.Channels.list(part2, params2);
  var channel = response2.items[0];
  var subscribers = channel.statistics.subscriberCount;
  var views = channel.statistics.viewCount;
  
  var videoTitle = 'Thank You For ' + subscribers + ' Subscribers and ' + views + ' Views!';
  
  video.snippet.title = videoTitle;
  
  try{
    YouTube.Videos.update(video, part);
    
  }catch(e){
    
  
  }
  
}
