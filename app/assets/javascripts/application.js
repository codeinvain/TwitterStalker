// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  $('form#new_stalk').bind("ajax:success", function(event, data, status, xhr) {
    console.dir(data)
    $("#f1").html("")
    // for (var i=0;i<3;i++){
    //   $.ajax({url:'http://twitter.com/users/'+data[i]+'.json?callback=twitterResponse',method:'get',dataType:'jsonp'},function(data){
    //     console.log(data)
    //   });
    // }
  });
});

// function  twitterResponse(data){
//   var html = '<div class="user_frame">'
//   html+='<span class="title">'+data.name+'</span>'
//   html+='<br/>'
//   html+='<img src="'+data.profile_image_url+'">'
//   html+='</div>'
//   $("#f1").html($("#f1").html()+html)
// }

