import Topic from 'discourse/models/topic';
import { withPluginApi } from 'discourse/lib/plugin-api';
import computed from 'ember-addons/ember-computed-decorators';

function initializeWithApi(api) {

  Topic.reopen({
    @computed
    canBumpTopic: function() {
      const enable_bump_topic = this.get("category.custom_fields.enable_bump_topic");
      console.log(enable_bump_topic);
      return enable_bump_topic;
    }
  });

}

export default {
  name: 'extend-topic-for-bump-button',
  initialize() {

    withPluginApi('0.1', initializeWithApi);

  }
}
