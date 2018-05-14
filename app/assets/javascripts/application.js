// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery.turbolinks
//= require bootstrap-sprockets
var loadFile = function(event) {
	var output = document.getElementById('image-preview');
	output.src = URL.createObjectURL(event.target.files[0]);
	output.width = 500;
	output.height = 400;
};

var Append = {};
Append.open = false;

function ClickableCommentsLink(){
	// $('.more-comments').click( function() {
	// 	$(this).on('ajax:success', function(event, data, status,xhr) {
	// 		var postId = $(this).data("post-id");
	// 		$("#comments_" + postId).html(data);
	// 		$("#comments-paginator-" + postId).html("<a id='more-comments'data-post-id=" + postId + "data-type='html' data-remote='true'href='/posts/" + postId + "/comments>show more comments</a>");
	// 		Append.open = true;
	// 		Append.comment = true;
	// 		Append.link = false; // hide more comment link
	// 	});

	// });
	  $('.more-comments').click( function() {
	    $(this).on('ajax:success', function(event) {
	      var postId = $(this).data("post-id");
	      $("#comments_" + postId).html(event.detail[2].responseText);
	      $("#comments-paginator-" + postId).html("<a id='more-comments' data-post-id=" + postId + "data-type='html' data-remote='true' href='/posts/" + postId + "/comments>show more comments</a>");
	    	Append.open = true;
			Append.comment = true;
			Append.link = false; // hide more comment link
	    });
	  });

}

function DestroyComments(){
	$('.delete-comment').click( function() {
		Append.id = $(this).parent().data("id");
		Append.post_id = $(this).parent().data("post-id");
		Append.comment_count = $("#comment_content_" + Append.post_id).data("value");
	});
}

$(document).ready(function() {
	setInterval(reloadNotification,10000);
	ClickableCommentsLink();
	DestroyComments();
	console.log(Append);
	$('.comment_content').focus(function(){
		Append.id = this.id;
		Append.post_id = $(this).data("post-id");
		
		if (Append.comment_count === undefined || isNaN(Append.comment_count)){ 
			Append.comment_count = $(this).data("value");
		}

	console.log($(this).data("value"));
	if(Append.comment_count < 4)
		{ 
			Append.comment = true; Append.link = false;
		}
	else 
		if(Append.comment_count == 4)
			{ 
				Append.comment = false;
				Append.link = true; 
			}
		else if(Append.comment_count > 4)
			{ 
				Append.comment = false;
				Append.link = false; 
			}
	});
	console.log(Append);
});

function findFriend(){
	var searchName = document.getElementsByName("friend_name")[0].value;
	var resultContainer = document.getElementsByClassName("search-results")[0];
	resultContainer.innerHTML = "";
	if(searchName != "")
	{
		var xmlHttpRequest = new XMLHttpRequest();
	xmlHttpRequest.onreadystatechange = function(){
		if(this.readyState == 4 && this.status == 200){
			let users = JSON.parse(this.responseText);
			for(let index in users)
			{
				let item = document.createElement("a");
				item.setAttribute("href","/" + users[index].user_name);
				item.setAttribute("class", "result-item");
				item.innerText = users[index].user_name;
				resultContainer.appendChild(item);
			}
		}
	};

	xmlHttpRequest.open("GET","/search?friend_name=" + searchName);
	xmlHttpRequest.send();
	}
	else
		resultContainer.innerHTML = "";
}
function reloadNotification(){
	
	$.ajax({
		type: 'GET',
		url: '/refresh',
		processData: false,
		contentType: false,
		dataType : 'script'
	});
}
