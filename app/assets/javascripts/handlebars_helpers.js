Handlebars.registerHelper('ifEqualsOne', function(length, block) {
  if (length == 1) {
    return block.fn(this);
  }
});

Handlebars.registerHelper('ifMoreThanOne', function(length, block) {
  if (length > 1) {
    return block.fn(this);
  }
});