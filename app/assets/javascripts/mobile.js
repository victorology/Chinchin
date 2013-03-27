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

var st = sidetap();
var browse, chinchin, show_contents;
browse = $('#browse');
chinchin = $('#chinchin');

$("header .menu").on("click",st.toggle_nav);
$('#chinchin a.back').click(function() {
    return st.show_section(browse, {
        animation: 'infromleft'
    });
});

show_chinchin = function(chinchin_id, chinchin_name) {
    chinchin.find('h1').text(chinchin_name);
    st.show_section(chinchin, {
        animation: 'infromright'
    });
    $.get('/chinchins/'+chinchin_id+'.js');
}

show_chinchins = function(section, title, url) {
    section.find('h1').text(title);
    $.get(url, function() {
        section.find('.container').find('a').click(function() {
            show_chinchin($(this).parent().parent().parent().attr('id'), $(this).text());
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