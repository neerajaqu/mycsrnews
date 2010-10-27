# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101027210809) do

  create_table "announcements", :force => true do |t|
    t.string   "prefix"
    t.string   "title",                            :null => false
    t.text     "details"
    t.string   "url"
    t.string   "mode",       :default => "rotate"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id",                 :default => 0
    t.integer  "user_id",        :limit => 8, :default => 0
    t.text     "answer"
    t.integer  "votes_tally",                 :default => 0
    t.integer  "comments_count",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blocked",                  :default => false
    t.boolean  "is_featured",                 :default => false
    t.datetime "featured_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.boolean  "is_featured",       :default => false
    t.datetime "featured_at"
    t.boolean  "is_blocked",        :default => false
    t.boolean  "is_draft",          :default => false
    t.text     "preamble"
    t.boolean  "preamble_complete", :default => false
  end

  create_table "audios", :force => true do |t|
    t.string   "audioable_type"
    t.integer  "audioable_id"
    t.integer  "user_id"
    t.string   "url"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_tally",    :default => 0
    t.integer  "source_id"
  end

  add_index "audios", ["audioable_type", "audioable_id"], :name => "index_audios_on_audioable_type_and_audioable_id"
  add_index "audios", ["user_id"], :name => "index_audios_on_user_id"

  create_table "cards", :force => true do |t|
    t.string   "name"
    t.string   "short_caption"
    t.text     "long_caption"
    t.integer  "points",        :default => 0
    t.string   "slug_name"
    t.boolean  "not_sendable",  :default => false
    t.boolean  "is_featured",   :default => false
    t.datetime "updated_at"
    t.integer  "sent_count",    :default => 0
    t.datetime "created_at"
  end

  create_table "chirps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentid",        :default => 0
    t.integer  "commentable_id",   :default => 0
    t.integer  "contentid",        :default => 0
    t.text     "comments"
    t.string   "postedByName",     :default => ""
    t.integer  "postedById",       :default => 0
    t.integer  "user_id",          :default => 0
    t.datetime "created_at"
    t.boolean  "is_blocked",       :default => false
    t.integer  "videoid",          :default => 0
    t.datetime "updated_at"
    t.string   "commentable_type"
    t.integer  "flags_count",      :default => 0
    t.integer  "votes_tally",      :default => 0
    t.boolean  "is_featured",      :default => false
    t.datetime "featured_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

  create_table "consumer_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :limit => 30
    t.string   "token",      :limit => 1024
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consumer_tokens", ["user_id"], :name => "index_consumer_tokens_on_user_id", :unique => true

  create_table "content_images", :force => true do |t|
    t.string   "url",        :default => ""
    t.integer  "content_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_images", ["content_id"], :name => "index_content_images_on_content_id"
  add_index "content_images", ["content_id"], :name => "siteContentId"

  create_table "contents", :force => true do |t|
    t.integer  "contentid",          :default => 0
    t.string   "title",              :default => ""
    t.text     "caption"
    t.string   "url",                :default => ""
    t.string   "permalink",          :default => ""
    t.integer  "postedById",         :default => 0
    t.string   "postedByName",       :default => ""
    t.datetime "created_at"
    t.integer  "score",              :default => 0
    t.integer  "numComments",        :default => 0
    t.boolean  "is_featured",        :default => false
    t.integer  "user_id",            :default => 0
    t.integer  "imageid",            :default => 0
    t.integer  "videoIntroId",       :default => 0
    t.boolean  "is_blocked",         :default => false
    t.integer  "videoid",            :default => 0
    t.integer  "widgetid",           :default => 0
    t.boolean  "isBlogEntry",        :default => false
    t.boolean  "isFeatureCandidate", :default => false
    t.integer  "comments_count",     :default => 0
    t.datetime "updated_at"
    t.integer  "article_id"
    t.string   "cached_slug"
    t.integer  "flags_count",        :default => 0
    t.integer  "votes_tally",        :default => 0
    t.integer  "newswire_id"
    t.string   "story_type",         :default => "story"
    t.string   "summary"
    t.text     "full_html"
    t.integer  "source_id"
  end

  add_index "contents", ["contentid"], :name => "contentid"
  add_index "contents", ["story_type"], :name => "index_contents_on_story_type"
  add_index "contents", ["title"], :name => "relatedItems"
  add_index "contents", ["title"], :name => "relatedText"

  create_table "dashboard_messages", :force => true do |t|
    t.string   "message"
    t.string   "action_text"
    t.string   "action_url"
    t.string   "image_url"
    t.string   "status",      :default => "draft"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "news_id"
  end

  create_table "events", :force => true do |t|
    t.string   "eid"
    t.string   "name"
    t.string   "tagline"
    t.string   "pic"
    t.string   "pic_big"
    t.string   "pic_small"
    t.string   "host"
    t.string   "location"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "description"
    t.string   "event_type"
    t.string   "event_subtype"
    t.string   "privacy_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "update_time"
    t.boolean  "isApproved"
    t.integer  "nid"
    t.integer  "creator"
    t.integer  "user_id"
    t.integer  "votes_tally"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_featured",    :default => false
    t.datetime "featured_at"
    t.boolean  "is_blocked",     :default => false
    t.integer  "flags_count",    :default => 0
    t.string   "url"
    t.string   "alt_url"
    t.string   "source"
  end

  add_index "events", ["eid"], :name => "index_events_on_eid"

  create_table "fbSessions", :force => true do |t|
    t.integer  "userid",                     :limit => 8, :default => 0
    t.integer  "fbId",                       :limit => 8, :default => 0
    t.string   "fb_sig_session_key",                      :default => ""
    t.datetime "fb_sig_time"
    t.datetime "fb_sig_expires"
    t.datetime "fb_sig_profile_update_time"
  end

  create_table "featured_items", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "featurable_id"
    t.string   "featurable_type"
    t.string   "featured_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "featured_items", ["featurable_type", "featurable_id"], :name => "index_featured_items_on_featurable_type_and_featurable_id"
  add_index "featured_items", ["featured_type"], :name => "index_featured_items_on_featured_type"
  add_index "featured_items", ["name"], :name => "index_featured_items_on_name"
  add_index "featured_items", ["parent_id"], :name => "index_featured_items_on_parent_id"

  create_table "feeds", :force => true do |t|
    t.integer  "wireid",                       :default => 0
    t.string   "title",                        :default => ""
    t.string   "url",                          :default => ""
    t.string   "rss",                          :default => ""
    t.datetime "last_fetched_at"
    t.string   "feedType",                     :default => "wire"
    t.string   "specialType",                  :default => "default"
    t.string   "loadOptions",                  :default => "none"
    t.integer  "user_id",         :limit => 8, :default => 0
    t.string   "tagList",                      :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "load_all",                     :default => false
    t.datetime "deleted_at"
  end

  add_index "feeds", ["deleted_at"], :name => "index_feeds_on_deleted_at"

  create_table "flags", :force => true do |t|
    t.string   "flag_type"
    t.integer  "user_id"
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["flaggable_type", "flaggable_id"], :name => "index_flags_on_flaggable_type_and_flaggable_id"

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "topics_count",   :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "position",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blocked",     :default => false
    t.boolean  "is_featured",    :default => false
    t.datetime "featured_at"
  end

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.string   "section"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "caption"
    t.integer  "votes_tally",    :default => 0
    t.integer  "comments_count", :default => 0
    t.boolean  "is_featured",    :default => false
    t.datetime "featured_at"
    t.integer  "flags_count",    :default => 0
    t.boolean  "is_blocked",     :default => false
    t.integer  "gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "idea_boards", :force => true do |t|
    t.string   "name"
    t.string   "section"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blocked",  :default => false
  end

  create_table "ideas", :force => true do |t|
    t.integer  "user_id",        :limit => 8, :default => 0
    t.string   "title",                       :default => ""
    t.text     "details"
    t.integer  "old_tag_id",                  :default => 0
    t.integer  "old_video_id",                :default => 0
    t.integer  "votes_tally",                 :default => 0
    t.integer  "comments_count",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idea_board_id"
    t.boolean  "is_featured",                 :default => false
    t.datetime "featured_at"
    t.integer  "flags_count",                 :default => 0
    t.boolean  "is_blocked",                  :default => false
  end

  add_index "ideas", ["title"], :name => "related"

  create_table "images", :force => true do |t|
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.integer  "user_id"
    t.text     "description"
    t.string   "remote_image_url"
    t.boolean  "is_blocked",         :default => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_tally",        :default => 0
    t.string   "title"
    t.integer  "source_id"
  end

  add_index "images", ["imageable_type", "imageable_id"], :name => "index_images_on_imageable_type_and_imageable_id"
  add_index "images", ["remote_image_url"], :name => "index_images_on_remote_image_url"
  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "locales", :force => true do |t|
    t.string "code"
    t.string "name"
  end

  add_index "locales", ["code"], :name => "index_locales_on_code"

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.string   "email"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metadatas", :force => true do |t|
    t.string   "metadatable_type"
    t.integer  "metadatable_id"
    t.string   "key_name"
    t.string   "key_type"
    t.string   "meta_type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key_sub_type"
    t.string   "type"
  end

  add_index "metadatas", ["key_name"], :name => "index_metadatas_on_key_name"
  add_index "metadatas", ["key_type", "key_name"], :name => "index_metadatas_on_key_type_and_key_name"
  add_index "metadatas", ["key_type", "key_sub_type", "key_name"], :name => "index_metadatas_on_key_type_and_key_sub_type_and_key_name"
  add_index "metadatas", ["metadatable_type", "metadatable_id"], :name => "index_metadatas_on_metadatable_type_and_metadatable_id"

  create_table "newswires", :force => true do |t|
    t.string   "title",                     :default => ""
    t.text     "caption"
    t.string   "source",     :limit => 150, :default => ""
    t.string   "url",                       :default => ""
    t.datetime "created_at"
    t.integer  "wireid",                    :default => 0
    t.string   "feedType",                  :default => "wire"
    t.string   "mediaUrl",                  :default => ""
    t.string   "imageUrl",                  :default => ""
    t.text     "embed"
    t.integer  "feed_id",                   :default => 0
    t.datetime "updated_at"
    t.boolean  "published",                 :default => false
    t.integer  "read_count"
  end

  add_index "newswires", ["feed_id"], :name => "feedid"
  add_index "newswires", ["title"], :name => "index_newswires_on_title"

  create_table "pfeed_deliveries", :force => true do |t|
    t.integer  "pfeed_receiver_id"
    t.string   "pfeed_receiver_type"
    t.integer  "pfeed_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pfeed_items", :force => true do |t|
    t.string   "type"
    t.integer  "originator_id"
    t.string   "originator_type"
    t.integer  "participant_id"
    t.string   "participant_type"
    t.text     "data"
    t.datetime "expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_groups", :force => true do |t|
    t.string   "title"
    t.string   "section"
    t.text     "description"
    t.string   "status",          :default => "open"
    t.integer  "user_id"
    t.boolean  "is_approved",     :default => true
    t.integer  "votes_tally",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.integer  "questions_count", :default => 0
    t.boolean  "is_blocked",      :default => false
    t.boolean  "is_featured",     :default => false
    t.datetime "featured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_guesses", :force => true do |t|
    t.integer  "prediction_question_id"
    t.integer  "user_id"
    t.string   "guess"
    t.integer  "guess_numeric"
    t.datetime "guess_date"
    t.boolean  "is_blocked",             :default => false
    t.boolean  "is_featured",            :default => false
    t.datetime "featured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_questions", :force => true do |t|
    t.integer  "prediction_group_id"
    t.string   "title"
    t.string   "prediction_type"
    t.string   "choices"
    t.string   "status",              :default => "open"
    t.integer  "user_id"
    t.boolean  "is_approved",         :default => true
    t.integer  "votes_tally",         :default => 0
    t.integer  "comments_count",      :default => 0
    t.integer  "guesses_count",       :default => 0
    t.boolean  "is_blocked",          :default => false
    t.boolean  "is_featured",         :default => false
    t.datetime "featured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_scores", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guess_count"
    t.integer  "correct_count"
    t.float    "accuracy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "user_id",        :limit => 8, :default => 0
    t.string   "question",                    :default => ""
    t.text     "details"
    t.integer  "votes_tally",                 :default => 0
    t.integer  "comments_count",              :default => 0
    t.datetime "created_at"
    t.integer  "answers_count",               :default => 0
    t.datetime "updated_at"
    t.boolean  "is_blocked",                  :default => false
    t.boolean  "is_featured",                 :default => false
    t.datetime "featured_at"
  end

  add_index "questions", ["question"], :name => "related"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "related_items", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "notes"
    t.integer  "user_id"
    t.boolean  "is_blocked",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "relatable_type"
    t.integer  "relatable_id"
  end

  create_table "resource_sections", :force => true do |t|
    t.string   "name"
    t.string   "section"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blocked",  :default => false
  end

  create_table "resources", :force => true do |t|
    t.string   "title",                                  :null => false
    t.text     "details"
    t.string   "url"
    t.string   "mapUrl"
    t.string   "twitterName"
    t.integer  "votes_tally"
    t.integer  "comments_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flags_count",         :default => 0
    t.integer  "resource_section_id"
    t.boolean  "is_blocked",          :default => false
    t.boolean  "is_featured",         :default => false
    t.datetime "featured_at"
    t.boolean  "is_sponsored",        :default => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "user_id"
    t.string   "scorable_type"
    t.integer  "scorable_id"
    t.string   "score_type"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["created_at"], :name => "index_scores_on_created_at"
  add_index "scores", ["scorable_type", "scorable_id"], :name => "index_scores_on_scorable_type_and_scorable_id"
  add_index "scores", ["scorable_type"], :name => "index_scores_on_scorable_type"
  add_index "scores", ["score_type"], :name => "index_scores_on_score_type"
  add_index "scores", ["user_id"], :name => "index_scores_on_user_id"

  create_table "sent_cards", :force => true do |t|
    t.integer  "from_user_id"
    t.integer  "to_fb_user_id", :limit => 8
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sent_cards", ["card_id"], :name => "index_sent_cards_on_card_id"
  add_index "sent_cards", ["from_user_id", "card_id", "to_fb_user_id"], :name => "index_sent_cards_on_from_user_id_and_card_id_and_to_fb_user_id"
  add_index "sent_cards", ["from_user_id", "card_id"], :name => "index_sent_cards_on_from_user_id_and_card_id"
  add_index "sent_cards", ["from_user_id"], :name => "index_sent_cards_on_from_user_id"
  add_index "sent_cards", ["to_fb_user_id"], :name => "index_sent_cards_on_to_fb_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id",                       :null => false
    t.text     "data",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "all_subdomains_valid", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["url"], :name => "index_sources_on_url", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "views_count",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.datetime "replied_at"
    t.integer  "replied_user_id"
    t.integer  "sticky",          :default => 0
    t.integer  "last_comment_id"
    t.boolean  "locked",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blocked",      :default => false
    t.boolean  "is_featured",     :default => false
    t.datetime "featured_at"
    t.integer  "flags_count",     :default => 0
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
  add_index "topics", ["user_id"], :name => "index_topics_on_user_id"

  create_table "translations", :force => true do |t|
    t.string  "key"
    t.text    "raw_key"
    t.text    "value"
    t.integer "pluralization_index", :default => 1
    t.integer "locale_id"
  end

  add_index "translations", ["locale_id", "key", "pluralization_index"], :name => "index_translations_on_locale_id_and_key_and_pluralization_index"

  create_table "tweeted_items", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", :force => true do |t|
    t.integer   "user_id",                     :limit => 8,                    :null => false
    t.integer   "facebook_user_id",            :limit => 8, :default => 0
    t.boolean   "isAppAuthorized",                          :default => false
    t.datetime  "born_at"
    t.timestamp "created_at",                                                  :null => false
    t.datetime  "updated_at"
    t.text      "bio"
    t.integer   "referred_by_user_id",         :limit => 8, :default => 0
    t.boolean   "comment_notifications",                    :default => false
    t.boolean   "receive_email_notifications",              :default => true
    t.boolean   "dont_ask_me_for_email",                    :default => false
    t.datetime  "email_last_ask"
    t.boolean   "dont_ask_me_invite_friends",               :default => false
    t.datetime  "invite_last_ask"
    t.boolean   "post_comments",                            :default => true
    t.boolean   "post_likes",                               :default => true
    t.boolean   "post_items",                               :default => true
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_infos_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "ncu_id",                      :limit => 8,  :default => 0
    t.string   "name",                                      :default => ""
    t.string   "email",                                     :default => ""
    t.boolean  "is_admin",                                  :default => false
    t.boolean  "is_blocked",                                :default => false
    t.integer  "vote_power",                                :default => 1
    t.string   "remoteStatus",                              :default => "noverify"
    t.boolean  "is_member",                                 :default => false
    t.boolean  "is_moderator",                              :default => false
    t.boolean  "is_sponsor",                                :default => false
    t.boolean  "is_email_verified",                         :default => false
    t.boolean  "is_researcher",                             :default => false
    t.boolean  "accept_rules",                              :default => false
    t.boolean  "opt_in_study",                              :default => true
    t.boolean  "opt_in_email",                              :default => true
    t.boolean  "opt_in_profile",                            :default => true
    t.boolean  "opt_in_feed",                               :default => true
    t.boolean  "opt_in_sms",                                :default => true
    t.datetime "created_at"
    t.string   "eligibility",                               :default => "team"
    t.integer  "cachedPointTotal",                          :default => 0
    t.integer  "cachedPointsEarned",                        :default => 0
    t.integer  "cachedPointsEarnedThisWeek",                :default => 0
    t.integer  "cachedPointsEarnedLastWeek",                :default => 0
    t.integer  "cachedStoriesPosted",                       :default => 0
    t.integer  "cachedCommentsPosted",                      :default => 0
    t.string   "userLevel",                   :limit => 25, :default => "reader"
    t.string   "login",                       :limit => 40
    t.string   "crypted_password",            :limit => 40
    t.string   "salt",                        :limit => 40
    t.datetime "updated_at"
    t.string   "remember_token",              :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "fb_user_id",                  :limit => 8
    t.string   "email_hash"
    t.string   "cached_slug"
    t.integer  "karma_score",                               :default => 0
    t.datetime "last_active"
    t.boolean  "is_editor",                                 :default => false
    t.boolean  "is_robot",                                  :default => false
    t.integer  "posts_count",                               :default => 0
    t.integer  "last_viewed_feed_item_id"
    t.integer  "last_delivered_feed_item_id"
    t.boolean  "is_host",                                   :default => false
    t.integer  "activity_score",                            :default => 0
    t.string   "fb_oauth_key"
    t.datetime "fb_oauth_denied_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["posts_count"], :name => "index_users_on_posts_count"

  create_table "videos", :force => true do |t|
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.integer  "user_id"
    t.string   "remote_video_url"
    t.boolean  "is_blocked",        :default => false
    t.text     "description"
    t.text     "embed_code"
    t.string   "embed_src"
    t.string   "remote_video_type"
    t.string   "remote_video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_tally",       :default => 0
    t.string   "title"
    t.integer  "source_id"
  end

  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"
  add_index "videos", ["videoable_type", "videoable_id"], :name => "index_videos_on_videoable_type_and_videoable_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

  create_table "widget_pages", :force => true do |t|
    t.integer  "widget_id"
    t.integer  "parent_id"
    t.string   "widget_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
  end

  add_index "widget_pages", ["name"], :name => "index_widget_pages_on_name"
  add_index "widget_pages", ["parent_id"], :name => "index_widget_pages_on_parent_id"
  add_index "widget_pages", ["widget_id"], :name => "index_widget_pages_on_widget_id"
  add_index "widget_pages", ["widget_type"], :name => "index_widget_pages_on_widget_type"

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.string   "load_functions"
    t.string   "locals"
    t.string   "partial"
    t.string   "content_type"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "widgets", ["name"], :name => "index_widgets_on_name"

end
