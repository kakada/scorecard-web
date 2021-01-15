# frozen_string_literal: true

module ContactsHelper
  def get_placeholder(contact_type)
    contact_type ||= "tel"
    placeholders[contact_type]
  end

  def placeholders
    {
      "tel" => I18n.t("contact.tel_placeholder"),
      "email" => I18n.t("contact.email_placeholder")
    }
  end
end
