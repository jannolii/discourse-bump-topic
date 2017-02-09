import { popupAjaxError } from 'discourse/lib/ajax-error';

export default {
  actions: {
    clickButton(topic) {
      topic.set('bumped_at', new Date());
      const props = topic.getProperties('bumped_at');
      topic.update(props);
    }
  }
};
