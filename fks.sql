USE youtube;

ALTER TABLE channels 
	ADD CONSTRAINT channels_condition_type_id_fk
		FOREIGN KEY (condition_type_id) 
		REFERENCES condition_types(id)
		ON UPDATE CASCADE;


ALTER TABLE followers 
	ADD CONSTRAINT followers_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE;


ALTER TABLE subscriptions 
	ADD CONSTRAINT subscriptions_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT subscriptions_subscription_id_fk
		FOREIGN KEY (subscription_id)
		REFERENCES channels(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT subscriptions_subscription_status_id_fk
		FOREIGN KEY (subscription_status_id)
		REFERENCES subscription_statuses(id)
		ON UPDATE CASCADE;


ALTER TABLE playlists 
	ADD CONSTRAINT playlists_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE;


ALTER TABLE videos 
	ADD CONSTRAINT videos_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE;

	
ALTER TABLE videos_playlists 
	ADD CONSTRAINT videos_playlists_playlist_id_fk
		FOREIGN KEY (playlist_id) 
		REFERENCES playlists(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT videos_playlists_video_id_fk
		FOREIGN KEY (video_id) 
		REFERENCES videos(id)
		ON UPDATE CASCADE;

	
ALTER TABLE comments 
	ADD CONSTRAINT comments_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT comments_object_type_id_fk
		FOREIGN KEY (object_type_id) 
		REFERENCES object_types(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT comments_video_id_fk
		FOREIGN KEY (object_id) 
		REFERENCES videos(id)
		ON UPDATE CASCADE, 
	ADD CONSTRAINT comments_comments_id_fk
		FOREIGN KEY (object_id) 
		REFERENCES comments(id)
		ON UPDATE CASCADE;

ALTER TABLE assessments 
	ADD CONSTRAINT assessments_channel_id_fk
		FOREIGN KEY (channel_id) 
		REFERENCES channels(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT assessments_object_type_id_fk
		FOREIGN KEY (object_type_id) 
		REFERENCES object_types(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT assessments_video_id_fk
		FOREIGN KEY (object_id) 
		REFERENCES videos(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT assessments_comments_id_fk
		FOREIGN KEY (object_id) 
		REFERENCES comments(id)
		ON UPDATE CASCADE,
	ADD CONSTRAINT assessments_assessment_type_id_fk
		FOREIGN KEY (assessment_type_id) 
		REFERENCES assessment_types(id)
		ON UPDATE CASCADE;