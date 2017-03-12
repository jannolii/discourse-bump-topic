# name: bump-topic
# about: Plugin that let's users bump their topics in a controlled manner
# version: 0.0.1
# authors: Janno Liivak

enabled_site_setting :bump_topic_enabled

after_initialize do

  #Category.register_custom_field_type('enable_bump_topics', :boolean)

  if SiteSetting.bump_topic_enabled then

    add_to_serializer(:topic_view, :category_bump_topic_enabled, false) {
      object.topic.category.custom_fields['enable_bump_topics'] if object.topic.category
    }

    add_to_serializer(:topic_view, :bumped_at, false) {
      object.topic.bumped_at
    }

    add_to_serializer(:topic_view, :created_at, false) {
      object.topic.created_at
    }

    add_to_serializer(:topic_view, :custom_fields, false) {
      object.topic.custom_fields
    }

    PostRevisor.track_topic_field(:bumped_at) do |tc, bumped_at|
      tc.record_change('bumped_at', tc.topic.bumped_at, bumped_at)
      tc.topic.bumped_at = bumped_at
    end

    PostRevisor.track_topic_field(:custom_fields) do |tc, custom_fields|
      tc.record_change('custom_fields', tc.topic.custom_fields, custom_fields)
      tc.topic.custom_fields = custom_fields
    end
  end
end
