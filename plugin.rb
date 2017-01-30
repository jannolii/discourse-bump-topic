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

    # I guess this should be the default @ discourse. PR maybe?
    add_to_serializer(:topic_view, :custom_fields, false) {
      if object.topic.custom_fields == nil then
        {}
      else
        object.topic.custom_fields
      end
    }
  end

end
