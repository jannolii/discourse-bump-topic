import { popupAjaxError } from 'discourse/lib/ajax-error';
import Topic from 'discourse/models/topic';
import { ajax } from 'discourse/lib/ajax';

export default {
  actions: {
    clickButton(topic) {
      ajax("/topic/bump", {
        type: "PUT",
        data: {
          topic_id: topic.id
        }
      }).then((result) => {
        topic.set('bumped_at', result.topic.bumped_at);
        topic.set('custom_fields.bumped_at_with_button', result.topic.bumped_at);
      }).catch(() => {
        bootbox.alert(I18n.t('bump_topic.error_while_bumping'));
      });
    }
  }
};
