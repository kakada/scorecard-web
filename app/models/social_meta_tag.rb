# frozen_string_literal: true

class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:  I18n.t("meta_tags.title"),
        site_name: I18n.t("meta_tags.site"),
        type: "website",
        description: I18n.t("meta_tags.description"),
        image: helper.image_url("csc_logo.png")
      },
      twitter: {
        title: I18n.t("meta_tags.title"),
        creator: I18n.t("meta_tags.site"),
        site: I18n.t("meta_tags.twitter.site"),
        card: "summary",
        description: I18n.t("meta_tags.description"),
        image: helper.image_url("csc_logo.png")
      },
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
