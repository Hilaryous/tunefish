import Ember from 'ember';

var ModalView;

ModalView = Ember.View.extend({
  tagName: 'div',
  classNames: 'modal'.w(),
  didInsertElement: function() {
    this.$().attr('id', 'modal');
    this.$().modal({
      keyboard: false,
      backdrop: 'static'
    });
    return this.$('.modal-dialog').modal('show');
  },
  willDestroyElement: function() {
    return this.$().modal('hide');
  }
});

export default ModalView;
