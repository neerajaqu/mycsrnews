CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mode` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'rotate',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `answers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT '0',
  `user_id` bigint(20) unsigned DEFAULT '0',
  `answer` text COLLATE utf8_bin,
  `votes_tally` int(4) DEFAULT '0',
  `comments_count` int(4) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answers_on_user_id` (`user_id`),
  KEY `index_answers_on_question_id` (`question_id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_draft` tinyint(1) DEFAULT '0',
  `preamble` text COLLATE utf8_unicode_ci,
  `preamble_complete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `audios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `audioable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `audioable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `artist` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `album` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `caption` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `source_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_audios_on_audioable_type_and_audioable_id` (`audioable_type`,`audioable_id`),
  KEY `index_audios_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `long_caption` text COLLATE utf8_unicode_ci,
  `points` int(11) DEFAULT '0',
  `slug_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `not_sendable` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `sent_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `chirps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `classifieds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_classifieds_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentid` int(11) DEFAULT '0',
  `commentable_id` int(11) DEFAULT '0',
  `contentid` int(11) DEFAULT '0',
  `comments` text COLLATE utf8_bin,
  `postedByName` varchar(255) COLLATE utf8_bin DEFAULT '',
  `postedById` int(11) DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commentable_type_and_commentable_id` (`commentable_type`,`commentable_id`),
  KEY `index_comments_on_commentable_type` (`commentable_type`)
) ENGINE=MyISAM AUTO_INCREMENT=412 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `consumer_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_consumer_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `content_images` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `content_id` int(11) unsigned DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `siteContentId` (`content_id`),
  KEY `index_content_images_on_content_id` (`content_id`)
) ENGINE=MyISAM AUTO_INCREMENT=736 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `caption` text,
  `url` varchar(255) DEFAULT '',
  `permalink` varchar(255) DEFAULT '',
  `postedById` int(11) DEFAULT '0',
  `postedByName` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `score` int(4) DEFAULT '0',
  `numComments` int(2) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `imageid` int(11) DEFAULT '0',
  `videoIntroId` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `widgetid` int(11) DEFAULT '0',
  `isBlogEntry` tinyint(1) DEFAULT '0',
  `isFeatureCandidate` tinyint(1) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `article_id` int(11) DEFAULT NULL,
  `cached_slug` varchar(255) DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `newswire_id` int(11) DEFAULT NULL,
  `story_type` varchar(255) DEFAULT 'story',
  `summary` varchar(255) DEFAULT NULL,
  `full_html` text,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `index_contents_on_story_type` (`story_type`),
  FULLTEXT KEY `relatedText` (`title`),
  FULLTEXT KEY `relatedItems` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=2792 DEFAULT CHARSET=utf8;

CREATE TABLE `dashboard_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `news_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tagline` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic_big` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic_small` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `event_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_subtype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privacy_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `isApproved` tinyint(1) DEFAULT NULL,
  `nid` int(11) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `votes_tally` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `flags_count` int(11) DEFAULT '0',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alt_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_events_on_eid` (`eid`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `fbSessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `fbId` bigint(20) DEFAULT '0',
  `fb_sig_session_key` varchar(255) COLLATE utf8_bin DEFAULT '',
  `fb_sig_time` datetime DEFAULT NULL,
  `fb_sig_expires` datetime DEFAULT NULL,
  `fb_sig_profile_update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=263 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `featured_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `featurable_id` int(11) DEFAULT NULL,
  `featurable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `featured_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_featured_items_on_featurable_type_and_featurable_id` (`featurable_type`,`featurable_id`),
  KEY `index_featured_items_on_name` (`name`),
  KEY `index_featured_items_on_featured_type` (`featured_type`),
  KEY `index_featured_items_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `feeds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `wireid` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `rss` varchar(255) COLLATE utf8_bin DEFAULT '',
  `last_fetched_at` datetime DEFAULT NULL,
  `feedType` varchar(255) COLLATE utf8_bin DEFAULT 'wire',
  `specialType` varchar(255) COLLATE utf8_bin DEFAULT 'default',
  `loadOptions` varchar(255) COLLATE utf8_bin DEFAULT 'none',
  `user_id` bigint(20) DEFAULT '0',
  `tagList` varchar(255) COLLATE utf8_bin DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `load_all` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_feeds_on_deleted_at` (`deleted_at`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flag_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `flaggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flaggable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_flags_on_flaggable_type_and_flaggable_id` (`flaggable_type`,`flaggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `forums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `topics_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `position` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `galleries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_galleries_on_user_id` (`user_id`),
  KEY `index_galleries_on_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=951 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gallery_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galleryable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `galleryable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `gallery_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `caption` text COLLATE utf8_unicode_ci,
  `item_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gallery_items_on_user_id` (`user_id`),
  KEY `index_gallery_items_on_cached_slug` (`cached_slug`),
  KEY `index_gallery_items_on_title` (`title`),
  KEY `index_gallery_items_on_gallery_id` (`gallery_id`),
  KEY `index_gallery_items_on_galleryable_type_and_galleryable_id` (`galleryable_type`,`galleryable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1343 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `idea_boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ideas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `details` text,
  `old_tag_id` int(11) DEFAULT '0',
  `old_video_id` int(11) DEFAULT '0',
  `votes_tally` int(4) DEFAULT '0',
  `comments_count` int(4) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `idea_board_id` int(11) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `related` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imageable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imageable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `remote_image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_images_on_imageable_type_and_imageable_id` (`imageable_type`,`imageable_id`),
  KEY `index_images_on_user_id` (`user_id`),
  KEY `index_images_on_remote_image_url` (`remote_image_url`)
) ENGINE=InnoDB AUTO_INCREMENT=2589 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `locales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locales_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `metadatas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `metadatable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadatable_id` int(11) DEFAULT NULL,
  `key_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `key_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key_sub_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_metadatas_on_metadatable_type_and_metadatable_id` (`metadatable_type`,`metadatable_id`),
  KEY `index_metadatas_on_key_type_and_key_name` (`key_type`,`key_name`),
  KEY `index_metadatas_on_key_name` (`key_name`),
  KEY `index_metadatas_on_key_type_and_key_sub_type_and_key_name` (`key_type`,`key_sub_type`,`key_name`)
) ENGINE=InnoDB AUTO_INCREMENT=374 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `newswires` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `caption` text COLLATE utf8_bin,
  `source` varchar(150) COLLATE utf8_bin DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `wireid` int(11) DEFAULT '0',
  `feedType` varchar(255) COLLATE utf8_bin DEFAULT 'wire',
  `mediaUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `imageUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `embed` text COLLATE utf8_bin,
  `feed_id` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `read_count` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `feedid` (`feed_id`),
  KEY `index_newswires_on_title` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=138053 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `pfeed_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pfeed_receiver_id` int(11) DEFAULT NULL,
  `pfeed_receiver_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pfeed_item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=481 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pfeed_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `participant_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `expiry` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=465 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'open',
  `user_id` int(11) DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT '1',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `prediction_questions_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_guesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_question_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `guess` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guess_numeric` int(11) DEFAULT NULL,
  `guess_date` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_group_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prediction_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `choices` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'open',
  `user_id` int(11) DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT '1',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `prediction_guesses_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_question_id` int(11) DEFAULT NULL,
  `result` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `is_accepted` tinyint(1) DEFAULT '0',
  `accepted_at` datetime DEFAULT NULL,
  `accepted_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `alternate_result` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `guess_count` int(11) DEFAULT NULL,
  `correct_count` int(11) DEFAULT NULL,
  `accuracy` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `questions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT '0',
  `question` varchar(255) DEFAULT '',
  `details` text,
  `votes_tally` int(4) DEFAULT '0',
  `comments_count` int(4) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `answers_count` int(4) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_questions_on_user_id` (`user_id`),
  FULLTEXT KEY `related` (`question`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

CREATE TABLE `related_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `relatable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `resource_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitterName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `votes_tally` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `resource_section_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_sponsored` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `scorable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scorable_id` int(11) DEFAULT NULL,
  `score_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scores_on_scorable_type_and_scorable_id` (`scorable_type`,`scorable_id`),
  KEY `index_scores_on_scorable_type` (`scorable_type`),
  KEY `index_scores_on_user_id` (`user_id`),
  KEY `index_scores_on_score_type` (`score_type`),
  KEY `index_scores_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=837 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sent_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user_id` int(11) DEFAULT NULL,
  `to_fb_user_id` bigint(20) DEFAULT NULL,
  `card_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_sent_cards_on_card_id` (`card_id`),
  KEY `index_sent_cards_on_from_user_id` (`from_user_id`),
  KEY `index_sent_cards_on_to_fb_user_id` (`to_fb_user_id`),
  KEY `index_sent_cards_on_from_user_id_and_card_id` (`from_user_id`,`card_id`),
  KEY `index_sent_cards_on_from_user_id_and_card_id_and_to_fb_user_id` (`from_user_id`,`card_id`,`to_fb_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=16400 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sluggable_id` int(11) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_n_s_s_and_s` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7230 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `all_subdomains_valid` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sources_on_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `replied_at` datetime DEFAULT NULL,
  `replied_user_id` int(11) DEFAULT NULL,
  `sticky` int(11) DEFAULT '0',
  `last_comment_id` int(11) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_topics_on_forum_id` (`forum_id`),
  KEY `index_topics_on_user_id` (`user_id`),
  KEY `index_topics_on_forum_id_and_replied_at` (`forum_id`,`replied_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_key` text COLLATE utf8_unicode_ci,
  `value` text COLLATE utf8_unicode_ci,
  `pluralization_index` int(11) DEFAULT '1',
  `locale_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_translations_on_locale_id_and_key_and_pluralization_index` (`locale_id`,`key`,`pluralization_index`)
) ENGINE=InnoDB AUTO_INCREMENT=2469 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweeted_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `facebook_user_id` bigint(20) DEFAULT '0',
  `isAppAuthorized` tinyint(1) DEFAULT '0',
  `born_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `bio` text,
  `referred_by_user_id` bigint(20) unsigned DEFAULT '0',
  `comment_notifications` tinyint(1) DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receive_email_notifications` tinyint(1) DEFAULT '1',
  `dont_ask_me_for_email` tinyint(1) DEFAULT '0',
  `email_last_ask` datetime DEFAULT NULL,
  `dont_ask_me_invite_friends` tinyint(1) DEFAULT '0',
  `invite_last_ask` datetime DEFAULT NULL,
  `post_comments` tinyint(1) DEFAULT '1',
  `post_likes` tinyint(1) DEFAULT '1',
  `post_items` tinyint(1) DEFAULT '1',
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_infos_on_user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2865 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ncu_id` bigint(20) DEFAULT '0',
  `name` varchar(255) COLLATE utf8_bin DEFAULT '',
  `email` varchar(255) COLLATE utf8_bin DEFAULT '',
  `is_admin` tinyint(1) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `vote_power` int(2) DEFAULT '1',
  `remoteStatus` varchar(255) COLLATE utf8_bin DEFAULT 'noverify',
  `is_member` tinyint(1) DEFAULT '0',
  `is_moderator` tinyint(1) DEFAULT '0',
  `is_sponsor` tinyint(1) DEFAULT '0',
  `is_email_verified` tinyint(1) DEFAULT '0',
  `is_researcher` tinyint(1) DEFAULT '0',
  `accept_rules` tinyint(1) DEFAULT '0',
  `opt_in_study` tinyint(1) DEFAULT '1',
  `opt_in_email` tinyint(1) DEFAULT '1',
  `opt_in_profile` tinyint(1) DEFAULT '1',
  `opt_in_feed` tinyint(1) DEFAULT '1',
  `opt_in_sms` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `eligibility` varchar(255) COLLATE utf8_bin DEFAULT 'team',
  `cachedPointTotal` int(4) DEFAULT '0',
  `cachedPointsEarned` int(4) DEFAULT '0',
  `cachedPointsEarnedThisWeek` int(4) DEFAULT '0',
  `cachedPointsEarnedLastWeek` int(4) DEFAULT '0',
  `cachedStoriesPosted` int(4) DEFAULT '0',
  `cachedCommentsPosted` int(4) DEFAULT '0',
  `userLevel` varchar(25) COLLATE utf8_bin DEFAULT 'reader',
  `login` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `fb_user_id` bigint(20) DEFAULT NULL,
  `email_hash` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `karma_score` int(11) DEFAULT '0',
  `last_active` datetime DEFAULT NULL,
  `is_editor` tinyint(1) DEFAULT '0',
  `is_robot` tinyint(1) DEFAULT '0',
  `posts_count` int(11) DEFAULT '0',
  `last_viewed_feed_item_id` int(11) DEFAULT NULL,
  `last_delivered_feed_item_id` int(11) DEFAULT NULL,
  `is_host` tinyint(1) DEFAULT '0',
  `activity_score` int(11) DEFAULT '0',
  `fb_oauth_key` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `fb_oauth_denied_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`),
  KEY `index_users_on_posts_count` (`posts_count`)
) ENGINE=MyISAM AUTO_INCREMENT=2922 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `videoable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `videoable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `remote_video_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci,
  `embed_code` text COLLATE utf8_unicode_ci,
  `embed_src` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_video_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_video_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `thumb_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video_processing` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_videos_on_videoable_type_and_videoable_id` (`videoable_type`,`videoable_id`),
  KEY `index_videos_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vote` tinyint(1) DEFAULT '0',
  `voteable_id` int(11) NOT NULL,
  `voteable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `voter_id` int(11) DEFAULT NULL,
  `voter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_voters` (`voter_id`,`voter_type`),
  KEY `fk_voteables` (`voteable_id`,`voteable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=338 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widget_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `widget_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_widget_pages_on_widget_id` (`widget_id`),
  KEY `index_widget_pages_on_parent_id` (`parent_id`),
  KEY `index_widget_pages_on_widget_type` (`widget_type`),
  KEY `index_widget_pages_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=362 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `load_functions` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locals` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadata` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_widgets_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20091124161003');

INSERT INTO schema_migrations (version) VALUES ('20091124162312');

INSERT INTO schema_migrations (version) VALUES ('20091124182343');

INSERT INTO schema_migrations (version) VALUES ('20091124190738');

INSERT INTO schema_migrations (version) VALUES ('20091124204325');

INSERT INTO schema_migrations (version) VALUES ('20091124231957');

INSERT INTO schema_migrations (version) VALUES ('20091201224354');

INSERT INTO schema_migrations (version) VALUES ('20091202012039');

INSERT INTO schema_migrations (version) VALUES ('20091202064956');

INSERT INTO schema_migrations (version) VALUES ('20091203014546');

INSERT INTO schema_migrations (version) VALUES ('20091203204959');

INSERT INTO schema_migrations (version) VALUES ('20091203210908');

INSERT INTO schema_migrations (version) VALUES ('20091208012226');

INSERT INTO schema_migrations (version) VALUES ('20091208013109');

INSERT INTO schema_migrations (version) VALUES ('20091222010834');

INSERT INTO schema_migrations (version) VALUES ('20100103205822');

INSERT INTO schema_migrations (version) VALUES ('20100103215300');

INSERT INTO schema_migrations (version) VALUES ('20100103220246');

INSERT INTO schema_migrations (version) VALUES ('20100103220337');

INSERT INTO schema_migrations (version) VALUES ('20100107182956');

INSERT INTO schema_migrations (version) VALUES ('20100109003023');

INSERT INTO schema_migrations (version) VALUES ('20100111222056');

INSERT INTO schema_migrations (version) VALUES ('20100113182120');

INSERT INTO schema_migrations (version) VALUES ('20100114002308');

INSERT INTO schema_migrations (version) VALUES ('20100115011425');

INSERT INTO schema_migrations (version) VALUES ('20100118233030');

INSERT INTO schema_migrations (version) VALUES ('20100120001612');

INSERT INTO schema_migrations (version) VALUES ('20100121193612');

INSERT INTO schema_migrations (version) VALUES ('20100122011348');

INSERT INTO schema_migrations (version) VALUES ('20100204221559');

INSERT INTO schema_migrations (version) VALUES ('20100204232503');

INSERT INTO schema_migrations (version) VALUES ('20100204233243');

INSERT INTO schema_migrations (version) VALUES ('20100205014711');

INSERT INTO schema_migrations (version) VALUES ('20100205015017');

INSERT INTO schema_migrations (version) VALUES ('20100205015709');

INSERT INTO schema_migrations (version) VALUES ('20100211002808');

INSERT INTO schema_migrations (version) VALUES ('20100211013650');

INSERT INTO schema_migrations (version) VALUES ('20100211072609');

INSERT INTO schema_migrations (version) VALUES ('20100212003651');

INSERT INTO schema_migrations (version) VALUES ('20100212014901');

INSERT INTO schema_migrations (version) VALUES ('20100212220024');

INSERT INTO schema_migrations (version) VALUES ('20100212220146');

INSERT INTO schema_migrations (version) VALUES ('20100213221244');

INSERT INTO schema_migrations (version) VALUES ('20100215214122');

INSERT INTO schema_migrations (version) VALUES ('20100215224032');

INSERT INTO schema_migrations (version) VALUES ('20100216031801');

INSERT INTO schema_migrations (version) VALUES ('20100217011121');

INSERT INTO schema_migrations (version) VALUES ('20100217021117');

INSERT INTO schema_migrations (version) VALUES ('20100227021124');

INSERT INTO schema_migrations (version) VALUES ('20100227190146');

INSERT INTO schema_migrations (version) VALUES ('20100227190653');

INSERT INTO schema_migrations (version) VALUES ('20100302203538');

INSERT INTO schema_migrations (version) VALUES ('20100303014650');

INSERT INTO schema_migrations (version) VALUES ('20100303202402');

INSERT INTO schema_migrations (version) VALUES ('20100305005027');

INSERT INTO schema_migrations (version) VALUES ('20100309162706');

INSERT INTO schema_migrations (version) VALUES ('20100315185556');

INSERT INTO schema_migrations (version) VALUES ('20100315230605');

INSERT INTO schema_migrations (version) VALUES ('20100317083752');

INSERT INTO schema_migrations (version) VALUES ('20100323193005');

INSERT INTO schema_migrations (version) VALUES ('20100326220707');

INSERT INTO schema_migrations (version) VALUES ('20100405201921');

INSERT INTO schema_migrations (version) VALUES ('20100414191921');

INSERT INTO schema_migrations (version) VALUES ('20100419192519');

INSERT INTO schema_migrations (version) VALUES ('20100420011145');

INSERT INTO schema_migrations (version) VALUES ('20100507001639');

INSERT INTO schema_migrations (version) VALUES ('20100513191243');

INSERT INTO schema_migrations (version) VALUES ('20100513204141');

INSERT INTO schema_migrations (version) VALUES ('20100513220901');

INSERT INTO schema_migrations (version) VALUES ('20100516002048');

INSERT INTO schema_migrations (version) VALUES ('20100519173310');

INSERT INTO schema_migrations (version) VALUES ('20100519205155');

INSERT INTO schema_migrations (version) VALUES ('20100519211150');

INSERT INTO schema_migrations (version) VALUES ('20100519223249');

INSERT INTO schema_migrations (version) VALUES ('20100520224828');

INSERT INTO schema_migrations (version) VALUES ('20100521205635');

INSERT INTO schema_migrations (version) VALUES ('20100524231011');

INSERT INTO schema_migrations (version) VALUES ('20100526231658');

INSERT INTO schema_migrations (version) VALUES ('20100608230348');

INSERT INTO schema_migrations (version) VALUES ('20100609180615');

INSERT INTO schema_migrations (version) VALUES ('20100609190538');

INSERT INTO schema_migrations (version) VALUES ('20100609190539');

INSERT INTO schema_migrations (version) VALUES ('20100611200848');

INSERT INTO schema_migrations (version) VALUES ('20100615220810');

INSERT INTO schema_migrations (version) VALUES ('20100623230028');

INSERT INTO schema_migrations (version) VALUES ('20100624005830');

INSERT INTO schema_migrations (version) VALUES ('20100629184103');

INSERT INTO schema_migrations (version) VALUES ('20100629184323');

INSERT INTO schema_migrations (version) VALUES ('20100629204741');

INSERT INTO schema_migrations (version) VALUES ('20100630164852');

INSERT INTO schema_migrations (version) VALUES ('20100630222126');

INSERT INTO schema_migrations (version) VALUES ('20100707181429');

INSERT INTO schema_migrations (version) VALUES ('20100709215511');

INSERT INTO schema_migrations (version) VALUES ('20100712194600');

INSERT INTO schema_migrations (version) VALUES ('20100712201622');

INSERT INTO schema_migrations (version) VALUES ('20100715010547');

INSERT INTO schema_migrations (version) VALUES ('20100715214727');

INSERT INTO schema_migrations (version) VALUES ('20100719210642');

INSERT INTO schema_migrations (version) VALUES ('20100725185136');

INSERT INTO schema_migrations (version) VALUES ('20100725185233');

INSERT INTO schema_migrations (version) VALUES ('20100725185245');

INSERT INTO schema_migrations (version) VALUES ('20100725185301');

INSERT INTO schema_migrations (version) VALUES ('20100729204126');

INSERT INTO schema_migrations (version) VALUES ('20100730233038');

INSERT INTO schema_migrations (version) VALUES ('20100731065950');

INSERT INTO schema_migrations (version) VALUES ('20100801015214');

INSERT INTO schema_migrations (version) VALUES ('20100811214903');

INSERT INTO schema_migrations (version) VALUES ('20100823172428');

INSERT INTO schema_migrations (version) VALUES ('20100823173716');

INSERT INTO schema_migrations (version) VALUES ('20100823190356');

INSERT INTO schema_migrations (version) VALUES ('20100826201801');

INSERT INTO schema_migrations (version) VALUES ('20100907214306');

INSERT INTO schema_migrations (version) VALUES ('20100915230718');

INSERT INTO schema_migrations (version) VALUES ('20101025174437');

INSERT INTO schema_migrations (version) VALUES ('20101025175337');

INSERT INTO schema_migrations (version) VALUES ('20101027210642');

INSERT INTO schema_migrations (version) VALUES ('20101027210809');

INSERT INTO schema_migrations (version) VALUES ('20101109205202');

INSERT INTO schema_migrations (version) VALUES ('20101216230321');

INSERT INTO schema_migrations (version) VALUES ('20101218000625');

INSERT INTO schema_migrations (version) VALUES ('20101221232829');

INSERT INTO schema_migrations (version) VALUES ('20101223190321');

INSERT INTO schema_migrations (version) VALUES ('20101223233329');

INSERT INTO schema_migrations (version) VALUES ('20110107194323');

INSERT INTO schema_migrations (version) VALUES ('20110114011317');

INSERT INTO schema_migrations (version) VALUES ('20110122012647');

INSERT INTO schema_migrations (version) VALUES ('20110202235232');