CREATE TABLE `AdCode` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `code` text COLLATE utf8_bin,
  `site` varchar(50) COLLATE utf8_bin DEFAULT '',
  `clientid` int(11) DEFAULT '0',
  `format` varchar(50) COLLATE utf8_bin DEFAULT '',
  `locale` varchar(100) COLLATE utf8_bin DEFAULT '',
  `codeType` enum('html','iframe') COLLATE utf8_bin DEFAULT 'iframe',
  `impRemaining` bigint(20) DEFAULT '0',
  `status` enum('active','completed','pending') COLLATE utf8_bin DEFAULT 'pending',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `AdShare` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `site` enum('default') COLLATE utf8_bin DEFAULT 'default',
  `size` enum('largeBanner','skyscraper','smallBanner','square','largeRect') COLLATE utf8_bin DEFAULT 'largeBanner',
  `src` varchar(25) COLLATE utf8_bin DEFAULT '',
  `share` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `AdTrack` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `source` varchar(150) COLLATE utf8_bin DEFAULT '',
  `userid` bigint(20) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Admin_DataStore` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT '',
  `name` varchar(255) DEFAULT '',
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `Admin_User` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `password` varchar(255) DEFAULT '',
  `userid` bigint(20) DEFAULT '0',
  `ncUid` bigint(20) DEFAULT '0',
  `level` enum('admin','researcher','moderator','sponsor') DEFAULT 'moderator',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `AskAnswers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `questionid` int(11) DEFAULT '0',
  `userid` bigint(20) unsigned DEFAULT '0',
  `answer` text COLLATE utf8_bin,
  `videoid` int(11) DEFAULT '0',
  `numLikes` int(4) DEFAULT '0',
  `numComments` int(4) DEFAULT '0',
  `dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `AskQuestions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned DEFAULT '0',
  `question` varchar(255) DEFAULT '',
  `details` text,
  `tagid` int(11) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `numLikes` int(4) DEFAULT '0',
  `numComments` int(4) DEFAULT '0',
  `dt` datetime DEFAULT NULL,
  `numAnswers` int(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `related` (`question`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

CREATE TABLE `Challenges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `shortName` varchar(25) COLLATE utf8_bin DEFAULT '',
  `description` text COLLATE utf8_bin,
  `dateStart` datetime DEFAULT NULL,
  `dateEnd` datetime DEFAULT NULL,
  `initialCompletions` int(4) DEFAULT '0',
  `remainingCompletions` int(4) DEFAULT '0',
  `maxUserCompletions` int(4) DEFAULT '0',
  `maxUserCompletionsPerDay` int(4) DEFAULT '0',
  `type` enum('automatic','submission') COLLATE utf8_bin DEFAULT 'automatic',
  `pointValue` int(4) DEFAULT '10',
  `eligibility` enum('team','general') COLLATE utf8_bin DEFAULT 'team',
  `status` enum('enabled','disabled') COLLATE utf8_bin DEFAULT 'enabled',
  `thumbnail` varchar(255) COLLATE utf8_bin DEFAULT 'default_challenge_thumb.png',
  `requires` varchar(25) COLLATE utf8_bin DEFAULT 'text',
  `isFeatured` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ChallengesCompleted` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `challengeid` int(11) DEFAULT '0',
  `dateSubmitted` datetime DEFAULT NULL,
  `dateAwarded` datetime DEFAULT NULL,
  `evidence` text COLLATE utf8_bin,
  `comments` text COLLATE utf8_bin,
  `status` enum('submitted','awarded','rejected') COLLATE utf8_bin DEFAULT 'submitted',
  `pointsAwarded` int(4) DEFAULT '10',
  `logid` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2114 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ContactEmails` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_bin DEFAULT '',
  `subject` varchar(255) COLLATE utf8_bin DEFAULT '',
  `message` text COLLATE utf8_bin,
  `userid` bigint(20) unsigned DEFAULT '0',
  `is_read` tinyint(1) DEFAULT '0',
  `replied` tinyint(1) DEFAULT '0',
  `topic` enum('general','editorial','team','feedback','bug') COLLATE utf8_bin DEFAULT 'general',
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `FeaturedTemplate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(255) COLLATE utf8_bin DEFAULT '',
  `story_1_id` int(10) unsigned DEFAULT '0',
  `story_2_id` int(10) unsigned DEFAULT '0',
  `story_3_id` int(10) unsigned DEFAULT '0',
  `story_4_id` int(10) unsigned DEFAULT '0',
  `story_5_id` int(10) unsigned DEFAULT '0',
  `story_6_id` int(10) unsigned DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `FeaturedWidgets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `widgetid` int(11) unsigned DEFAULT NULL,
  `locale` varchar(100) COLLATE utf8_bin DEFAULT '',
  `position` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `FeedMedia` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT '',
  `previewImageUrl` varchar(255) DEFAULT '',
  `imageUrl` varchar(255) DEFAULT '',
  `linkUrl` varchar(255) DEFAULT '',
  `caption` text,
  `isFeatured` tinyint(1) DEFAULT '0',
  `numLikes` int(4) DEFAULT '0',
  `numComments` int(4) DEFAULT '0',
  `mediaType` enum('image','video') DEFAULT 'image',
  `feedid` int(11) DEFAULT '0',
  `fbId` bigint(20) unsigned DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `author` varchar(99) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18451 DEFAULT CHARSET=utf8;

CREATE TABLE `FolderLinks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `linkid` int(11) NOT NULL DEFAULT '0',
  `folderid` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `notes` varchar(255) COLLATE utf8_bin DEFAULT '',
  `linkType` enum('link','product') COLLATE utf8_bin DEFAULT NULL,
  `imageUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Folders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `folderid` int(11) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL DEFAULT '0',
  `title` varchar(50) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ForumTopics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `lastChanged` datetime DEFAULT NULL,
  `numPostsToday` int(4) DEFAULT '0',
  `numViewsToday` int(4) DEFAULT '0',
  `intro` text COLLATE utf8_bin,
  `isHidden` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid1` bigint(20) DEFAULT '0',
  `action` enum('vote','comment','readStory','readWire','invite','postStory','publishWire','publishStory','shareStory','referReader','referToSite','postTwitter','signup','acceptedInvite','redeemed','wonPrize','completedChallenge','addedWidget','addedFeedHeadlines','friendSignup','addBookmarkTool','levelIncrease','sessionsRecent','sessionsHour','pageAdd','chatStory','postBlog','sendCard','askQuestion','answerQuestion','likeQuestion','likeAnswer','likeIdea','likeStuff','addStuff','storyFeatured','madePredict') COLLATE utf8_bin DEFAULT 'readStory',
  `itemid` int(11) DEFAULT '0',
  `itemid2` int(11) DEFAULT '0',
  `userid2` bigint(20) DEFAULT '0',
  `ncUid` bigint(20) DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateCreated` datetime DEFAULT NULL,
  `status` enum('pending','ok','error') COLLATE utf8_bin DEFAULT 'pending',
  `isFeedPublished` enum('pending','complete') COLLATE utf8_bin DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `userid1` (`userid1`),
  KEY `action` (`action`),
  KEY `t` (`t`),
  KEY `itemid` (`itemid`)
) ENGINE=MyISAM AUTO_INCREMENT=11512 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `LogDumps` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid1` bigint(20) DEFAULT '0',
  `action` enum('vote','comment','readStory','readWire','invite','postStory','publishWire','publishStory','shareStory','referReader','referToSite','postTwitter','signup','acceptedInvite','redeemed','wonPrize','completedChallenge','addedWidget','addedFeedHeadlines','friendSignup','addBookmarkTool','levelIncrease','sessionsRecent','sessionsHour','pageAdd','chatStory','postBlog') DEFAULT 'readStory',
  `itemid` int(11) DEFAULT '0',
  `itemid2` int(11) DEFAULT '0',
  `userid2` bigint(20) DEFAULT '0',
  `ncUid` bigint(20) DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateCreated` datetime DEFAULT NULL,
  `status` enum('pending','ok','error') DEFAULT 'pending',
  `isFeedPublished` enum('pending','complete') DEFAULT 'pending',
  `siteid` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `LogExtra` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `logid` bigint(20) DEFAULT '0',
  `txt` text COLLATE utf8_bin,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `MicroAccounts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned DEFAULT '0',
  `tag` varchar(150) DEFAULT '',
  `sid` bigint(20) unsigned DEFAULT '0',
  `shortName` varchar(150) DEFAULT '',
  `friendlyName` varchar(150) DEFAULT '',
  `profile_image_url` varchar(255) DEFAULT '',
  `service` enum('twitter') DEFAULT 'twitter',
  `isTokenValid` tinyint(1) DEFAULT '0',
  `token` varchar(60) DEFAULT '',
  `tokenSecret` varchar(60) DEFAULT '',
  `lastSync` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shortName` (`shortName`),
  KEY `tag` (`tag`)
) ENGINE=MyISAM AUTO_INCREMENT=122 DEFAULT CHARSET=utf8;

CREATE TABLE `MicroPosts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg` text,
  `numLikes` int(4) DEFAULT '0',
  `statusid` bigint(20) unsigned DEFAULT '0',
  `sid` bigint(20) unsigned DEFAULT '0',
  `dt` datetime DEFAULT NULL,
  `isFavorite` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `dt` (`dt`)
) ENGINE=MyISAM AUTO_INCREMENT=34080 DEFAULT CHARSET=utf8;

CREATE TABLE `NotificationMessages` (
  `msgid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT '0',
  `type` enum('sharedStory') COLLATE utf8_bin DEFAULT 'sharedStory',
  `itemid` int(11) DEFAULT '0',
  `subject` varchar(255) COLLATE utf8_bin DEFAULT '',
  `message` text COLLATE utf8_bin,
  `embed` text COLLATE utf8_bin,
  `dateCreated` datetime DEFAULT NULL,
  `lastAttempt` datetime DEFAULT NULL,
  `status` enum('sent','pending','blocked','approved') COLLATE utf8_bin DEFAULT 'pending',
  PRIMARY KEY (`msgid`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msgid` int(11) DEFAULT '0',
  `status` enum('sent','pending','error','opened') COLLATE utf8_bin DEFAULT 'pending',
  `userid` int(11) DEFAULT '0',
  `dateSent` datetime DEFAULT NULL,
  `toUserId` int(11) DEFAULT '0',
  `toFbId` bigint(20) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `prizeid` int(11) DEFAULT '0',
  `pointCost` int(8) DEFAULT '0',
  `dateSubmitted` datetime DEFAULT NULL,
  `dateApproved` datetime DEFAULT NULL,
  `dateShipped` datetime DEFAULT NULL,
  `dateCanceled` datetime DEFAULT NULL,
  `dateRefunded` datetime DEFAULT NULL,
  `reviewedBy` varchar(255) COLLATE utf8_bin DEFAULT '',
  `status` enum('submitted','approved','shipped','canceled','refunded') COLLATE utf8_bin DEFAULT 'submitted',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `OutboundMessages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userIntro` varchar(255) COLLATE utf8_bin DEFAULT '',
  `msgType` enum('notification','announce') COLLATE utf8_bin DEFAULT 'announce',
  `subject` varchar(255) COLLATE utf8_bin DEFAULT '',
  `msgBody` text COLLATE utf8_bin,
  `buttonLinkText` varchar(255) COLLATE utf8_bin DEFAULT '',
  `closingLinkText` varchar(255) COLLATE utf8_bin DEFAULT '',
  `shortLink` varchar(25) COLLATE utf8_bin DEFAULT '',
  `userGroup` varchar(255) COLLATE utf8_bin DEFAULT '',
  `userid` bigint(20) unsigned DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('sent','pending','hold','incomplete') COLLATE utf8_bin DEFAULT 'pending',
  `usersReceived` text COLLATE utf8_bin,
  `numUsersReceived` int(11) unsigned DEFAULT '0',
  `numUsersExpected` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Photos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `shortName` varchar(25) COLLATE utf8_bin DEFAULT '',
  `description` text COLLATE utf8_bin,
  `dateCreated` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT '0',
  `status` enum('approved','pending','blocked') COLLATE utf8_bin DEFAULT 'pending',
  `filename` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `challengeCompletedId` int(11) unsigned DEFAULT NULL,
  `localFilename` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Prizes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `shortName` varchar(25) COLLATE utf8_bin DEFAULT '',
  `description` text COLLATE utf8_bin,
  `sponsor` varchar(150) COLLATE utf8_bin DEFAULT '',
  `sponsorUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `dateStart` datetime DEFAULT NULL,
  `dateEnd` datetime DEFAULT NULL,
  `initialStock` int(4) DEFAULT '0',
  `currentStock` int(4) DEFAULT '0',
  `pointCost` int(4) DEFAULT '1000',
  `eligibility` enum('team','general') COLLATE utf8_bin DEFAULT 'team',
  `userMaximum` int(4) DEFAULT '0',
  `status` enum('enabled','disabled','hold') COLLATE utf8_bin DEFAULT 'enabled',
  `orderFieldsNeeded` varchar(150) COLLATE utf8_bin DEFAULT 'name address phone email',
  `thumbnail` varchar(255) COLLATE utf8_bin DEFAULT 'default_prize_thumb.png',
  `isWeekly` tinyint(1) DEFAULT '0',
  `isGrand` tinyint(1) DEFAULT '0',
  `isFeatured` tinyint(1) DEFAULT '0',
  `dollarValue` int(6) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `RawExtLinks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(255) DEFAULT '',
  `str` varchar(255) DEFAULT '',
  `qs` text,
  `itemid` bigint(20) unsigned DEFAULT '0',
  `itemid2` bigint(20) unsigned DEFAULT '0',
  `userid` bigint(20) unsigned DEFAULT '0',
  `siteid` bigint(20) unsigned DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `RawSessions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fb_sig_session_key` varchar(255) DEFAULT '',
  `fb_sig_time` datetime DEFAULT NULL,
  `fb_sig_expires` datetime DEFAULT NULL,
  `fb_sig_update_time` datetime DEFAULT NULL,
  `qs` text,
  `userid` bigint(20) unsigned DEFAULT '0',
  `siteid` bigint(20) unsigned DEFAULT '0',
  `fbId` bigint(20) unsigned DEFAULT '0',
  `sessionTableId` bigint(20) unsigned DEFAULT '0',
  `t` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `SessionLengths` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `session_length` varchar(255) DEFAULT '',
  `avg_click_rate` varchar(255) DEFAULT '',
  `userid` bigint(20) unsigned DEFAULT '0',
  `siteid` bigint(20) unsigned DEFAULT '0',
  `total_actions` int(11) DEFAULT '0',
  `start_session` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `end_session` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `Sites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `dbname` varchar(255) DEFAULT '',
  `shortname` varchar(255) DEFAULT '',
  `description` text,
  `url` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `Subscriptions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `rxFeatures` tinyint(1) DEFAULT '0',
  `rxMode` enum('notification','sms','email') COLLATE utf8_bin DEFAULT 'notification',
  `lastFeatureSent` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=361 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `SurveyMonkeys` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT '',
  `userid` bigint(20) unsigned DEFAULT '0',
  `siteid` bigint(20) unsigned DEFAULT '0',
  `q1a` tinyint(1) DEFAULT '0',
  `q1b` tinyint(1) DEFAULT '0',
  `q1c` tinyint(1) DEFAULT '0',
  `q1d` tinyint(1) DEFAULT '0',
  `q1e` tinyint(1) DEFAULT '0',
  `q1f` tinyint(1) DEFAULT '0',
  `q1g` tinyint(1) DEFAULT '0',
  `q2a` tinyint(1) DEFAULT '0',
  `q2b` tinyint(1) DEFAULT '0',
  `q2c` tinyint(1) DEFAULT '0',
  `q2d` tinyint(1) DEFAULT '0',
  `q2e` tinyint(1) DEFAULT '0',
  `q3a` tinyint(1) DEFAULT '0',
  `q3b` tinyint(1) DEFAULT '0',
  `q3c` tinyint(1) DEFAULT '0',
  `q3d` tinyint(1) DEFAULT '0',
  `q3e` tinyint(1) DEFAULT '0',
  `q3f` tinyint(1) DEFAULT '0',
  `q3g` tinyint(1) DEFAULT '0',
  `q3h` tinyint(1) DEFAULT '0',
  `q4a` tinyint(1) DEFAULT '0',
  `q4b` tinyint(1) DEFAULT '0',
  `q4c` tinyint(1) DEFAULT '0',
  `q4d` tinyint(1) DEFAULT '0',
  `q4e` tinyint(1) DEFAULT '0',
  `q4f` tinyint(1) DEFAULT '0',
  `q4g` tinyint(1) DEFAULT '0',
  `q5a` tinyint(1) DEFAULT '0',
  `q5b` tinyint(1) DEFAULT '0',
  `q5c` tinyint(1) DEFAULT '0',
  `q5d` tinyint(1) DEFAULT '0',
  `q5e` tinyint(1) DEFAULT '0',
  `q5f` tinyint(1) DEFAULT '0',
  `q5g` tinyint(1) DEFAULT '0',
  `q5h` tinyint(1) DEFAULT '0',
  `q5i` tinyint(1) DEFAULT '0',
  `q5j` tinyint(1) DEFAULT '0',
  `q5k` tinyint(1) DEFAULT '0',
  `q6` tinyint(1) DEFAULT '0',
  `q7` tinyint(1) DEFAULT '0',
  `q8a` tinyint(1) DEFAULT '0',
  `q8b` tinyint(1) DEFAULT '0',
  `q8c` tinyint(1) DEFAULT '0',
  `q8d` tinyint(1) DEFAULT '0',
  `q8e` tinyint(1) DEFAULT '0',
  `q8f` tinyint(1) DEFAULT '0',
  `q8g` tinyint(1) DEFAULT '0',
  `q8h` tinyint(1) DEFAULT '0',
  `q9a` tinyint(1) DEFAULT '0',
  `q9b` tinyint(1) DEFAULT '0',
  `q9c` tinyint(1) DEFAULT '0',
  `q9d` tinyint(1) DEFAULT '0',
  `q9e` tinyint(1) DEFAULT '0',
  `q9f` tinyint(1) DEFAULT '0',
  `q10a` tinyint(1) DEFAULT '0',
  `q10b` tinyint(1) DEFAULT '0',
  `q10c` tinyint(1) DEFAULT '0',
  `q10d` tinyint(1) DEFAULT '0',
  `q10e` tinyint(1) DEFAULT '0',
  `q10f` tinyint(1) DEFAULT '0',
  `q11a` tinyint(1) DEFAULT '0',
  `q11b` tinyint(1) DEFAULT '0',
  `q11c` tinyint(1) DEFAULT '0',
  `q11d` tinyint(1) DEFAULT '0',
  `q11e` tinyint(1) DEFAULT '0',
  `q11f` tinyint(1) DEFAULT '0',
  `q11g` tinyint(1) DEFAULT '0',
  `q11h` tinyint(1) DEFAULT '0',
  `q12a` tinyint(1) DEFAULT '0',
  `q12b` tinyint(1) DEFAULT '0',
  `q12c` tinyint(1) DEFAULT '0',
  `q12d` tinyint(1) DEFAULT '0',
  `q12e` tinyint(1) DEFAULT '0',
  `q12f` tinyint(1) DEFAULT '0',
  `q12g` tinyint(1) DEFAULT '0',
  `q12h` tinyint(1) DEFAULT '0',
  `q13a` tinyint(1) DEFAULT '0',
  `q13b` tinyint(1) DEFAULT '0',
  `q13c` tinyint(1) DEFAULT '0',
  `q13d` tinyint(1) DEFAULT '0',
  `q14a` tinyint(1) DEFAULT '0',
  `q14b` tinyint(1) DEFAULT '0',
  `q14c` tinyint(1) DEFAULT '0',
  `q14d` tinyint(1) DEFAULT '0',
  `q14e` tinyint(1) DEFAULT '0',
  `q14f` tinyint(1) DEFAULT '0',
  `q15` tinyint(1) DEFAULT '0',
  `q16` tinyint(1) DEFAULT '0',
  `q17a` tinyint(1) DEFAULT '0',
  `q17b` tinyint(1) DEFAULT '0',
  `q17c` tinyint(1) DEFAULT '0',
  `q17d` tinyint(1) DEFAULT '0',
  `q17e` tinyint(1) DEFAULT '0',
  `q18` tinyint(1) DEFAULT '0',
  `q19` tinyint(1) DEFAULT '0',
  `q20` tinyint(1) DEFAULT '0',
  `q21` tinyint(1) DEFAULT '0',
  `q22` tinyint(1) DEFAULT '0',
  `q23` tinyint(1) DEFAULT '0',
  `q24` tinyint(1) DEFAULT '0',
  `q25` tinyint(1) DEFAULT '0',
  `q26` tinyint(1) DEFAULT '0',
  `q27` tinyint(1) DEFAULT '0',
  `q28a` tinyint(1) DEFAULT '0',
  `q28b` tinyint(1) DEFAULT '0',
  `q28c` tinyint(1) DEFAULT '0',
  `q28d` tinyint(1) DEFAULT '0',
  `q28e` tinyint(1) DEFAULT '0',
  `q28f` tinyint(1) DEFAULT '0',
  `q29` tinyint(1) DEFAULT '0',
  `q30` tinyint(1) DEFAULT '0',
  `q31` tinyint(1) DEFAULT '0',
  `q32` tinyint(1) DEFAULT '0',
  `q33` tinyint(1) DEFAULT '0',
  `q34` tinyint(1) DEFAULT '0',
  `q35` tinyint(1) DEFAULT '0',
  `q36` tinyint(1) DEFAULT '0',
  `q37` tinyint(1) DEFAULT '0',
  `q38a` tinyint(1) DEFAULT '0',
  `q38b` tinyint(1) DEFAULT '0',
  `q38c` tinyint(1) DEFAULT '0',
  `q38d` tinyint(1) DEFAULT '0',
  `q38e` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `SystemStatus` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(35) COLLATE utf8_bin DEFAULT '',
  `strValue` text COLLATE utf8_bin,
  `numValue` bigint(20) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `TaggedObjects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tagid` int(10) unsigned NOT NULL DEFAULT '0',
  `userid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `itemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `itemType` enum('story','ask','idea','stuff') COLLATE utf8_bin DEFAULT 'story',
  `dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `shortName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `code` blob,
  `category` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `helpString` blob,
  `hasChanged` tinyint(1) DEFAULT '0',
  `lastChange` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=551 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `UserBlogs` (
  `blogid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `siteContentId` int(11) DEFAULT '0',
  `userid` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `entry` text COLLATE utf8_bin,
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `imageUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `videoEmbed` varchar(255) COLLATE utf8_bin DEFAULT '',
  `status` enum('draft','published') COLLATE utf8_bin DEFAULT 'draft',
  PRIMARY KEY (`blogid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `UserCollectives` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `eligibility` enum('team','general','ineligible') DEFAULT 'team',
  `userid` bigint(20) unsigned DEFAULT '0',
  `siteid` bigint(20) unsigned DEFAULT '0',
  `optInStudy` tinyint(1) DEFAULT '1',
  `dateRegistered` datetime DEFAULT NULL,
  `researchImportance` tinyint(1) DEFAULT '0',
  `gender` enum('male','female','other') DEFAULT NULL,
  `age` tinyint(1) DEFAULT '0',
  `city` varchar(255) DEFAULT 'Unknown',
  `state` varchar(255) DEFAULT '',
  `country` varchar(255) DEFAULT '',
  `zip` varchar(255) DEFAULT '',
  `cachedPointTotal` int(4) DEFAULT '0',
  `email` varchar(255) DEFAULT '',
  `isMember` tinyint(1) DEFAULT '0',
  `rxConsentForm` tinyint(1) DEFAULT '0',
  `bookmarkToolAdded` varchar(10) DEFAULT '',
  `postStoryCount` int(4) DEFAULT '0',
  `postCommentCount` int(4) DEFAULT '0',
  `postBlogCount` int(4) DEFAULT '0',
  `readStoryCount` int(4) DEFAULT '0',
  `completedChallengeCount` int(4) DEFAULT '0',
  `wonPrizeCount` int(4) DEFAULT '0',
  `chatStoryCount` int(4) DEFAULT '0',
  `inviteFriendsCount` int(4) DEFAULT '0',
  `shareStoryCount` int(4) DEFAULT '0',
  `tweetCount` int(4) DEFAULT '0',
  `voteCount` int(4) DEFAULT '0',
  `friendsSignUpCount` int(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `UserInvites` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `friendFbId` bigint(20) DEFAULT '0',
  `dateInvited` datetime DEFAULT NULL,
  `dateAccepted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=248 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `Videos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `service` enum('youtube','seesmic','facebook') COLLATE utf8_bin DEFAULT 'youtube',
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `shortName` varchar(25) COLLATE utf8_bin DEFAULT '',
  `description` text COLLATE utf8_bin,
  `dateCreated` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT '0',
  `status` enum('approved','pending','blocked') COLLATE utf8_bin DEFAULT 'pending',
  `challengeCompletedId` int(11) unsigned DEFAULT NULL,
  `embedCode` text COLLATE utf8_bin,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `WeeklyScores` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `weekOf` datetime DEFAULT NULL,
  `eligibilityGroup` enum('team','general','ineligible') COLLATE utf8_bin DEFAULT 'general',
  `pointTotal` int(4) DEFAULT '10',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=375 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
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
  `date` datetime DEFAULT NULL,
  `isBlocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commentable_type_and_commentable_id` (`commentable_type`,`commentable_id`)
) ENGINE=MyISAM AUTO_INCREMENT=211 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `content_images` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `content_id` int(11) unsigned DEFAULT '0',
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `siteContentId` (`content_id`),
  KEY `index_content_images_on_content_id` (`content_id`)
) ENGINE=MyISAM AUTO_INCREMENT=736 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `caption` text,
  `source` varchar(150) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `permalink` varchar(255) DEFAULT '',
  `postedById` int(11) DEFAULT '0',
  `postedByName` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `score` int(4) DEFAULT '0',
  `numComments` int(2) DEFAULT '0',
  `isFeatured` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `imageid` int(11) DEFAULT '0',
  `videoIntroId` int(11) DEFAULT '0',
  `isBlocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `widgetid` int(11) DEFAULT '0',
  `isBlogEntry` tinyint(1) DEFAULT '0',
  `isFeatureCandidate` tinyint(1) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `article_id` int(11) DEFAULT NULL,
  `cached_slug` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  FULLTEXT KEY `relatedText` (`title`),
  FULLTEXT KEY `relatedItems` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=736 DEFAULT CHARSET=utf8;

CREATE TABLE `cronJobs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `freqMinutes` int(2) DEFAULT '0',
  `task` varchar(64) COLLATE utf8_bin DEFAULT '',
  `comments` varchar(150) COLLATE utf8_bin DEFAULT '',
  `nextRun` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('enabled','disabled') COLLATE utf8_bin DEFAULT 'enabled',
  `dayOfWeek` varchar(3) COLLATE utf8_bin DEFAULT '',
  `hourOfDay` varchar(2) COLLATE utf8_bin DEFAULT '',
  `lastExecTime` int(10) DEFAULT '0',
  `isRunning` tinyint(1) DEFAULT '0',
  `lastStart` datetime DEFAULT NULL,
  `lastItemTime` datetime DEFAULT NULL,
  `failureNoticeSent` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `feeds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `wireid` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `rss` varchar(255) COLLATE utf8_bin DEFAULT '',
  `lastFetch` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `feedType` enum('blog','wire','images','miniblog','bookmarks','allowed','localBlog') COLLATE utf8_bin DEFAULT 'wire',
  `specialType` enum('flickrContent','default') COLLATE utf8_bin DEFAULT 'default',
  `loadOptions` enum('all','matches','none') COLLATE utf8_bin DEFAULT 'none',
  `user_id` bigint(20) DEFAULT '0',
  `tagList` varchar(255) COLLATE utf8_bin DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `idea_boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ideas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `details` text,
  `old_tag_id` int(11) DEFAULT '0',
  `old_video_id` int(11) DEFAULT '0',
  `likes_count` int(4) DEFAULT '0',
  `comments_count` int(4) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `idea_board_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `related` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

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

CREATE TABLE `newswires` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT '',
  `caption` text COLLATE utf8_bin,
  `source` varchar(150) COLLATE utf8_bin DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `wireid` int(11) DEFAULT '0',
  `feedType` enum('blog','wire','images','miniblog','bookmarks','allowed','localBlog') COLLATE utf8_bin DEFAULT 'wire',
  `mediaUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `imageUrl` varchar(255) COLLATE utf8_bin DEFAULT '',
  `embed` text COLLATE utf8_bin,
  `feed_id` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feedid` (`feed_id`)
) ENGINE=MyISAM AUTO_INCREMENT=21030 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitterName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `likes_count` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_infos` (
  `user_id` bigint(20) unsigned NOT NULL,
  `facebook_user_id` bigint(20) DEFAULT '0',
  `isAppAuthorized` tinyint(1) DEFAULT '0',
  `networkid` int(11) DEFAULT '0',
  `birthdate` datetime DEFAULT NULL,
  `age` tinyint(1) DEFAULT '0',
  `rxConsentForm` tinyint(1) DEFAULT '0',
  `gender` enum('male','female','other') DEFAULT NULL,
  `researchImportance` tinyint(1) DEFAULT '0',
  `dateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lastUpdated` datetime DEFAULT NULL,
  `friends` text,
  `memberFriends` text,
  `numFriends` int(4) DEFAULT '0',
  `numMemberFriends` int(4) DEFAULT '0',
  `lastInvite` datetime DEFAULT NULL,
  `lastProfileUpdate` datetime DEFAULT NULL,
  `lastRemoteSyncUpdate` datetime DEFAULT NULL,
  `interests` text,
  `bio` text,
  `phone` varchar(255) DEFAULT '',
  `address1` varchar(255) DEFAULT '',
  `address2` varchar(255) DEFAULT '',
  `city` varchar(255) DEFAULT 'Unknown',
  `state` varchar(255) DEFAULT '',
  `country` varchar(255) DEFAULT '',
  `zip` varchar(255) DEFAULT '',
  `refuid` bigint(20) unsigned DEFAULT '0',
  `cachedFriendsInvited` int(4) DEFAULT '0',
  `cachedChallengesCompleted` int(4) DEFAULT '0',
  `hideTipStories` tinyint(1) DEFAULT '0',
  `hideTeamIntro` tinyint(1) DEFAULT '0',
  `noCommentNotify` tinyint(1) DEFAULT '0',
  `lastUpdateLevels` datetime DEFAULT NULL,
  `lastUpdateSiteChallenges` datetime DEFAULT NULL,
  `lastUpdateCachedPointsAndChallenges` datetime DEFAULT NULL,
  `lastUpdateCachedCommentsAndStories` datetime DEFAULT NULL,
  `groups` text,
  `networks` text,
  `lastNetSync` datetime DEFAULT NULL,
  `neighborhood` varchar(100) DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_infos_on_user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=360 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ncu_id` bigint(20) DEFAULT '0',
  `name` varchar(255) COLLATE utf8_bin DEFAULT '',
  `email` varchar(255) COLLATE utf8_bin DEFAULT '',
  `is_admin` tinyint(1) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `vote_power` int(2) DEFAULT '1',
  `remoteStatus` enum('noverify','verified','purged') COLLATE utf8_bin DEFAULT 'noverify',
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
  `dateRegistered` datetime DEFAULT NULL,
  `eligibility` enum('team','general','ineligible') COLLATE utf8_bin DEFAULT 'team',
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
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `fb_user_id` bigint(20) DEFAULT NULL,
  `email_hash` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `karma_score` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=MyISAM AUTO_INCREMENT=363 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vote` tinyint(1) DEFAULT '0',
  `voteable_id` int(11) NOT NULL,
  `voteable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `voter_id` int(11) DEFAULT NULL,
  `voter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_voters` (`voter_id`,`voter_type`),
  KEY `fk_voteables` (`voteable_id`,`voteable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widget_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `widget_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_widget_pages_on_widget_id` (`widget_id`),
  KEY `index_widget_pages_on_parent_id` (`parent_id`),
  KEY `index_widget_pages_on_widget_type` (`widget_type`),
  KEY `index_widget_pages_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

INSERT INTO schema_migrations (version) VALUES ('20100112003305');

INSERT INTO schema_migrations (version) VALUES ('20100112011238');

INSERT INTO schema_migrations (version) VALUES ('20100113182120');

INSERT INTO schema_migrations (version) VALUES ('20100114002308');

INSERT INTO schema_migrations (version) VALUES ('20100115011425');

INSERT INTO schema_migrations (version) VALUES ('20100118233030');

INSERT INTO schema_migrations (version) VALUES ('20100120001612');

INSERT INTO schema_migrations (version) VALUES ('20100121193612');