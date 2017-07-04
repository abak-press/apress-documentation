$(function () {
  Handlebars.registerHelper('fetch', function (value, def) {
      return value || def;
  });

  $(document).on('swaggerBind', function(event) {
    event.preventDefault();

    if(!app.extensions) {
      return;
    }

    for(var ext in app.extensions) {
      $('#' + ext + '_content').prepend(HandlebarsTemplates['document']({document: app.extensions[ext]}));
    }

    DependencySwitcher.switchBind();
  });
});
