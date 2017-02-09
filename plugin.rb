# name: bump-topic
# about: Plugin that let's users bump their topics in a controlled manner
# version: 0.0.1
# authors: Janno Liivak

enabled_site_setting :bump_topic_enabled

after_initialize do

  #Category.register_custom_field_type('enable_bump_topics', :boolean)

  if SiteSetting.bump_topic_enabled then
    add_to_serializer(:topic_view, :category_bump_topic_enabled, false) {
      object.topic.category.custom_fields['enable_bump_topics']
    }

    add_to_serializer(:topic_view, :bumped_at) { object.topic.bumped_at }
    add_to_serializer(:basic_topic, :bumped_at) { object.bumped_at }

    # I guess this should be the default @ discourse. PR maybe?
    add_to_serializer(:topic_view, :custom_fields, false) {
      if object.topic.custom_fields == nil then
        {}
      else
        object.topic.custom_fields
      end
    }
  end

  PostRevisor.track_topic_field(:bumped_at) do |tc, bumped_at|
    tc.record_change('bumped_at', tc.topic.bumped_at, bumped_at)
    tc.topic.bumped_at = bumped_at
  end
end
