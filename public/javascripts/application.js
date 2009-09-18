jQuery.ajaxSetup(
{
    beforeSend: function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript'); }
});

jQuery(document).ready(function()
{
    jQuery('textarea.markitup').markItUp(mySettings);

    if (jQuery('table.list.forums').size() > 0)
    {
        jQuery('a.new_my_session').click(function()
        {
            jQuery.get(this.href, function(data) { jQuery.modal(data); jQuery('.modalContainer input[name=login]').focus(); });
            return false;
        });
    }

    if (jQuery('table.list.posts').size() > 0)
    {
        jQuery('div.header a.move, div.footer a.move').click(function()
        {
            jQuery.get(this.href, function(data) { jQuery.modal(data); });
            return false;
        });
    }

    jQuery('div#shouts form').ajaxForm({
        beforeSubmit: function()
        {
            jQuery('div#shouts form').addClass('loading');
        },
        success: function()
        { 
            jQuery.get('/shouts/box', function(data)
            {
                jQuery('div#shouts div.content > div.list').html(data);
                load_shouts();
                jQuery('div#shouts form').removeClass('loading');
                /* After reloading, we clear the input text. */
                jQuery('div#shouts form input[type="text"]').val('');
            });
        }
    });

    load_shouts();

    jQuery('ul.sf-menu').superfish({
        autoArrows: false,
        dropShadows: false,
        animation: { opacity: 'show' },
        speed: 1
    }); 

});

load_shouts = function()
{
    jQuery('div#shouts div.list div.msg').click(function()
    { 
        var field = jQuery('div#shouts form input[type="text"]');
        var time  = jQuery(this).children('.time').text();
        var re    =  /^\d{2}:\d{2}\s/;

        if (field.val().match(re))
        {
            field.val(field.val().replace(re, time + ' '));
        }
        else
        {
            field.val(time + ' ' + field.val());
        }

        return true;
    });
};
