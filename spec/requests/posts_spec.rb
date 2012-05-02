require 'spec_helper'

describe "Posts" do
  describe "GET /posts" do
    it "shows all the posts on the index page" do
      first_post = FactoryGirl.create :post, :subject => "First Post", :body => "This is the first test post."
      second_post = FactoryGirl.create :post, :subject => "Second Post", :body => "This is the second test post."
      third_post = FactoryGirl.create :post, :subject => "Third Post", :body => "This is the third test post."
      fourth_post = FactoryGirl.create :post, :subject => "Fourth Post", :body => "This is the fourth test post."

      visit posts_path

      page.should have_selector "div#posts"
      page.should have_selector "article#post-#{first_post.id}"
      page.should have_selector "article#post-#{second_post.id}"
      page.should have_selector "article#post-#{third_post.id}"
      page.should have_selector "article#post-#{fourth_post.id}"
    end

    it "should load new posts when a post is submitted" do
      visit posts_path

      page.should_not have_selector "article.post"

      fill_in "post_subject", :with => "<p>This is a test</p>"
      fill_in "post_body", :with => "<p>This is also a <br /> test.</p>"
      click_button "Post"

      page.should have_selector "article.post"
      page.should have_content "This is also a test."
    end
  end
end
