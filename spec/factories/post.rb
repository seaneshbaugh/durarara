FactoryGirl.define do
  factory :post do
    subject "Test Post"
    body "This is a test!"
    ip_address "127.0.0.1"
  end
end