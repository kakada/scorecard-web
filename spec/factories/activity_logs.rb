FactoryBot.define do
  factory :activity_log do
    controller_name { "MyString" }
    action_name { "MyString" }
    format { "MyString" }
    http_method { "MyString" }
    path { "MyString" }
    http_status { 1 }
    payload { "" }
  end
end
