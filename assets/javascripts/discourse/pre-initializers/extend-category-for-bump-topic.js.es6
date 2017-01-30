import property from 'ember-addons/ember-computed-decorators';
import Category from 'discourse/models/category';

export default {
  name: 'extend-category-for-bump-topic',
  before: 'inject-discourse-objects',
  initialize() {

    Category.reopen({

      @property('custom_fields.enable_bump_topic')
      enable_bump_topic: {
        get(enableField) {
          return enableField === "true";
        },
        set(value) {
          value = value ? "true" : "false";
          this.set("custom_fields.enable_bump_topic", value);
          return value;
        }
      }

    });
  }
};
