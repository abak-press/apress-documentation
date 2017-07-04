var DependencySwitcher = (function(self) {
  self.switchBind = function() {
    $('.js-dependency-switch', '.js-dependencies-container').change(function() {
      $('.js-all-dependencies', '.js-dependencies-container').toggle();
      $('.js-dependencies', '.js-dependencies-container').toggle();
    });
  };

  return self;
})(DependencySwitcher || {});
