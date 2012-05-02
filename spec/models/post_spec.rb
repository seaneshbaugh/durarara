require 'spec_helper'

describe Post do
  it "creates the name before saving" do
    post = FactoryGirl.create(:post)

    post.name.should eq("12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0")
  end

  it "escapes HTML in the subject before saving" do
    post = FactoryGirl.create(:post, :subject => "<p>This is some <strong>HTML</strong>.</p>")

    post.subject.should eq("This is some HTML.")
  end

  it "replaces newlines with br tags before saving" do
    post = FactoryGirl.create(:post, :body => "This\nis\na\ntest.")

    post.body.should eq("This&lt;br /&gt;is&lt;br /&gt;a&lt;br /&gt;test.")
  end
end
