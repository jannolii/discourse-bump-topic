# name: bump-topic
# about: Plugin that let's users bump their topics in a controlled manner
# version: 0.0.1
# authors: Janno Liivak

enabled_site_setting :bump_topic_enabled

PLUGIN_NAME ||= "discourse_bump_topic".freeze

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

  module ::DiscourseBumpTopic
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace DiscourseBumpTopic
    end
  end

  class DiscourseBumpTopic::Bump
    class << self

      def bump(topic_id, user)
        DistributedMutex.synchronize("#{PLUGIN_NAME}-#{topic_id}") do
          user_id = user.id
          topic = Topic.find_by_id(topic_id)

          # topic must not be deleted
          if topic.nil? || topic.trashed?
            raise StandardError.new I18n.t("topic.topic_is_deleted")
          end

          # topic must not be archived
          if topic.try(:archived)
            raise StandardError.new I18n.t("topic.topic_must_be_open_to_edit")
          end

          topic.bumped_at = Time.zone.now
          topic.custom_fields['bumped_at_with_button'] = topic.bumped_at.iso8601
          topic.save!

          return topic
        end
      end
    end
  end

  require_dependency "application_controller"

  class DiscourseBumpTopic::BumpController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    before_filter :ensure_logged_in

    def bump
      topic_id   = params.require(:topic_id)

      begin
        topic = DiscourseBumpTopic::Bump.bump(topic_id, current_user)
        render json: { topic: topic }
      rescue StandardError => e
        render_json_error e.message
      end
    end
  end

  DiscourseBumpTopic::Engine.routes.draw do
    put "/bump" => "bump#bump"
  end

  Discourse::Application.routes.append do
    mount ::DiscourseBumpTopic::Engine, at: "/topic"
  end

end
