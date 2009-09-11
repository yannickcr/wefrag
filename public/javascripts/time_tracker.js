var TimeTracker = Class.create(
{ 
  time_spent: 0,
  total_time_spent: 0,
  max_time_spent: 1200,
  post_delay: 10,

  id: null,
  pe: null,

  initialize: function()
  {
    if (document.location.href.match(/forums\/[a-z0-9_]+\/topics\/(\d+)/))
    {
      this.id = RegExp.$1;

      this.pe = new PeriodicalExecuter(this.update.bind(this), 1);
      this.schedule();

      Event.observe(window, 'unload', this.post.bind(this));
    }
  }, 

  update: function()
  {
      this.time_spent++;
  },

  schedule: function()
  {
    if (this.total_time_spent < this.max_time_spent)
    {
      this.post.bind(this).delay(this.post_delay);
    }
    else
    {
        this.pe.stop();
    }
  },

  post: function()
  {
    var obj = this;

    new Ajax.Request('/topics/' + this.id + '/timetrack',
    {
      method:     'post',
      parameters: { time: this.time_spent },
      onComplete: function(request)
      {
        obj.schedule();
      }
    });

    this.total_time_spent += this.time_spent;
    this.time_spent = 0;
  }
});

Event.observe(window, 'load', function() { new TimeTracker(); });
