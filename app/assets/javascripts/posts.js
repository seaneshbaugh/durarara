var refreshPostsTimeoutID;

var refreshPosts = function() {
	$.get("/", { latest_post_id: $("#latest_post_id").val() }, function(data, textStatus, jqXHR) {
		// console.log(jqXHR);
	}, "script");

	refreshPostsTimeoutID = setTimeout(refreshPosts, 10000);
};

$(function() {
	refreshPostsTimeoutID = setTimeout(refreshPosts, 10000);

	$("#new_post").on("submit", function(event) {
		event.preventDefault();

		if ($("#post_subject").val() === "") {
			$("#notice").text("You cannot post without a subject!").fadeIn(500).fadeOut(8000);
		} else {
			if ($("#post_body").val() === "") {
				$("#notice").text("You cannot post without a body!").fadeIn(500).fadeOut(8000);
			} else {
				$.post($(this).attr("action"), $(this).serialize(), function(data, textStatus, jqXHR) {
					// console.log(jqXHR);
				}, "script");
			}
		}
	});
});