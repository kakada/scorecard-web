# frozen_string_literal: true

class ChatGroupsNotification < ApplicationRecord
  belongs_to :notification
  belongs_to :chat_group
end
