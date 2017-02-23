class AboutController < ApplicationController
  skip_before_action :restrict_non_visible_user, only: [:terms, :privacy]

  def stats
    @slug  = "stats"
    @title = "Stats about Kypsy"

    # total counts
    @total_stats = [
      [
        [User.count,         "default", "users",     "People"   ],
        [Bookmark.count,     "warning", "star",      "Bookmarks"],
        [Crush.count,        "danger",  "heart",     "Crushes"  ]
      ],
      [
        [Photo.count,        "success", "picture-o", "Photos"],
        [Conversation.count, "info",    "envelope",  "Conversations"],
        [Message.count,      "info",    "comment",   "Messages"]
      ]
    ]

    # today counts
    @today_stats = [
      [
        [User.today.count,         "default", "users",     "People"   ],
        [Bookmark.today.count,     "warning", "star",      "Bookmarks"],
        [Crush.today.count,        "danger",  "heart",     "Crushes"  ]
      ],
      [
        [Photo.today.count,        "success", "picture-o", "Photos"],
        [Conversation.today.count, "info",    "envelope",  "Conversations"],
        [Message.today.count,      "info",    "comment",   "Messages"]
      ]
    ]

  end

  def terms
    @slug  = "about"
    @title = "Terms &amp; Conditions on Kypsy"
  end

  def privacy
    @slug = "privacy"
    @title = "Privacy Policy on Kypsy"
  end

  def us
    @slug  = "about"
    @title = "About Us, The Site and Code of Conduct"
  end

  def goodbye
    @slug  = "about"
    @title = "Goodbye, old friend! Come back anytime."
  end

  def sponsors
    @slug  = "sponsors"
    @title = "Kypsy Sponsors"
  end

  def grid
    @slug  = "grid"
    @title = "Everyone's Photo in One Big Grid for Screenshotting"
    @users = User.all
    render layout: false
  end
end
