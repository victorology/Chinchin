function chinchin_dialog(title, message, list, callback) {
	var default_args = {

	}

	var width = $(window).width();
	var height = $(window).height();
	var dialog = $('<div class="dialog_outer"></div>');
	var overlay = $('<div class="dialog_overlay" id="dialog_overlay"></div>')
	var inner = $('<div class="dialog_inner"></div>');
	var header = $('<div class="dialog_title"></div>');
	var content = $('<div class="dialog_message"></div>');
	var buttons = $('<div class="buttons"></div>');

	overlay.css({height: height, width: width}).appendTo('body').fadeIn(100, function() {$(this).css('filter', 'alpha(opacity=50)');});
	dialog.appendTo('body');
	header.append(title).appendTo(inner);
	content.append(message).appendTo(inner);
	inner.append('<div class="container-10px">'+list+'</div>');
	inner.appendTo(dialog);

	inner.append(buttons);
	buttons.append('<div class="dialog_button_ok">'+ 'OK' +'</div>');

	dialog.css("left", ($(window).width() - $('.dialog_outer').width()) / 2 + $(window).scrollLeft() + "px");
	dialog.css("top", (height - dialog.height()) / 2);

	$('.buttons > .dialog_button_ok').click(function() {
		if (callback) {
			var result = [];
			$('#chinchin_dialog_friends_list :checked').each(function() {
				result.push($(this).val());
			});
			callback(result);
		}

		overlay.remove();
		dialog.remove();
	});
}