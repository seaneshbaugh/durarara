require 'spec_helper'

describe "Posts" do
  describe "GET /posts" do
    it "shows all the posts on the index page" do
      first_post = FactoryGirl.create :post, :subject => "First Post", :body => "This is the first test post."
      second_post = FactoryGirl.create :post, :subject => "Second Post", :body => "This is the second test post."
      third_post = FactoryGirl.create :post, :subject => "Third Post", :body => "This is the third test post."
      fourth_post = FactoryGirl.create :post, :subject => "Fourth Post", :body => "This is the fourth test post."

      visit posts_path

      page.has_selector? "#post-#{first_post.id}"
      page.has_selector? "#post-#{second_post.id}"
      page.has_selector? "#post-#{third_post.id}"
      page.has_selector? "#post-#{fourth_post.id}"
    end
  end
end
