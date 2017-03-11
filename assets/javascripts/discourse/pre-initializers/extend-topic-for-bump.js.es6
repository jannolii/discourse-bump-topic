import computed from 'ember-addons/ember-computed-decorators';
import Topic from 'discourse/models/topic';

export default {
  name: 'extend-topic-for-bump',
  before: 'inject-discourse-objects',
  initialize() {

    Topic.reopen({

      @computed('custom_fields.bumped_at_with_button')
      bumped_at_with_button: {
        get(date_value) {
          if (date_value) {
            return new Date(date_value);
          }

          return null;
        },
        set(value) {
          this.set('custom_fields.bumped_at_with_button', value);
          return value;
        }
      }

    });
  }
};
