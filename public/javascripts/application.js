// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    // Popups
    $('#join_link').click(function () {
        $('#join_popup_div').show();
    });
    $('#popup_close').click(function () {
        $('#join_popup_div').hide();
    });

    $(".check_box").click(function () {
        if ($(this).attr('src') == '/images/icons/check_box_arrow.gif') {
            $(this).attr('src', '/images/icons/check_box.gif');
        } else {
            $(this).attr('src', '/images/icons/check_box_arrow.gif');
        }
    });

});

