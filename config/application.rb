require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewMoonWishesApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.helper false # helperを自動生成しない
    end

    # デフォルトの言語を日本語に設定
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # デフォルトのタイムゾーンを日本に設定
    config.time_zone = 'Tokyo'

    # FormObjectの読み込み
    config.autoload_paths += Dir.glob("#{config.root}/app/models/form/**/*")

    # Active JobのアダプタにDelayed Jobを設定
    config.active_job.queue_adapter = :delayed_job

    # バリデーション失敗時のfield_with_errorsのdivタグ自動生成を停止
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
end
