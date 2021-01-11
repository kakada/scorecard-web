# frozen_string_literal: true

class ContactSerializer < ActiveModel::Serializer
  attributes :id, :contact_type, :value
end
