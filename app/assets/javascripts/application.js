// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


// var orig_border = null;

function demo_multiple_users(){
  demo_str = ',danielissimo'
  index= 0;
  orig_border = $("#q").css('border')
  $("#q").css('border','1px solid pink')
  text_input_mock(demo_str,index);
}

function text_input_mock(demo_str,index){
  char = demo_str.charAt(index)
  val = $('#q').val();
  $('#q').val(val+char);
  if (index<demo_str.length-1){
    index++
    setTimeout(text_input_mock,100,demo_str,index)
  }else{
    $("#q").css('border',orig_border);
    $(".notice").css('opacity','0')
    inc = 0
    flash_button(0,100)
    setTimeout(auto_redirect,2000)
  }
}

function auto_redirect(){
  window.location = "/?utf8=✓&q="+$("#q").val()
}

function flash_button(increment,timeout){
  var color = (increment%2==0) ? 'pink' : '#5CAED7';
  $("#submit").css('border-color',color);
  increment++
  setTimeout(flash_button,timeout,increment,timeout)
}
function intersect(name){
  _gat._getTrackerByName()._trackEvent('Action Button','narrow search');
  setTimeout('window.location = "' + "/?utf8=✓&q="+$("#q").val()+","+name+ '"', 100);
  return false;
}

function remove(name){
  _gat._getTrackerByName()._trackEvent('Action Button','expand search');
  var next_url =window.location.href.replace(name,'').replace(',,',',').replace('=,','=') 
  setTimeout('window.location = "' +next_url+ '"', 100);
  return false;
}


