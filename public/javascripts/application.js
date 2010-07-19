// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    // Popups
    $('#join_link').click(function () {
        $('#join_popup_div').show();
        $('#join_popup_div').tabs('select', 0);
        return false;
    });
    $('.popup_close').click(function () {
        $('#join_popup_div').hide();
        return false;
    });

    $(".check_box").click(function () {
        if ($(this).attr('src') == '/images/icons/check_box_arrow.gif') {
            $('#user_type_id').attr('value', '');
            $(this).attr('src', '/images/icons/check_box.gif');
        } else {
            $('.user_type_check_box').attr('src', '/images/icons/check_box.gif');
            $('#user_type_id').attr('value', $(this).attr('id'));
            $(this).attr('src', '/images/icons/check_box_arrow.gif');
        }
    });

    $('#login_link').click(function() {
      $('#join_popup_div').show();
      $('#join_popup_div').tabs('select', 3);
      return false;
    });

    $('#join_popup_div').tabs();

    $('#step_1_next_button').click(function() {
      $('#join_popup_div').tabs('select', 1);
    });
    $('#step_2_back_button, #sign_up_link').click(function() {
      $('#join_popup_div').tabs('select', 0);
      return false;
    });
    $('#step_2_next_button').click(function() {
      $('#join_popup_div').tabs('select', 2);
    });
    $('#step_3_back_button').click(function() {
      $('#join_popup_div').tabs('select', 1);
    });

});

