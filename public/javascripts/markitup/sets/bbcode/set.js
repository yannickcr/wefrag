// ----------------------------------------------------------------------------
// markItUp!
// ----------------------------------------------------------------------------
// Copyright (C) 2007 Jay Salvat
// http://markitup.jaysalvat.com/
// ----------------------------------------------------------------------------
// BBCode tags example
// http://en.wikipedia.org/wiki/Bbcode
// ----------------------------------------------------------------------------
// Feel free to add more tags
// ----------------------------------------------------------------------------
mySettings = {
  previewParserPath: "/posts/preview", // path to your BBCode parser
  markupSet: [		
	  {name:'Bold', key:'B', openWith:'[b]', closeWith:'[/b]'}, 
	  {name:'Italic', key:'I', openWith:'[i]', closeWith:'[/i]'}, 
	  {name:'Underline', key:'U', openWith:'[u]', closeWith:'[/u]'}, 
	  {separator:'---------------' },
	  {name:'Picture', key:'P', replaceWith:'[img][![Url]!][/img]'}, 
	  {name:'Link', key:'L', openWith:'[url=[![Url]!]]', closeWith:'[/url]', placeHolder:'Your text to link here...'},
	  {separator:'---------------' },
	  /*{name:'Size', key:'S', openWith:'[size=[![Text size]!]]', closeWith:'[/size]', 
	  dropMenu :[
		  {name:'Big', openWith:'[size=200]', closeWith:'[/size]' }, 
		  {name:'Normal', openWith:'[size=100]', closeWith:'[/size]' }, 
		  {name:'Small', openWith:'[size=50]', closeWith:'[/size]' }
	  ]}, 
	  {separator:'---------------' },*/
	  {name:'Quotes', openWith:'[quote]', closeWith:'[/quote]'}, 
	  {name:'Code', openWith:'[code]', closeWith:'[/code]'}, 
	  {separator:'---------------' },
	  //{name:'Clean', className:"clean", replaceWith:function(h) { return h.selection.replace(/\[(.*?)\]/g, "") } },
	  {name:'Preview', className:"preview", call:'preview'}
   ]
}
