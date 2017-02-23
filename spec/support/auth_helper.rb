def twitter_auth_response
  {"provider"=>"twitter",
    "uid"=>"8553052",
    "info"=>
     {"nickname"=> "dalecooper",
      "name"=>"dale cooper",
      "location"=>"Seattle, WA, USA",
      "image"=>"http://pbs.twimg.com/profile_images/1421207561/image_normal.jpg",
      "description"=>"I like too much to like anything enough to mention",
      "urls"=>
       {"Website"=>"http://t.co/fNxC6FubtN",
        "Twitter"=>"https://twitter.com/dale"}},
    "credentials"=>
     {"token"=>"xxxxx",
      "secret"=>"xxxxx"},
    "extra"=>
     {"access_token"=> {},
      "raw_info"=>
       {"id"=>8553052,
        "id_str"=>"8553052",
        "name"=>"dale",
        "screen_name"=>"dalecooper",
        "location"=>"Seattle, WA, USA",
        "description"=>"I like too much to like anything enough to mention",
        "url"=>"http://t.co/fNxC6FubtN",
        "entities"=>
         {"url"=>
           {"urls"=>
             [{"url"=>"http://t.co/fNxC6FubtN",
               "expanded_url"=>"http://iamdale.com",
               "display_url"=>"iamdale.com",
               "indices"=>[0, 22]}]},
          "description"=>{"urls"=>[]}},
        "protected"=>false,
        "followers_count"=>239,
        "friends_count"=>26,
        "listed_count"=>10,
        "created_at"=>"Fri Aug 31 07:36:31 +0000 2007",
        "favourites_count"=>7,
        "utc_offset"=>-28800,
        "time_zone"=>"Pacific Time (US & Canada)",
        "geo_enabled"=>true,
        "verified"=>false,
        "statuses_count"=>1689,
        "lang"=>"en",
        "contributors_enabled"=>false,
        "is_translator"=>false,
        "profile_background_color"=>"A3C9FF",
        "profile_background_image_url"=>
         "http://a0.twimg.com/profile_background_images/1921152/twitter.jpg",
        "profile_background_image_url_https"=>
         "https://si0.twimg.com/profile_background_images/1921152/twitter.jpg",
        "profile_background_tile"=>false,
        "profile_image_url"=>
         "http://pbs.twimg.com/profile_images/1421207561/image_normal.jpg",
        "profile_image_url_https"=>
         "https://pbs.twimg.com/profile_images/1421207561/image_normal.jpg",
        "profile_link_color"=>"FF87FC",
        "profile_sidebar_border_color"=>"87BC44",
        "profile_sidebar_fill_color"=>"D2FFFC",
        "profile_text_color"=>"000000",
        "profile_use_background_image"=>true,
        "default_profile"=>false,
        "default_profile_image"=>false,
        "following"=>false,
        "follow_request_sent"=>false,
        "notifications"=>false
      }
    }
  }
end

def facebook_auth_response
  {"provider"=>"facebook",
    "uid"=>"663412500",
    "info"=>
     {"nickname"=>"dale",
      "email"=>"dale@example.com",
      "name"=>"Dale Cooper",
      "first_name"=>"Dale",
      "last_name"=>"Cooper",
      "image"=>"http://placekitten.com/10/10?type=square",
      "urls"=>{"Facebook"=>"https://www.facebook.com/dale"},
      "location"=>"Seattle, Washington",
      "verified"=>true},
    "credentials"=>
     {"token"=>"1234",
      "expires_at"=> 60.days.from_now.to_i,
      "expires"=>true},
    "extra"=>
     {"raw_info"=>
       {"id"=>"663412500",
        "name"=>"Dale Cooper",
        "first_name"=>"Dale",
        "last_name"=>"Cooper",
        "link"=>"https://www.facebook.com/dale",
        "username"=>"dale",
        "hometown"=>{"id"=>"112869145392338", "name"=>"Clearfield, Utah"},
        "location"=>{"id"=>"110843418940484", "name"=>"Seattle, Washington"},
        "work"=>
         [{"employer"=>{"id"=>"165517190155252", "name"=>"Luna Sandals"},
           "location"=>{"id"=>"110843418940484", "name"=>"Seattle, Washington"},
           "position"=>{"id"=>"112032368815466", "name"=>"C.E.O."},
           "description"=>"I just take the money.",
           "start_date"=>"2010-01-01"},
          {"employer"=>{"id"=>"119240841493711", "name"=>"Nintendo"}}],
        "education"=>
         [{"school"=>{"id"=>"112287948787022", "name"=>"Clearfield High School"},
           "year"=>{"id"=>"194603703904595", "name"=>"2003"},
           "type"=>"High School"},
          {"school"=>{"id"=>"490344334336578", "name"=>"Google High School"},
           "type"=>"College"}],
        "gender"=>"male",
        "email"=>"dale@example.com",
        "timezone"=>-8,
        "locale"=>"en_US",
        "verified"=>true,
        "updated_time"=>"2013-09-14T15:03:02+0000"
      }
    }
  }
end

def mandrill_callback(user, options={base64: false})
  file = File.read("spec/support/small.png")
  content = options[:base64] ? Base64.encode64(file) : file

  {
    ts: Time.now.to_i,
    event: "inbound",
    msg: {
      text: "This is the body of the email",
      from_email: user.email,
      subject: "This is a subject",
      attachments: {"RokyErickson.jpg" => {
        name: "photo.jpg",
        type: "image/jpeg",
        content: content.force_encoding("ISO-8859-1").encode("UTF-8"),
        base64: options[:base64]
      }},
      spam_report: {}
    }
  }
end
