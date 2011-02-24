Feature: Classified Authorization
	In order to ensure the appropriate classified authorizations are maintained
	As a user
	I want to verify the user state authorizations

	Three allow types, all, friends and friends of friends. All allows any user to grab
	the items, except for a loaner item, which requires the user to be a member of the
	community. User types are owner (Owner of the classified in question), generic (a non
	associated member of the community), anonymous (a non logged in user), friend (a friend
	of the owner of the classified), friend_of_friend (a friend of a friend (2 levels deep)
	of the owner of the classified.

	Scenario Outline: view classified authorization
		Given a user exists
		And a <user_status> classifed user exists
		And a classified exists with aasm_state: "<aasm_state>", listing_type: "<listing_type>", allow: "<allow>", user: the user
		Then the user is_allowed? should return "<is_allowed>"
		Then the user should be able to view the page: <is_allowed>

		Scenarios: STATE:: available
			| aasm_state | user_status      | listing_type | allow              | is_allowed |
			| available  | owner            | sale         | all                | true       |
			| available  | owner            | sale         | friends            | true       |
			| available  | owner            | sale         | friends_of_friends | true       |
			| available  | generic          | sale         | all                | true       |
			| available  | generic          | sale         | friends            | false      |
			| available  | generic          | sale         | friends_of_friends | false      |
			| available  | anonymous        | sale         | all                | true       |
			| available  | anonymous        | sale         | friends            | false      |
			| available  | anonymous        | sale         | friends_of_friends | false      |
			| available  | friend           | sale         | all                | true       |
			| available  | friend           | sale         | friends            | true       |
			| available  | friend           | sale         | friends_of_friends | true       |
			| available  | friend_of_friend | sale         | all                | true       |
			| available  | friend_of_friend | sale         | friends            | false      |
			| available  | friend_of_friend | sale         | friends_of_friends | true       |
			| available  | owner            | loan         | all                | true       |
			| available  | owner            | loan         | friends            | true       |
			| available  | owner            | loan         | friends_of_friends | true       |
			| available  | generic          | loan         | all                | true       |
			| available  | generic          | loan         | friends            | false      |
			| available  | generic          | loan         | friends_of_friends | false      |
			| available  | anonymous        | loan         | all                | false      |
			| available  | anonymous        | loan         | friends            | false      |
			| available  | anonymous        | loan         | friends_of_friends | false      |
			| available  | friend           | loan         | all                | true       |
			| available  | friend           | loan         | friends            | true       |
			| available  | friend           | loan         | friends_of_friends | true       |
			| available  | friend_of_friend | loan         | all                | true       |
			| available  | friend_of_friend | loan         | friends            | false      |
			| available  | friend_of_friend | loan         | friends_of_friends | true       |
			| available  | owner            | free         | all                | true       |
			| available  | owner            | free         | friends            | true       |
			| available  | owner            | free         | friends_of_friends | true       |
			| available  | generic          | free         | all                | true       |
			| available  | generic          | free         | friends            | false      |
			| available  | generic          | free         | friends_of_friends | false      |
			| available  | anonymous        | free         | all                | true       |
			| available  | anonymous        | free         | friends            | false      |
			| available  | anonymous        | free         | friends_of_friends | false      |
			| available  | friend           | free         | all                | true       |
			| available  | friend           | free         | friends            | true       |
			| available  | friend           | free         | friends_of_friends | true       |
			| available  | friend_of_friend | free         | all                | true       |
			| available  | friend_of_friend | free         | friends            | false      |
			| available  | friend_of_friend | free         | friends_of_friends | true       |

		Scenarios: STATE:: unpublished
			| aasm_state  | user_status      | listing_type | allow | is_allowed |
			| unpublished | owner            | sale         | all   | true       |
			| unpublished | generic          | sale         | all   | false      |
			| unpublished | anonymous        | sale         | all   | false      |
			| unpublished | friend           | sale         | all   | false      |
			| unpublished | friend_of_friend | sale         | all   | false      |

		Scenarios: STATE:: closed
			| aasm_state | user_status      | listing_type | allow              | is_allowed |
			| closed     | owner            | sale         | all                | true       |
			| closed     | owner            | sale         | friends            | true       |
			| closed     | owner            | sale         | friends_of_friends | true       |
			| closed     | generic          | sale         | all                | true       |
			| closed     | generic          | sale         | friends            | false      |
			| closed     | generic          | sale         | friends_of_friends | false      |
			| closed     | anonymous        | sale         | all                | true       |
			| closed     | anonymous        | sale         | friends            | false      |
			| closed     | anonymous        | sale         | friends_of_friends | false      |
			| closed     | friend           | sale         | all                | true       |
			| closed     | friend           | sale         | friends            | true       |
			| closed     | friend           | sale         | friends_of_friends | true       |
			| closed     | friend_of_friend | sale         | all                | true       |
			| closed     | friend_of_friend | sale         | friends            | false      |
			| closed     | friend_of_friend | sale         | friends_of_friends | true       |
			| closed     | owner            | loan         | all                | true       |
			| closed     | owner            | loan         | friends            | true       |
			| closed     | owner            | loan         | friends_of_friends | true       |
			| closed     | generic          | loan         | all                | true       |
			| closed     | generic          | loan         | friends            | false      |
			| closed     | generic          | loan         | friends_of_friends | false      |
			| closed     | anonymous        | loan         | all                | false      |
			| closed     | anonymous        | loan         | friends            | false      |
			| closed     | anonymous        | loan         | friends_of_friends | false      |
			| closed     | friend           | loan         | all                | true       |
			| closed     | friend           | loan         | friends            | true       |
			| closed     | friend           | loan         | friends_of_friends | true       |
			| closed     | friend_of_friend | loan         | all                | true       |
			| closed     | friend_of_friend | loan         | friends            | false      |
			| closed     | friend_of_friend | loan         | friends_of_friends | true       |
			| closed     | owner            | free         | all                | true       |
			| closed     | owner            | free         | friends            | true       |
			| closed     | owner            | free         | friends_of_friends | true       |
			| closed     | generic          | free         | all                | true       |
			| closed     | generic          | free         | friends            | false      |
			| closed     | generic          | free         | friends_of_friends | false      |
			| closed     | anonymous        | free         | all                | true       |
			| closed     | anonymous        | free         | friends            | false      |
			| closed     | anonymous        | free         | friends_of_friends | false      |
			| closed     | friend           | free         | all                | true       |
			| closed     | friend           | free         | friends            | true       |
			| closed     | friend           | free         | friends_of_friends | true       |
			| closed     | friend_of_friend | free         | all                | true       |
			| closed     | friend_of_friend | free         | friends            | false      |
			| closed     | friend_of_friend | free         | friends_of_friends | true       |

		Scenarios: STATE:: expired
			| aasm_state | user_status      | listing_type | allow              | is_allowed |
			| expired    | owner            | sale         | all                | true       |
			| expired    | owner            | sale         | friends            | true       |
			| expired    | owner            | sale         | friends_of_friends | true       |
			| expired    | generic          | sale         | all                | true       |
			| expired    | generic          | sale         | friends            | false      |
			| expired    | generic          | sale         | friends_of_friends | false      |
			| expired    | anonymous        | sale         | all                | true       |
			| expired    | anonymous        | sale         | friends            | false      |
			| expired    | anonymous        | sale         | friends_of_friends | false      |
			| expired    | friend           | sale         | all                | true       |
			| expired    | friend           | sale         | friends            | true       |
			| expired    | friend           | sale         | friends_of_friends | true       |
			| expired    | friend_of_friend | sale         | all                | true       |
			| expired    | friend_of_friend | sale         | friends            | false      |
			| expired    | friend_of_friend | sale         | friends_of_friends | true       |
			| expired    | owner            | loan         | all                | true       |
			| expired    | owner            | loan         | friends            | true       |
			| expired    | owner            | loan         | friends_of_friends | true       |
			| expired    | generic          | loan         | all                | true       |
			| expired    | generic          | loan         | friends            | false      |
			| expired    | generic          | loan         | friends_of_friends | false      |
			| expired    | anonymous        | loan         | all                | false      |
			| expired    | anonymous        | loan         | friends            | false      |
			| expired    | anonymous        | loan         | friends_of_friends | false      |
			| expired    | friend           | loan         | all                | true       |
			| expired    | friend           | loan         | friends            | true       |
			| expired    | friend           | loan         | friends_of_friends | true       |
			| expired    | friend_of_friend | loan         | all                | true       |
			| expired    | friend_of_friend | loan         | friends            | false      |
			| expired    | friend_of_friend | loan         | friends_of_friends | true       |
			| expired    | owner            | free         | all                | true       |
			| expired    | owner            | free         | friends            | true       |
			| expired    | owner            | free         | friends_of_friends | true       |
			| expired    | generic          | free         | all                | true       |
			| expired    | generic          | free         | friends            | false      |
			| expired    | generic          | free         | friends_of_friends | false      |
			| expired    | anonymous        | free         | all                | true       |
			| expired    | anonymous        | free         | friends            | false      |
			| expired    | anonymous        | free         | friends_of_friends | false      |
			| expired    | friend           | free         | all                | true       |
			| expired    | friend           | free         | friends            | true       |
			| expired    | friend           | free         | friends_of_friends | true       |
			| expired    | friend_of_friend | free         | all                | true       |
			| expired    | friend_of_friend | free         | friends            | false      |
			| expired    | friend_of_friend | free         | friends_of_friends | true       |

		Scenarios: STATE:: sold
			| aasm_state | user_status      | listing_type | allow              | is_allowed |
			| sold       | owner            | sale         | all                | true       |
			| sold       | owner            | sale         | friends            | true       |
			| sold       | owner            | sale         | friends_of_friends | true       |
			| sold       | generic          | sale         | all                | true       |
			| sold       | generic          | sale         | friends            | false      |
			| sold       | generic          | sale         | friends_of_friends | false      |
			| sold       | anonymous        | sale         | all                | true       |
			| sold       | anonymous        | sale         | friends            | false      |
			| sold       | anonymous        | sale         | friends_of_friends | false      |
			| sold       | friend           | sale         | all                | true       |
			| sold       | friend           | sale         | friends            | true       |
			| sold       | friend           | sale         | friends_of_friends | true       |
			| sold       | friend_of_friend | sale         | all                | true       |
			| sold       | friend_of_friend | sale         | friends            | false      |
			| sold       | friend_of_friend | sale         | friends_of_friends | true       |

		Scenarios: STATE:: hidden
			| aasm_state | user_status      | listing_type | allow | is_allowed |
			| hidden     | owner            | sale         | all   | true       |
			| hidden     | generic          | sale         | all   | false      |
			| hidden     | anonymous        | sale         | all   | false      |
			| hidden     | friend           | sale         | all   | false      |
			| hidden     | friend_of_friend | sale         | all   | false      |

		Scenarios: STATE:: loaned_out
			| aasm_state | user_status      | listing_type | allow              | is_allowed |
			| available  | owner            | loan         | all                | true       |
			| available  | owner            | loan         | friends            | true       |
			| available  | owner            | loan         | friends_of_friends | true       |
			| available  | generic          | loan         | all                | true       |
			| available  | generic          | loan         | friends            | false      |
			| available  | generic          | loan         | friends_of_friends | false      |
			| available  | anonymous        | loan         | all                | false      |
			| available  | anonymous        | loan         | friends            | false      |
			| available  | anonymous        | loan         | friends_of_friends | false      |
			| available  | friend           | loan         | all                | true       |
			| available  | friend           | loan         | friends            | true       |
			| available  | friend           | loan         | friends_of_friends | true       |
			| available  | friend_of_friend | loan         | all                | true       |
			| available  | friend_of_friend | loan         | friends            | false      |
			| available  | friend_of_friend | loan         | friends_of_friends | true       |
