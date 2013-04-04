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

$(document).ajaxSend(function(e, xhr, options) {
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
});

var st = sidetap();
var browse, chinchin, show_contents;
browse = $('#browse');
chinchin = $('#chinchin');

$("header .menu").on("click",st.toggle_nav);
$('#chinchin a.back').click(function() {
    $('#chinchin a.like').removeClass('liked');
    return st.show_section(browse, {
        animation: 'infromleft'
    });
});

$('#chinchin a.like').click(function() {
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

show_chinchins = function(section, title, url) {
    section.find('h1').text(title);
    section.find('.container').html('<div class="loader"><img src="/assets/ajax-loader.gif" /></div>');
    $.get(url, function() {
        section.find('.container').find('a').click(function() {
            show_chinchin($(this).find('.user-index-box').attr('id'), $(this).find('h3').text());
        });
    });
}

show_chinchins(browse, "Chinchin", "/chinchins.js");

st.stp_nav.find('nav a').click(function() {
    $(this).addClass('selected').siblings().removeClass('selected');
    st.toggle_nav();
    var link_text = $(this).text();
    var title, url;
    if (link_text == 'Your Likes') {
        title = "Your Likes";
        url = "/likes.js";
    } else if (link_text == 'Browse') {
        title = "Chinchin";
        url = "/chinchins.js";
    }  else if (link_text == 'Viewed You') {
        title = "Viewed You";
        url = "/views.js";
    }
    show_chinchins(browse, title, url);
});

// For tabs on profile page

// Wait until the DOM has loaded before querying the document
$(document).ready(function(){
    $('ul.tabs').each(function(){
        // For each set of tabs, we want to keep track of
        // which tab is active and it's associated content
        var $active, $content, $links = $(this).find('a');

        // If the location.hash matches one of the links, use that as the active tab.
        // If no match is found, use the first link as the initial active tab.
        $active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
        $active.addClass('active');
        $content = $($active.attr('href'));

        // Hide the remaining content
        $links.not($active).each(function () {
            $($(this).attr('href')).hide();
        });

        // Bind the click event handler
        $(this).on('click', 'a', function(e){
            // Make the old tab inactive.
            $active.removeClass('active');
            $content.hide();

            // Update the variables with the new link and content
            $active = $(this);
            $content = $($(this).attr('href'));

            // Make the tab active.
            $active.addClass('active');
            $content.show();

            // Prevent the anchor's default click action
            e.preventDefault();
        });
    });
});
