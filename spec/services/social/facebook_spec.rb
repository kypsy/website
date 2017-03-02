require 'spec_helper'

describe Social::Facebook do
  let(:user) { create(:user) }
  let(:fb) { Social::Facebook.new(user) }
  let(:photo_hash) { [{"id"=>"1384952645138797", "created_time"=>"2014-12-29T05:52:14+0000", "from"=>{"id"=>"1384950561805672", "name"=>"Donna Amhgbbbddhja Shepardson"}, "height"=>500, "icon"=>"https://fb-icon.gif", "images"=>[{"height"=>500, "source"=>"https://fb-image-500", "width"=>500}, {"height"=>480, "source"=>"https://fb-image-480", "width"=>480}, {"height"=>320, "source"=>"https://fb-image-320", "width"=>320}, {"height"=>130, "source"=>"https://fb-image-130", "width"=>130}, {"height"=>225, "source"=>"https://fb-image-225", "width"=>225}], "link"=>"https://fb-photo-link", "picture"=>"https://fb-picture", "source"=>"https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/10846231_1384952645138797_4443666842932669602_n.jpg?oh=46e59db620cfe305b9c246f85c31546a&oe=55351F9A&__gda__=1429881840_a6b63735621abf45cfd935a3a30f19fa", "updated_time"=>"2014-12-29T05:53:26+0000", "width"=>500, "tags"=>{"data"=>[{"id"=>"1384950561805672", "name"=>"Donna Amhgbbbddhja Shepardson", "created_time"=>"2014-12-29T05:53:26+0000", "x"=>47, "y"=>47.8}], "paging"=>{"cursors"=>{"before"=>"MTM4NDk1MDU2MTgwNTY3Mg==", "after"=>"MTM4NDk1MDU2MTgwNTY3Mg=="}}}}] }
  let(:info_hash) { {
    "id"=>"1384950561805672", "email"=>"jofcgtc_shepardson_1419832166@tfbnw.net", "first_name"=>"Donna", "gender"=>"female", "last_name"=>"Shepardson", "link"=>"https://www.facebook.com/profile.php?id=100008722244801", "locale"=>"en_US", "middle_name"=>"Amhgbbbddhja", "name"=>"Donna Amhgbbbddhja Shepardson",
    "timezone" => 0, "updated_time"=>"2014-12-29T05:52:15+0000", "verified"=>false}
  }

  before {
    user.credentials << create(:credential, provider_name: "facebook", created_at: 1.year.ago)
  }

  it 'takes a user' do
    expect(fb.user).to eq user
  end

  it 'creates a client' do
    expect(fb.client).to be_a Koala::Facebook::API
  end

  it 'returns a list of photos' do
    expect(fb.client).to receive("get_connections").with("me", "photos").and_return(photo_hash)
    expect(fb.photos).to eq photo_hash
  end

  describe '#info' do
    before do
      expect(fb.client).to receive("get_object").with("me").and_return(info_hash)
    end

    it 'returns info hash' do
      expect(fb.info).to eq info_hash
    end
  end

  describe '#credential' do
    let(:credential) { create(:credential, provider_name: "facebook") }

    it 'finds the latest one' do
      user.credentials << credential
      expect(fb.credential).to eq credential
    end

    it 'raises an error if missing' do
      user.credentials.destroy_all
      expect {fb.credential}.to raise_error(Social::SocialError)
    end
  end
end
