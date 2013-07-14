$( document ).on( "pageinit", "body", function() {
    $( document ).on( "swiperight", "#chinchin", function( e ) {
        // We check if there is no open panel on the page because otherwise
        // a swipe to close the left panel would also open the right panel (and v.v.).
        // We do this by checking the data that the framework stores on the page element (panel: open).
        if ( $.mobile.activePage.jqmData( "panel" ) !== "open" ) {
            $( "#menupanel" ).panel( "open" );
        }
    });
});

var isMobile = {
    Android: function() {
        return navigator.userAgent.match(/Android/i) ? true : false;
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i) ? true : false;
    },
    iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i) ? true : false;
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i) ? true : false;
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows());
    }
};

$(document).ajaxSend(function(e, xhr, options) {
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
});

var st = sidetap();
var browse, chinchin, show_contents;
browse = $('#browse');
chinchin = $('#chinchin');
message_room = $('#message_room');

$("header .menu").on("click",st.toggle_nav);
$('#chinchin a.back').on("click", function() {
    $('#chinchin a.like').removeClass('liked');
    return st.show_section(browse, {
        animation: 'infromleft'
    });
});

$('#message_room a.back').on("click", function() {
    return st.show_section(browse, {
        animation: 'infromleft',
        callback: show_messages(browse, "Messages", "/message_rooms.js")
    });
});

$('#chinchin a.like').on("click", function() {
    var chinchin_id = $('#chinchin').find('.dummy').attr('id')

    if ($('#chinchin a.like').hasClass('liked')) {
        $.post('/unlike.js', {chinchin_id:chinchin_id});
    } else {
        $.post('/likes.js', {chinchin_id:chinchin_id});
    }
});

show_chinchin = function(chinchin_id, chinchin_name) {
    chinchin.find('h1').text(chinchin_name);
    st.show_section(chinchin, {
        animation: 'infromright'
    });
    $('#chinchin').find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get('/chinchins/'+chinchin_id+'.js', function() {
        $.post('/views.js', {viewee_id:chinchin_id});
    });
}

show_message_room = function(message_room_id, message_room_title) {
    message_room.find('h1').text(message_room_title);
    st.show_section(message_room, {
        animation: 'infromright'
    });
    $('#message_room').find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get('/message_rooms/'+message_room_id+'.js');
}

show_chinchins = function(section, title, url) {
    section.find('h1').text(title);
    section.find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get(url, function() {
        section.find('.container').find('a').on("click", function() {
            show_chinchin($(this).find('.profile-click').attr('id'), $(this).find('h2').text());
        });
    });
}

show_chinchin_card = function(section, title, url) {
    section.find('h1').text(title);
    section.find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get(url, function() {
        section.find('.container').find('a').on("click", function() {
            show_chinchin(section.find('.profile-click').attr('id'), section.find('.dummy_name').attr('id'));
        });
    });
}

open_message_room = function(message_room_id) {
    $.ajax({
        url: '/message_rooms/'+message_room_id+'.js',
        type: 'PUT',
        data: {room_action: "open"},
        success: function(response) {
            if (response.status) {
                show_message_room(message_room_id, 'Messages');
            } else {
                alert(response.message);
            }
        }
    });
}

check_message_room = function(message_room_id, message_room_status) {
    if (message_room_status != 1 && message_room_status != 2) {
        var response = confirm('Do you really want to open this message room?');
        if (response) {
            open_message_room(message_room_id);
        }
    } else {
        open_message_room(message_room_id);
    }
}

show_messages = function(section, title, url) {
    section.find('h1').text(title);
    section.find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get(url, function() {
        section.find('.container').find('a').on('click', function() {
            check_message_room($(this).find('.message-room-index-box').attr('id'), $(this).find('.message-room-index-box').attr('class').split(" ")[1].split("-")[3]);
        });
    });
}

show_chinchin_card(browse, "Chinchin", "/chinchins.js");

st.stp_nav.find('nav a').on("click", function() {
    $(this).addClass('selected').siblings().removeClass('selected');
    st.toggle_nav();
    var link_href = $(this).attr('href');
    var link_title = $(this).text();
    var title, url;
    if (link_href == '#my_likes') {
        title = link_title;
        url = "/likes.js";
    } else if (link_href == '#browse') {
        title = "Chinchin";
        url = "/chinchins.js";
        show_chinchin_card(browse, title, url);
        return;
    } else if (link_href == '#notifications') {
        title = link_title;
        url = "/views.js";
    } else if (link_href == '#hot_friends') {
        title = link_title;
        url = "/leaderboards.js";
    } else if (link_href == '#messages') {
        title = link_title;
        url = "/message_rooms.js";
        show_messages(browse, title, url);
        return;
    }
    show_chinchins(browse, title, url);
});

$('#cta-get-started').find('a').on('click', function() {
    $('#cta-get-started').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
});

register_device_token = function(device_token) {
    $.post('/register_device_token', {device_token:device_token})
}

register_apid = function(apid) {
    $.post('/register_apid', {apid:apid})
}