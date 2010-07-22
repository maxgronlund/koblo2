// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    // Popups
    $('#join_link, #edit_profile').click(function () {
        $('#join_popup_div').show();
        $('#join_popup_div').tabs('select', 0);
        return false;
    });
    $('.popup_close').live('click', function () {
        $('#join_popup_div').hide();
        return false;
    });

    // Check and uncheck user type check boxes
    $(".check_box").live('click', function () {
        if ($(this).attr('src') == '/images/icons/check_box_arrow.gif') {
            $('#user_user_type_id').attr('value', '');
            $(this).attr('src', '/images/icons/check_box.gif');
        } else {
            $('.user_type_check_box').attr('src', '/images/icons/check_box.gif');
            $('#user_user_type_id').attr('value', $(this).attr('id'));
            $(this).attr('src', '/images/icons/check_box_arrow.gif');
        }
    });

    // Show the login dialog
    $('#login_link').click(function () {
        $('#join_popup_div').show();
        $('#join_popup_div').tabs('select', 3);
        return false;
    });

    // Update the user name in the second page of the profile with the input field on the first page
    $('#user_name').live('change', function () {
        $('.user_name').html($(this).val());
    });

    // Tabs and navigation
    $('#join_popup_div').tabs();
    $('#step_1_next_button').live('click', function () {
        $('#join_popup_div').tabs('select', 1);
    });
    $('#step_2_back_button, #sign_up_link').live('click', function () {
        $('#join_popup_div').tabs('select', 0);
        return false;
    });
    $('#step_2_next_button').live('click', function () {
        $('#join_popup_div').tabs('select', 2);
    });
    $('#step_3_back_button').live('click', function () {
        $('#join_popup_div').tabs('select', 1);
    });

    // This fades from bw profile picture to color picture
    $("#profile_picture_bw").hover(function () {
        $(this).animate({
            "opacity": "0"
        }, "slow");
    }, function () {
        $(this).animate({
            "opacity": "1"
        }, "slow");
    });
    
    // Disable enter - to prevent submission of forms
    $("body").keypress(function (e) {
        if (e.which == 13 && !$(e.target).is("textarea")) {
            return false;
        }
    });


    jQuery.ajaxSetup({ 
      'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    })

    jQuery.fn.submitWithAjax = function() {
      this.submit(function() {
        $.post(this.action, $(this).serialize(), null, "script");
        return false;
      })
      return this;
    };

    $('#new_user').submitWithAjax();
});

