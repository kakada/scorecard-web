# frozen_string_literal: true

class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:  I18n.t("meta_tags.title").html_safe,
        type: "website",
        # url:  "#{ENV['ENDPOINT_URL']}#{I18n.locale}",
        image: helper.image_url("csc_logo.png"),
        # image: "https://isaf.digital-csc.org/assets/csc_logo-fc2a7ed1727c64ac73fe09be55fa841d1089f3fc08bd6998b274948cade123b7.png",
        description: I18n.t("meta_tags.description").html_safe,
        site_name: I18n.t("meta_tags.site").html_safe
      },
      twitter: {
        card: "summary",
        site: I18n.t("meta_tags.twitter.site").html_safe,
        title: I18n.t("meta_tags.title").html_safe,
        description: I18n.t("meta_tags.description").html_safe,
        creator: I18n.t("meta_tags.site").html_safe,
        image: helper.image_url("csc_logo.png")
        # image: "https://isaf.digital-csc.org/assets/csc_logo-fc2a7ed1727c64ac73fe09be55fa841d1089f3fc08bd6998b274948cade123b7.png",
      },
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
