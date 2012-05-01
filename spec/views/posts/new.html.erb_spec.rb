require 'spec_helper'

describe "posts/new" do
  before(:each) do
    assign(:post, Post.new)
  end

  it "renders new post form" do
    render

    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_body", :name => "post[body]"
    end
  end
end