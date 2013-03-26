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
$("header .menu").on("click",st.toggle_nav);

var browse, chinchin, show_contents;
browse = $('#browse');
chinchin = $('#chinchin');

show_chinchin = function(chinchin_id) {
    st.show_section(chinchin, {
        animation: 'infromright'
    });
    $.get('/chinchins/'+chinchin_id+'.js');
}

show_chinchins = function(section, title, url) {
    section.find('h1').text = (title);
    $.get(url, function() {
        section.find('.container').find('a').click(function() {
            show_chinchin($(this).parent().parent().parent().attr('id'));
        });
    });
}

show_chinchins(browse, "Chinchin", "/chinchins.js");