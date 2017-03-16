import Topic from 'discourse/models/topic';
import { withPluginApi } from 'discourse/lib/plugin-api';
import computed from 'ember-addons/ember-computed-decorators';

function initializeWithApi(api) {

  const currentUser = api.getCurrentUser();

  Topic.reopen({
    @computed('bumped_at','updated_at')
    canBumpTopic: function(bumped_at) {
      const enable_bump_topics = this.category_bump_topic_enabled;
      const currentDate = new Date();
      var dateDiffInHours = 0;
      if (this.get('bumped_at_with_button')) {
        var maxDate = Math.max(new Date(this.get('bumped_at_with_button')).getTime(), new Date(this.get('bumped_at')).getTime());
        dateDiffInHours = (currentDate - maxDate) / (1000 * 3600);
      } else {
        dateDiffInHours = (currentDate - new Date(this.get('bumped_at')).getTime()) / (1000 * 3600);
      }
      return !this.isPrivatemessage
        && currentUser.id === this.user_id
        && this.siteSettings.bump_topic_enabled
        && enable_bump_topics
        && dateDiffInHours > this.siteSettings.bump_topic_interval_hours;
    }
  });
}

export default {
  name: 'extend-topic-for-bump-button',
  initialize() {

    withPluginApi('0.1', initializeWithApi);

  }
}
