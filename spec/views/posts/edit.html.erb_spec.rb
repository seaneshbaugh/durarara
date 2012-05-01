require 'spec_helper'

describe "posts/edit" do
  before(:each) do
    @post = FactoryGirl.create(:post)
  end

  it "renders the edit post form" do
    render

    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_body", :name => "post[body]"
    end
  end
end
