import { popupAjaxError } from 'discourse/lib/ajax-error';
import Topic from 'discourse/models/topic';

export default {
  actions: {
    clickButton(topic) {
      const current_date = new Date();
      topic.set('bumped_at', current_date);
      topic.set('custom_fields.bumped_at_with_button', current_date);
      let props = topic.getProperties('custom_fields');
      Topic.update(topic, props);
    }
  }
};
