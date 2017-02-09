import Topic from 'discourse/models/topic';
import TopicsController from 'discourse/controllers/topic';
import { withPluginApi } from 'discourse/lib/plugin-api';
import computed from 'ember-addons/ember-computed-decorators';

function initializeWithApi(api) {

  const currentUser = api.getCurrentUser();

  Topic.reopen({
    @computed('bumped_at')
    canBumpTopic: function() {
      const enable_bump_topics = this.category_bump_topic_enabled;
      const currentDate = new Date();
      const dateDiffInHours = (currentDate - this.get('bumpedAt')) / (1000 * 3600);
      return !this.isPrivatemessage
        && currentUser.id === this.user_id
        && this.siteSettings.bump_topic_enabled
        && enable_bump_topics
        && dateDiffInHours > this.siteSettings.bump_topic_interval_hours;
    }
  });

  const TopicsController = api.container.lookupFactory("controller:topic");
  TopicsController.reopen({
    actions: {
      bumpTopicByButton() {
        console.log('bump!');
      }
    }
  });

}

export default {
  name: 'extend-topic-for-bump-button',
  initialize() {

    withPluginApi('0.1', initializeWithApi);

  }
}
