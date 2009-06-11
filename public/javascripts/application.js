$.ajaxSetup(
{
    beforeSend: function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript'); }
});

$(document).ready(function()
{
    $('textarea.markitup').markItUp(mySettings);

    if ($('table.list.forums').size() > 0)
    {
        $('a[href="/session/new"]').click(function()
        {
            $.get(this.href, function (data) { $.modal(data); $('#modalContainer input[name=login]').focus(); });
            return false;
        });
    }

    if ($('table.list.posts').size() > 0)
    {
        $('div.header a.move, div.footer a.move').click(function()
        {
            $.get(this.href, function (data) { $.modal(data); });
            return false;
        });
    }

    $('div#shouts form').ajaxForm({
        beforeSubmit: function()
        {
            $('div#shouts form').addClass('loading');
        },
        success: function()
        { 
            $.get('/shouts', function(data)
            {
                $('div#shouts div.content > div.list').html(data);
                load_shouts();
                $('div#shouts form').removeClass('loading');
                /* After reloading, we clear the input text. */
                $('div#shouts form input[type="text"]').val('');
            });
        }
    });

    load_shouts();

    $('ul.sf-menu').superfish({
        autoArrows: false,
        dropShadows: false,
        animation: { opacity: 'show' },
        speed: 1
    }); 

});

load_shouts = function()
{
    $('div#shouts div.list div.msg').click(function()
    { 
        var field = $('div#shouts form input[type="text"]');
        var time  = $(this).children('.time').text();
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
