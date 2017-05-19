$(function () {
  if(app.swagger) {
    window.swaggerUi = new SwaggerUi({
      url: app.swagger.docsUrl,
      dom_id: 'swagger-ui-container',
      supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
      onComplete: function() {
        $('pre code').each(function(i, e) {
          hljs.highlightBlock(e);
        });

        $(document).trigger('swaggerBind');
      },
      onFailure: function() {
        console.log('Unable to Load SwaggerUI');
      },
      docExpansion: (app.swagger.docsExpansion || 'none'),
      jsonEditor: true,
      defaultModelRendering: 'schema',
      showRequestHeaders: true
    });
    window.swaggerUi.load();
  }
});
