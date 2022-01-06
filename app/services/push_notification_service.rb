# frozen_string_literal: true

# Message template follow: https://github.com/decision-labs/fcm
# message = {
#   data: {
#     payload: { data: { id: 1 } }.to_json,
#     notification: { title: title, body: body },
#     ...
#   }
# }

class PushNotificationService
  @@fcm = FCM.new(ENV["FIREBASE_SERVER_KEY"])

  def self.notify(tokens=[], message={})
    @@fcm.send(tokens, message)
  end
end
